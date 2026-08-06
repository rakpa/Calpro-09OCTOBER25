import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/finance_math.dart';
import 'package:calcpro/theme/app_theme.dart';

Future<void> showAmortizationSheet(
  BuildContext context, {
  required double principal,
  required double annualPercent,
  required double years,
  String title = 'Amortization schedule',
}) async {
  final rows = FinanceMath.amortizationSchedule(
    principal: principal,
    annualPercent: annualPercent,
    years: years,
  );
  final currency = NumberFormat.currency(symbol: '\$');

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceDark
        : AppColors.surfaceRaised,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (context, controller) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(child: Text(title, style: AppFonts.h3())),
                    Text(
                      '${rows.length} mo',
                      style: AppFonts.body2(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _H('Mo', flex: 1),
                    _H('Payment', flex: 2),
                    _H('Principal', flex: 2),
                    _H('Interest', flex: 2),
                    _H('Balance', flex: 2),
                  ],
                ),
              ),
              const Divider(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: rows.length,
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          _C('${r.month}', flex: 1),
                          _C(currency.format(r.payment), flex: 2),
                          _C(currency.format(r.principal), flex: 2),
                          _C(currency.format(r.interest), flex: 2),
                          _C(currency.format(r.balance), flex: 2),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _H extends StatelessWidget {
  final String text;
  final int flex;
  const _H(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppFonts.body2().copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _C extends StatelessWidget {
  final String text;
  final int flex;
  const _C(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(text, style: AppFonts.body2()),
    );
  }
}
