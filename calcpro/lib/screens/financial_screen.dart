import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/finance_math.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/amortization_sheet.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

/// Real EMI + compound interest — matches top finance calculator apps.
class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  int mode = 0; // 0 EMI, 1 Compound
  final principal = TextEditingController(text: '250000');
  final rate = TextEditingController(text: '8.5');
  final tenure = TextEditingController(text: '20');
  final currency = NumberFormat.currency(symbol: '\$');

  double? emi;
  double? totalPayment;
  double? totalInterest;
  double? futureValue;
  double? interestEarned;

  @override
  void initState() {
    super.initState();
    for (final c in [principal, rate, tenure]) {
      c.addListener(() => setState(() {}));
    }
    _calculate();
  }

  @override
  void dispose() {
    principal.dispose();
    rate.dispose();
    tenure.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      principal.clear();
      rate.clear();
      tenure.clear();
      emi = totalPayment = totalInterest = futureValue = interestEarned = null;
    });
  }

  void _calculate() {
    final p = double.tryParse(principal.text);
    final annual = double.tryParse(rate.text);
    final years = double.tryParse(tenure.text);
    if (p == null || annual == null || years == null || years <= 0) return;

    if (mode == 0) {
      final payment = FinanceMath.emi(
        principal: p,
        annualPercent: annual,
        years: years,
      );
      final n = years * 12;
      final total = payment * n;
      setState(() {
        emi = double.parse(payment.toStringAsFixed(2));
        totalPayment = double.parse(total.toStringAsFixed(2));
        totalInterest = double.parse((total - p).toStringAsFixed(2));
        futureValue = interestEarned = null;
      });
      AppState.instance.addHistory(
        route: '/financial',
        title: 'EMI',
        result: '${currency.format(emi)}/mo',
      );
    } else {
      final amount = FinanceMath.futureValue(
        principal: p,
        annualPercent: annual,
        years: years,
      );
      setState(() {
        futureValue = double.parse(amount.toStringAsFixed(2));
        interestEarned = double.parse((futureValue! - p).toStringAsFixed(2));
        emi = totalPayment = totalInterest = null;
      });
      AppState.instance.addHistory(
        route: '/financial',
        title: 'Compound Interest',
        result: currency.format(futureValue),
      );
    }
    WidgetSync.publish();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ready = principal.text.isNotEmpty &&
        rate.text.isNotEmpty &&
        tenure.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('EMI / Interest'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/financial');
              return IconButton(
                onPressed: () =>
                    AppState.instance.toggleFavorite('/financial'),
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SegmentControl(
            labels: const ['EMI Loan', 'Compound'],
            index: mode,
            onChanged: (i) {
              if (i == mode) return;
              setState(() {
                mode = i;
                emi = totalPayment = totalInterest = null;
                futureValue = interestEarned = null;
              });
            },
          ),
          const SizedBox(height: 16),
          if (mode == 0 && emi != null) ...[
            PremiumResultCard(
              eyebrow: 'Monthly EMI',
              value: currency.format(emi),
              detail:
                  'Interest ${currency.format(totalInterest)} · Total ${currency.format(totalPayment)}',
            ),
            const SizedBox(height: 12),
          ],
          if (mode == 1 && futureValue != null) ...[
            PremiumResultCard(
              eyebrow: 'Future value',
              value: currency.format(futureValue),
              detail: 'Interest earned ${currency.format(interestEarned)}',
              colors: const [
                Color(0xFFE8F4FF),
                Color(0xFFE8FFF3),
                Color(0xFFEDE8FF),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          AppCard(
            child: Column(
              children: [
                LabeledField(
                  label: mode == 0 ? 'Loan amount' : 'Principal',
                  controller: principal,
                  compact: true,
                ),
                const Divider(height: 24),
                LabeledField(
                  label: 'Annual interest rate (%)',
                  controller: rate,
                  compact: true,
                ),
                const Divider(height: 24),
                LabeledField(
                  label: mode == 0 ? 'Tenure (years)' : 'Time (years)',
                  controller: tenure,
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mode == 0
                ? 'EMI = P × r × (1+r)ⁿ / ((1+r)ⁿ − 1) · r = monthly rate'
                : 'A = P(1 + r)ᵗ · annual compounding',
            style: AppFonts.body2(
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Calculate',
            onPressed: ready
                ? () {
                    HapticFeedback.lightImpact();
                    _calculate();
                  }
                : null,
          ),
          if (mode == 0 && emi != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                final p = double.tryParse(principal.text);
                final annual = double.tryParse(rate.text);
                final years = double.tryParse(tenure.text);
                if (p == null || annual == null || years == null) return;
                showAmortizationSheet(
                  context,
                  principal: p,
                  annualPercent: annual,
                  years: years,
                  title: 'EMI amortization',
                );
              },
              child: const Text('View amortization schedule'),
            ),
          ],
        ],
      ),
    );
  }
}
