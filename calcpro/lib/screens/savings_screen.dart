import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/finance_math.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final principal = TextEditingController(text: '5000');
  final monthly = TextEditingController(text: '300');
  final rate = TextEditingController(text: '7');
  final years = TextEditingController(text: '10');
  final currency = NumberFormat.currency(symbol: '\$');
  double? future;
  double? contributed;
  double? earned;

  @override
  void initState() {
    super.initState();
    for (final c in [principal, monthly, rate, years]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    principal.dispose();
    monthly.dispose();
    rate.dispose();
    years.dispose();
    super.dispose();
  }

  void _recalc() {
    final p = double.tryParse(principal.text);
    final m = double.tryParse(monthly.text) ?? 0;
    final r = double.tryParse(rate.text);
    final y = double.tryParse(years.text);
    if (p == null || r == null || y == null) {
      setState(() => future = contributed = earned = null);
      return;
    }
    final fv = FinanceMath.futureValue(
      principal: p,
      annualPercent: r,
      years: y,
      monthlyDeposit: m,
    );
    final totalIn = p + m * y * 12;
    setState(() {
      future = double.parse(fv.toStringAsFixed(2));
      contributed = double.parse(totalIn.toStringAsFixed(2));
      earned = double.parse((fv - totalIn).toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(title: const Text('Savings Growth')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (future != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('Future value', style: AppFonts.body2()),
                  Text(currency.format(future), style: AppFonts.result()),
                  const SizedBox(height: 8),
                  Text(
                    'Contributed ${currency.format(contributed)} · Earned ${currency.format(earned)}',
                    textAlign: TextAlign.center,
                    style: AppFonts.body1(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Starting amount', controller: principal, compact: true),
                const Divider(height: 24),
                LabeledField(label: 'Monthly deposit', controller: monthly, compact: true),
                const Divider(height: 24),
                LabeledField(label: 'Annual return (%)', controller: rate, compact: true),
                const Divider(height: 24),
                LabeledField(label: 'Years', controller: years, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: future == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/savings',
                      title: 'Savings',
                      result: currency.format(future),
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
