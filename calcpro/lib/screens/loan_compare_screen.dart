import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/finance_math.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class LoanCompareScreen extends StatefulWidget {
  const LoanCompareScreen({super.key});

  @override
  State<LoanCompareScreen> createState() => _LoanCompareScreenState();
}

class _LoanCompareScreenState extends State<LoanCompareScreen> {
  final aP = TextEditingController();
  final aR = TextEditingController();
  final aY = TextEditingController();
  final bP = TextEditingController();
  final bR = TextEditingController();
  final bY = TextEditingController();
  final currency = NumberFormat.currency(symbol: '\$');

  double? aEmi;
  double? bEmi;
  double? aTotal;
  double? bTotal;
  String? winner;

  @override
  void initState() {
    super.initState();
    for (final c in [aP, aR, aY, bP, bR, bY]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    for (final c in [aP, aR, aY, bP, bR, bY]) {
      c.dispose();
    }
    super.dispose();
  }

  void _recalc() {
    final ap = double.tryParse(aP.text);
    final ar = double.tryParse(aR.text);
    final ay = double.tryParse(aY.text);
    final bp = double.tryParse(bP.text);
    final br = double.tryParse(bR.text);
    final by = double.tryParse(bY.text);
    if ([ap, ar, ay, bp, br, by].any((v) => v == null)) {
      setState(() {
        aEmi = bEmi = aTotal = bTotal = null;
        winner = null;
      });
      return;
    }
    final ae = FinanceMath.emi(principal: ap!, annualPercent: ar!, years: ay!);
    final be = FinanceMath.emi(principal: bp!, annualPercent: br!, years: by!);
    final at = ae * ay * 12;
    final bt = be * by * 12;
    setState(() {
      aEmi = double.parse(ae.toStringAsFixed(2));
      bEmi = double.parse(be.toStringAsFixed(2));
      aTotal = double.parse(at.toStringAsFixed(2));
      bTotal = double.parse(bt.toStringAsFixed(2));
      if ((at - bt).abs() < 1) {
        winner = 'Similar total cost';
      } else if (at < bt) {
        winner = 'Loan A costs less overall';
      } else {
        winner = 'Loan B costs less overall';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Compare Loans')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (winner != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text(winner!, style: AppFonts.h3(), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('A EMI', style: AppFonts.body2()),
                            Text(currency.format(aEmi), style: AppFonts.body1()),
                            Text('Total ${currency.format(aTotal)}',
                                style: AppFonts.body2()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('B EMI', style: AppFonts.body2()),
                            Text(currency.format(bEmi), style: AppFonts.body1()),
                            Text('Total ${currency.format(bTotal)}',
                                style: AppFonts.body2()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loan A', style: AppFonts.h3()),
                const SizedBox(height: 8),
                LabeledField(label: 'Principal', controller: aP, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Rate %', controller: aR, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Years', controller: aY, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loan B', style: AppFonts.h3()),
                const SizedBox(height: 8),
                LabeledField(label: 'Principal', controller: bP, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Rate %', controller: bR, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Years', controller: bY, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save comparison',
            onPressed: winner == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/loan-compare',
                      title: 'Loan Compare',
                      result: winner!,
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
