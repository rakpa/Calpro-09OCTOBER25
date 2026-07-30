import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class MortgageScreen extends StatefulWidget {
  const MortgageScreen({super.key});

  @override
  State<MortgageScreen> createState() => _MortgageScreenState();
}

class _MortgageScreenState extends State<MortgageScreen> {
  int mode = 0;
  final principal = TextEditingController(text: '350000');
  final down = TextEditingController(text: '70000');
  final rate = TextEditingController(text: '6.5');
  final term = TextEditingController(text: '30');
  final propertyTax = TextEditingController();
  final insurance = TextEditingController();

  String? monthlyPayment;
  String? totalPayment;
  String? totalInterest;
  final currency = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    for (final c in [principal, down, rate, term, propertyTax, insurance]) {
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
      monthlyPayment = totalPayment = totalInterest = null;
    });
  }

  void _calculate() {
    final home = double.tryParse(principal.text);
    final downPayment = double.tryParse(down.text) ?? 0;
    final annualRate = double.tryParse(rate.text);
    final years = double.tryParse(term.text);
    if (home == null || annualRate == null || years == null) return;

    final p = (home - downPayment).clamp(0, double.infinity);
    final r = (annualRate / 100) / 12;
    final n = years * 12;
    final monthlyTax =
        propertyTax.text.isEmpty ? 0.0 : (double.tryParse(propertyTax.text) ?? 0) / 12;
    final monthlyIns =
        insurance.text.isEmpty ? 0.0 : (double.tryParse(insurance.text) ?? 0) / 12;

    double mortgagePayment;
    if (r == 0) {
      mortgagePayment = p / n;
    } else {
      mortgagePayment =
          p * (r * math.pow(1 + r, n)) / (math.pow(1 + r, n) - 1);
    }

    final totalMonthly = mortgagePayment + monthlyTax + monthlyIns;
    setState(() {
      monthlyPayment = totalMonthly.toStringAsFixed(2);
      totalPayment = (totalMonthly * n).toStringAsFixed(2);
      totalInterest = ((mortgagePayment * n) - p).toStringAsFixed(2);
    });
    AppState.instance.addHistory(
      route: '/mortgage',
      title: 'Mortgage',
      result: '\$$monthlyPayment/mo',
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ready = principal.text.isNotEmpty &&
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
          IconButton(onPressed: _clear, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SegmentControl(
              labels: const ['Monthly Payment', 'Affordability'],
              index: mode,
              onChanged: (i) => setState(() => mode = i),
            ),
            const SizedBox(height: 20),
            if (monthlyPayment != null)
              Column(
                children: [
                  Text(
                    'Monthly Payment',
                    style: TextStyle(
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currency.format(double.tryParse(monthlyPayment!) ?? 0),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: dark ? AppColors.inkDark : AppColors.ink,
                    ),
                  ),
                  if (totalInterest != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Total interest ${currency.format(double.tryParse(totalInterest!) ?? 0)}',
                      style: TextStyle(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                children: [
                  LabeledField(
                    label: 'Home Price',
                    controller: principal,
                    compact: true,
                    hint: '0',
                  ),
                  const Divider(height: 24),
                  LabeledField(
                    label: 'Down Payment',
                    controller: down,
                    compact: true,
                    hint: '0',
                  ),
                  const Divider(height: 24),
                  LabeledField(
                    label: 'Interest Rate',
                    controller: rate,
                    compact: true,
                    hint: '%',
                  ),
                  const Divider(height: 24),
                  LabeledField(
                    label: 'Loan Term',
                    controller: term,
                    compact: true,
                    hint: 'Years',
                  ),
                  if (mode == 0) ...[
                    const Divider(height: 24),
                    LabeledField(
                      label: 'Property Tax / yr',
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Calculate',
              onPressed: ready ? _calculate : null,
            ),
          ],
        ),
      ),
    );
  }
}
