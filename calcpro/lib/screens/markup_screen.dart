import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class MarkupScreen extends StatefulWidget {
  const MarkupScreen({super.key});

  @override
  State<MarkupScreen> createState() => _MarkupScreenState();
}

class _MarkupScreenState extends State<MarkupScreen> {
  int mode = 0; // 0 markup, 1 margin
  final cost = TextEditingController(text: '40');
  final percent = TextEditingController(text: '50');
  final currency = NumberFormat.currency(symbol: '\$');
  double? price;
  double? profit;

  @override
  void initState() {
    super.initState();
    for (final c in [cost, percent]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    cost.dispose();
    percent.dispose();
    super.dispose();
  }

  void _recalc() {
    final c = double.tryParse(cost.text);
    final p = double.tryParse(percent.text);
    if (c == null || p == null) {
      setState(() => price = profit = null);
      return;
    }
    if (mode == 0) {
      final sell = c * (1 + p / 100);
      setState(() {
        price = double.parse(sell.toStringAsFixed(2));
        profit = double.parse((sell - c).toStringAsFixed(2));
      });
    } else {
      if (p >= 100) {
        setState(() => price = profit = null);
        return;
      }
      final sell = c / (1 - p / 100);
      setState(() {
        price = double.parse(sell.toStringAsFixed(2));
        profit = double.parse((sell - c).toStringAsFixed(2));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Markup / Margin')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SegmentControl(
            labels: const ['Markup %', 'Margin %'],
            index: mode,
            onChanged: (i) {
              setState(() => mode = i);
              _recalc();
            },
          ),
          const SizedBox(height: 16),
          if (price != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('Selling price', style: AppFonts.body2()),
                  Text(currency.format(price), style: AppFonts.result()),
                  Text('Profit ${currency.format(profit)}', style: AppFonts.body1()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Cost', controller: cost, compact: true),
                const Divider(height: 24),
                LabeledField(
                  label: mode == 0 ? 'Markup (%)' : 'Margin (%)',
                  controller: percent,
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: price == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/markup',
                      title: mode == 0 ? 'Markup' : 'Margin',
                      result: currency.format(price),
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
