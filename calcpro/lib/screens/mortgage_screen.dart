import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/finance_math.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/amortization_sheet.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class MortgageScreen extends StatefulWidget {
  const MortgageScreen({super.key});

  @override
  State<MortgageScreen> createState() => _MortgageScreenState();
}

class _MortgageScreenState extends State<MortgageScreen> {
  int mode = 0; // 0 payment, 1 affordability
  final principal = TextEditingController(text: '350000');
  final down = TextEditingController(text: '70000');
  final rate = TextEditingController(text: '6.5');
  final term = TextEditingController(text: '30');
  final propertyTax = TextEditingController();
  final insurance = TextEditingController();
  final income = TextEditingController(text: '9000');
  final debts = TextEditingController(text: '500');
  final dti = TextEditingController(text: '36');

  String? monthlyPayment;
  String? totalPayment;
  String? totalInterest;
  String? affordableHome;
  String? affordableLoan;
  String? maxMonthly;
  final currency = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    for (final c in [
      principal,
      down,
      rate,
      term,
      propertyTax,
      insurance,
      income,
      debts,
      dti,
    ]) {
      c.addListener(() => setState(() {}));
    }
    _calculate();
  }

  @override
  void dispose() {
    principal.dispose();
    down.dispose();
    rate.dispose();
    term.dispose();
    propertyTax.dispose();
    insurance.dispose();
    income.dispose();
    debts.dispose();
    dti.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      principal.clear();
      down.clear();
      rate.clear();
      term.clear();
      propertyTax.clear();
      insurance.clear();
      income.clear();
      debts.clear();
      dti.clear();
      monthlyPayment = totalPayment = totalInterest = null;
      affordableHome = affordableLoan = maxMonthly = null;
    });
  }

  void _calculate() {
    final annualRate = double.tryParse(rate.text);
    final years = double.tryParse(term.text);
    if (annualRate == null || years == null) return;

    if (mode == 0) {
      final home = double.tryParse(principal.text);
      final downPayment = double.tryParse(down.text) ?? 0;
      if (home == null) return;
      final p = (home - downPayment).clamp(0, double.infinity).toDouble();
      final monthlyTax = propertyTax.text.isEmpty
          ? 0.0
          : (double.tryParse(propertyTax.text) ?? 0) / 12;
      final monthlyIns = insurance.text.isEmpty
          ? 0.0
          : (double.tryParse(insurance.text) ?? 0) / 12;
      final mortgagePayment = FinanceMath.emi(
        principal: p,
        annualPercent: annualRate,
        years: years,
      );
      final totalMonthly = mortgagePayment + monthlyTax + monthlyIns;
      final n = years * 12;
      setState(() {
        monthlyPayment = totalMonthly.toStringAsFixed(2);
        totalPayment = (totalMonthly * n).toStringAsFixed(2);
        totalInterest = ((mortgagePayment * n) - p).toStringAsFixed(2);
        affordableHome = affordableLoan = maxMonthly = null;
      });
      AppState.instance.addHistory(
        route: '/mortgage',
        title: 'Mortgage',
        result: '\$$monthlyPayment/mo',
      );
    } else {
      final monthlyIncome = double.tryParse(income.text);
      final monthlyDebts = double.tryParse(debts.text) ?? 0;
      final dtiPct = double.tryParse(dti.text) ?? 36;
      final downPayment = double.tryParse(down.text) ?? 0;
      if (monthlyIncome == null) return;
      final budget = (monthlyIncome * dtiPct / 100) - monthlyDebts;
      final monthlyTax = propertyTax.text.isEmpty
          ? 0.0
          : (double.tryParse(propertyTax.text) ?? 0) / 12;
      final monthlyIns = insurance.text.isEmpty
          ? 0.0
          : (double.tryParse(insurance.text) ?? 0) / 12;
      final mortgageBudget =
          (budget - monthlyTax - monthlyIns).clamp(0, double.infinity).toDouble();
      final loan = FinanceMath.loanFromPayment(
        payment: mortgageBudget,
        annualPercent: annualRate,
        years: years,
      );
      final home = loan + downPayment;
      setState(() {
        maxMonthly = mortgageBudget.toStringAsFixed(2);
        affordableLoan = loan.toStringAsFixed(2);
        affordableHome = home.toStringAsFixed(2);
        monthlyPayment = totalPayment = totalInterest = null;
      });
      AppState.instance.addHistory(
        route: '/mortgage',
        title: 'Affordability',
        result: 'Up to \$$affordableHome',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ready = mode == 0
        ? principal.text.isNotEmpty &&
            rate.text.isNotEmpty &&
            term.text.isNotEmpty
        : income.text.isNotEmpty &&
            rate.text.isNotEmpty &&
            term.text.isNotEmpty;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Mortgage'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/mortgage');
              return IconButton(
                onPressed: () =>
                    AppState.instance.toggleFavorite('/mortgage'),
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? AppColors.accentPink : null,
                ),
              );
            },
          ),
          IconButton(
            onPressed: _clear,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SegmentControl(
              labels: const ['Payment', 'Affordability'],
              index: mode,
              onChanged: (i) {
                setState(() => mode = i);
                _calculate();
              },
            ),
            const SizedBox(height: 20),
            if (mode == 0 && monthlyPayment != null)
              AppCard(
                color: AppColors.resultBg,
                child: Column(
                  children: [
                    Text('Monthly payment', style: AppFonts.body2()),
                    const SizedBox(height: 4),
                    Text(
                      currency.format(double.tryParse(monthlyPayment!) ?? 0),
                      style: AppFonts.result(),
                    ),
                    if (totalInterest != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Total interest ${currency.format(double.tryParse(totalInterest!) ?? 0)}',
                        style: AppFonts.body1(),
                      ),
                    ],
                  ],
                ),
              ),
            if (mode == 1 && affordableHome != null)
              AppCard(
                color: AppColors.resultBg,
                child: Column(
                  children: [
                    Text('You can afford about', style: AppFonts.body2()),
                    const SizedBox(height: 4),
                    Text(
                      currency.format(double.tryParse(affordableHome!) ?? 0),
                      style: AppFonts.result(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loan ${currency.format(double.tryParse(affordableLoan!) ?? 0)} · Max housing ${currency.format(double.tryParse(maxMonthly!) ?? 0)}/mo',
                      textAlign: TextAlign.center,
                      style: AppFonts.body1(),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                children: [
                  if (mode == 0) ...[
                    LabeledField(
                      label: 'Home price',
                      controller: principal,
                      compact: true,
                    ),
                    const Divider(height: 24),
                  ] else ...[
                    LabeledField(
                      label: 'Gross monthly income',
                      controller: income,
                      compact: true,
                    ),
                    const Divider(height: 24),
                    LabeledField(
                      label: 'Other monthly debts',
                      controller: debts,
                      compact: true,
                    ),
                    const Divider(height: 24),
                    LabeledField(
                      label: 'Max DTI (%)',
                      controller: dti,
                      compact: true,
                    ),
                    const Divider(height: 24),
                  ],
                  LabeledField(
                    label: 'Down payment',
                    controller: down,
                    compact: true,
                  ),
                  const Divider(height: 24),
                  LabeledField(
                    label: 'Interest rate (%)',
                    controller: rate,
                    compact: true,
                  ),
                  const Divider(height: 24),
                  LabeledField(
                    label: 'Loan term (years)',
                    controller: term,
                    compact: true,
                  ),
                  const Divider(height: 24),
                  LabeledField(
                    label: 'Property tax / yr',
                    controller: propertyTax,
                    compact: true,
                    hint: 'Optional',
                  ),
                  const Divider(height: 24),
                  LabeledField(
                    label: 'Insurance / yr',
                    controller: insurance,
                    compact: true,
                    hint: 'Optional',
                  ),
                ],
              ),
            ),
            if (mode == 1) ...[
              const SizedBox(height: 12),
              Text(
                'Uses debt-to-income (DTI) — lenders often cap housing+debts near 36%.',
                style: AppFonts.body2(
                  color: dark ? AppColors.mutedDark : AppColors.muted,
                ),
              ),
            ],
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Calculate',
              onPressed: ready ? _calculate : null,
            ),
            if (mode == 0 && monthlyPayment != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  final home = double.tryParse(principal.text);
                  final downPayment = double.tryParse(down.text) ?? 0;
                  final annualRate = double.tryParse(rate.text);
                  final years = double.tryParse(term.text);
                  if (home == null || annualRate == null || years == null) {
                    return;
                  }
                  showAmortizationSheet(
                    context,
                    principal: (home - downPayment).clamp(0, double.infinity),
                    annualPercent: annualRate,
                    years: years,
                    title: 'Mortgage amortization',
                  );
                },
                child: const Text('View amortization schedule'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
