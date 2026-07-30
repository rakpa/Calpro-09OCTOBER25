import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  final principal = TextEditingController();
  final rate = TextEditingController();
  final time = TextEditingController();
  double? futureValue;
  double? interestEarned;
  final currency = NumberFormat.currency(symbol: '\$');

  @override
  void initState() {
    super.initState();
    for (final c in [principal, rate, time]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    principal.dispose();
    rate.dispose();
    time.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      principal.clear();
      rate.clear();
      time.clear();
      futureValue = null;
      interestEarned = null;
    });
  }

  void _calculate() {
    final p = double.tryParse(principal.text);
    final r = double.tryParse(rate.text);
    final t = double.tryParse(time.text);
    if (p == null || r == null || t == null) return;
    final amount = p * math.pow(1 + r / 100, t);
    setState(() {
      futureValue = double.parse(amount.toStringAsFixed(2));
      interestEarned = futureValue! - p;
    });
    AppState.instance.addHistory(
      route: '/financial',
      title: 'EMI / Interest',
      result: currency.format(futureValue),
    );
    WidgetSync.publish();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ready = principal.text.isNotEmpty &&
        rate.text.isNotEmpty &&
        time.text.isNotEmpty;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
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
          IconButton(onPressed: _clear, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (futureValue != null)
            AppCard(
              child: Column(
                children: [
                  Text('Future value', style: AppFonts.body2()),
                  Text(currency.format(futureValue), style: AppFonts.result()),
                  Text(
                    'Interest ${currency.format(interestEarned)}',
                    style: AppFonts.body1(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Principal', controller: principal, compact: true),
                const Divider(height: 24),
                LabeledField(label: 'Rate % / yr', controller: rate, compact: true),
                const Divider(height: 24),
                LabeledField(label: 'Years', controller: time, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Calculate', onPressed: ready ? _calculate : null),
        ],
      ),
    );
  }
}
