import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  final distance = TextEditingController(text: '320');
  final fuel = TextEditingController(text: '12.5');
  final price = TextEditingController(text: '3.49');
  final currency = NumberFormat.currency(symbol: '\$');
  double? mpg;
  double? costPerMile;
  double? tripCost;

  @override
  void initState() {
    super.initState();
    for (final c in [distance, fuel, price]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    distance.dispose();
    fuel.dispose();
    price.dispose();
    super.dispose();
  }

  void _recalc() {
    final d = double.tryParse(distance.text);
    final f = double.tryParse(fuel.text);
    final p = double.tryParse(price.text);
    if (d == null || f == null || f == 0 || p == null) {
      setState(() => mpg = costPerMile = tripCost = null);
      return;
    }
    final m = d / f;
    final trip = f * p;
    setState(() {
      mpg = double.parse(m.toStringAsFixed(2));
      tripCost = double.parse(trip.toStringAsFixed(2));
      costPerMile = double.parse((trip / d).toStringAsFixed(3));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(title: const Text('Fuel Efficiency')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (mpg != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('${mpg!.toStringAsFixed(2)} MPG', style: AppFonts.result()),
                  Text(
                    'Trip ${currency.format(tripCost)} · ${currency.format(costPerMile)}/mi',
                    style: AppFonts.body1(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Distance (miles)', controller: distance, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Fuel used (gallons)', controller: fuel, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Fuel price / gallon', controller: price, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: mpg == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/fuel',
                      title: 'Fuel',
                      result: '${mpg!.toStringAsFixed(2)} MPG',
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
