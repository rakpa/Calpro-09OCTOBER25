import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

/// Unit price comparison — shopping staple from top App Store suites.
class UnitPriceScreen extends StatefulWidget {
  const UnitPriceScreen({super.key});

  @override
  State<UnitPriceScreen> createState() => _UnitPriceScreenState();
}

class _UnitPriceScreenState extends State<UnitPriceScreen> {
  final aPrice = TextEditingController(text: '4.99');
  final aQty = TextEditingController(text: '12');
  final bPrice = TextEditingController(text: '7.49');
  final bQty = TextEditingController(text: '20');
  final currency = NumberFormat.currency(symbol: '\$');

  double? aUnit;
  double? bUnit;
  String? winner;

  @override
  void initState() {
    super.initState();
    for (final c in [aPrice, aQty, bPrice, bQty]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    aPrice.dispose();
    aQty.dispose();
    bPrice.dispose();
    bQty.dispose();
    super.dispose();
  }

  void _recalc() {
    final ap = double.tryParse(aPrice.text);
    final aq = double.tryParse(aQty.text);
    final bp = double.tryParse(bPrice.text);
    final bq = double.tryParse(bQty.text);
    if (ap == null || aq == null || aq == 0 || bp == null || bq == null || bq == 0) {
      setState(() {
        aUnit = bUnit = null;
        winner = null;
      });
      return;
    }
    final au = ap / aq;
    final bu = bp / bq;
    setState(() {
      aUnit = double.parse(au.toStringAsFixed(4));
      bUnit = double.parse(bu.toStringAsFixed(4));
      if ((au - bu).abs() < 0.00005) {
        winner = 'Same unit price';
      } else if (au < bu) {
        winner = 'Option A is better';
      } else {
        winner = 'Option B is better';
      }
    });
  }

  void _save() {
    if (winner == null) return;
    AppState.instance.addHistory(
      route: '/unit-price',
      title: 'Unit Price',
      result: winner!,
    );
    WidgetSync.publish();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Unit Price'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/unit-price');
              return IconButton(
                onPressed: () =>
                    AppState.instance.toggleFavorite('/unit-price'),
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? AppColors.accentPink : null,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (winner != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text(winner!, style: AppFonts.h3()),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _PriceStat(
                          label: 'A per unit',
                          value: currency.format(aUnit),
                          best: winner!.contains('A'),
                        ),
                      ),
                      Expanded(
                        child: _PriceStat(
                          label: 'B per unit',
                          value: currency.format(bUnit),
                          best: winner!.contains('B'),
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
                Text('Option A', style: AppFonts.h3()),
                const SizedBox(height: 8),
                LabeledField(label: 'Price', controller: aPrice, compact: true),
                const Divider(height: 24),
                LabeledField(
                  label: 'Quantity / size',
                  controller: aQty,
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Option B', style: AppFonts.h3()),
                const SizedBox(height: 8),
                LabeledField(label: 'Price', controller: bPrice, compact: true),
                const Divider(height: 24),
                LabeledField(
                  label: 'Quantity / size',
                  controller: bQty,
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Compare cost per unit — oz, liters, pieces, anything with the same unit.',
            style: AppFonts.body2(
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save comparison',
            onPressed: winner == null ? null : _save,
          ),
        ],
      ),
    );
  }
}

class _PriceStat extends StatelessWidget {
  final String label;
  final String value;
  final bool best;
  const _PriceStat({
    required this.label,
    required this.value,
    required this.best,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppFonts.body2()),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFonts.body1().copyWith(
            fontWeight: FontWeight.w800,
            color: best ? AppColors.resultText : null,
          ),
        ),
      ],
    );
  }
}
