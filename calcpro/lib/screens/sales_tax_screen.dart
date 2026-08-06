import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

/// Sales tax — staple tool in top everyday calculator apps.
class SalesTaxScreen extends StatefulWidget {
  const SalesTaxScreen({super.key});

  @override
  State<SalesTaxScreen> createState() => _SalesTaxScreenState();
}

class _SalesTaxScreenState extends State<SalesTaxScreen> {
  final price = TextEditingController();
  final taxRate = TextEditingController();
  final currency = NumberFormat.currency(symbol: '\$');
  bool addTax = true;

  double? taxAmount;
  double? total;

  @override
  void initState() {
    super.initState();
    for (final c in [price, taxRate]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    price.dispose();
    taxRate.dispose();
    super.dispose();
  }

  void _recalc() {
    final p = double.tryParse(price.text);
    final r = double.tryParse(taxRate.text);
    if (p == null || r == null) {
      setState(() {
        taxAmount = total = null;
      });
      return;
    }
    if (addTax) {
      final tax = p * r / 100;
      setState(() {
        taxAmount = double.parse(tax.toStringAsFixed(2));
        total = double.parse((p + tax).toStringAsFixed(2));
      });
    } else {
      // price includes tax — extract pre-tax
      final pretax = p / (1 + r / 100);
      final tax = p - pretax;
      setState(() {
        taxAmount = double.parse(tax.toStringAsFixed(2));
        total = double.parse(pretax.toStringAsFixed(2));
      });
    }
  }

  void _save() {
    if (total == null) return;
    AppState.instance.addHistory(
      route: '/sales-tax',
      title: 'Sales Tax',
      result: addTax
          ? 'Total ${currency.format(total)}'
          : 'Pre-tax ${currency.format(total)}',
    );
    WidgetSync.publish();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Sales Tax'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/sales-tax');
              return IconButton(
                onPressed: () =>
                    AppState.instance.toggleFavorite('/sales-tax'),
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
          SegmentControl(
            labels: const ['Add tax', 'Remove tax'],
            index: addTax ? 0 : 1,
            onChanged: (i) {
              setState(() => addTax = i == 0);
              _recalc();
            },
          ),
          const SizedBox(height: 16),
          if (total != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text(
                    addTax ? 'Total with tax' : 'Price before tax',
                    style: AppFonts.body2(),
                  ),
                  const SizedBox(height: 4),
                  Text(currency.format(total), style: AppFonts.result()),
                  const SizedBox(height: 8),
                  Text(
                    'Tax ${currency.format(taxAmount)}',
                    style: AppFonts.body1(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(
                  label: addTax ? 'Price (before tax)' : 'Price (includes tax)',
                  controller: price,
                  compact: true,
                ),
                const Divider(height: 24),
                LabeledField(
                  label: 'Sales tax rate (%)',
                  controller: taxRate,
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final rate in ['5', '7.5', '8.25', '10', '13'])
                ActionChip(
                  label: Text('$rate%'),
                  onPressed: () {
                    taxRate.text = rate;
                    _recalc();
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: total == null ? null : _save,
          ),
        ],
      ),
    );
  }
}
