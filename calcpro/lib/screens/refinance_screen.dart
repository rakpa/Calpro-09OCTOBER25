import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/finance_math.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class RefinanceScreen extends StatefulWidget {
  const RefinanceScreen({super.key});

  @override
  State<RefinanceScreen> createState() => _RefinanceScreenState();
}

class _RefinanceScreenState extends State<RefinanceScreen> {
  final balance = TextEditingController(text: '280000');
  final oldRate = TextEditingController(text: '7.2');
  final oldYearsLeft = TextEditingController(text: '25');
  final newRate = TextEditingController(text: '6.1');
  final newYears = TextEditingController(text: '25');
  final closing = TextEditingController(text: '3500');
  final currency = NumberFormat.currency(symbol: '\$');

  double? oldEmi;
  double? newEmi;
  double? monthlySave;
  double? breakEvenMonths;

  @override
  void initState() {
    super.initState();
    for (final c in [balance, oldRate, oldYearsLeft, newRate, newYears, closing]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    for (final c in [balance, oldRate, oldYearsLeft, newRate, newYears, closing]) {
      c.dispose();
    }
    super.dispose();
  }

  void _recalc() {
    final p = double.tryParse(balance.text);
    final or = double.tryParse(oldRate.text);
    final oy = double.tryParse(oldYearsLeft.text);
    final nr = double.tryParse(newRate.text);
    final ny = double.tryParse(newYears.text);
    final cost = double.tryParse(closing.text) ?? 0;
    if ([p, or, oy, nr, ny].any((v) => v == null)) {
      setState(() {
        oldEmi = newEmi = monthlySave = breakEvenMonths = null;
      });
      return;
    }
    final oe = FinanceMath.emi(principal: p!, annualPercent: or!, years: oy!);
    final ne = FinanceMath.emi(principal: p, annualPercent: nr!, years: ny!);
    final save = oe - ne;
    setState(() {
      oldEmi = double.parse(oe.toStringAsFixed(2));
      newEmi = double.parse(ne.toStringAsFixed(2));
      monthlySave = double.parse(save.toStringAsFixed(2));
      breakEvenMonths = save <= 0
          ? null
          : double.parse((cost / save).toStringAsFixed(1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(title: const Text('Refinance')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (monthlySave != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text(
                    monthlySave! >= 0
                        ? 'Save ${currency.format(monthlySave)}/mo'
                        : 'Costs ${currency.format(-monthlySave!)}/mo more',
                    style: AppFonts.h3(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Old ${currency.format(oldEmi)} → New ${currency.format(newEmi)}',
                    style: AppFonts.body1(),
                  ),
                  if (breakEvenMonths != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Break-even ~ ${breakEvenMonths!.toStringAsFixed(1)} months',
                      style: AppFonts.body2(),
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Current balance', controller: balance, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Current rate %', controller: oldRate, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Years left', controller: oldYearsLeft, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'New rate %', controller: newRate, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'New term (years)', controller: newYears, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Closing costs', controller: closing, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: monthlySave == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/refinance',
                      title: 'Refinance',
                      result: '${currency.format(monthlySave)}/mo',
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
