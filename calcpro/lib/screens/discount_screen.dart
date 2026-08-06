import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  int mode = 0;
  final singlePrice = TextEditingController();
  final singleDiscount = TextEditingController();
  final multiPrice = TextEditingController();
  final d1 = TextEditingController();
  final d2 = TextEditingController();
  final d3 = TextEditingController();
  String? finalPrice;
  String? saved;

  @override
  void initState() {
    super.initState();
    for (final c in [singlePrice, singleDiscount, multiPrice, d1, d2, d3]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [singlePrice, singleDiscount, multiPrice, d1, d2, d3]) {
      c.dispose();
    }
    super.dispose();
  }

  void _clear() {
    setState(() {
      for (final c in [singlePrice, singleDiscount, multiPrice, d1, d2, d3]) {
        c.clear();
      }
      finalPrice = saved = null;
    });
  }

  void _calc() {
    if (mode == 0) {
      final price = double.tryParse(singlePrice.text);
      final discount = double.tryParse(singleDiscount.text);
      if (price == null || discount == null) return;
      final s = (price * discount) / 100;
      setState(() {
        saved = s.toStringAsFixed(2);
        finalPrice = (price - s).toStringAsFixed(2);
      });
    } else {
      final price = double.tryParse(multiPrice.text);
      if (price == null) return;
      var current = price;
      var totalSaved = 0.0;
      for (final c in [d1, d2, d3]) {
        if (c.text.isEmpty) continue;
        final discount = double.tryParse(c.text);
        if (discount == null) continue;
        final amount = (current * discount) / 100;
        totalSaved += amount;
        current -= amount;
      }
      setState(() {
        saved = totalSaved.toStringAsFixed(2);
        finalPrice = current.toStringAsFixed(2);
      });
    }
    AppState.instance.addHistory(
      route: '/discount',
      title: 'Discount',
      result: '\$$finalPrice',
    );
    WidgetSync.publish();
  }

  @override
  Widget build(BuildContext context) {
    final ready = mode == 0
        ? singlePrice.text.isNotEmpty && singleDiscount.text.isNotEmpty
        : multiPrice.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Discount'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/discount');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/discount'),
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
          SegmentControl(
            labels: const ['Single', 'Stacked'],
            index: mode,
            onChanged: (i) => setState(() => mode = i),
          ),
          const SizedBox(height: 16),
          if (finalPrice != null)
            PremiumResultCard(
              eyebrow: 'Sale price',
              value: '\$$finalPrice',
              detail: 'You save \$$saved',
              colors: const [
                Color(0xFFFFF0F3),
                Color(0xFFFFF1E6),
                Color(0xFFEDE8FF),
              ],
            ),
          const SizedBox(height: 16),
          AppCard(
            child: mode == 0
                ? Column(
                    children: [
                      LabeledField(label: 'Price', controller: singlePrice, compact: true),
                      const Divider(height: 24),
                      LabeledField(label: 'Discount %', controller: singleDiscount, compact: true),
                    ],
                  )
                : Column(
                    children: [
                      LabeledField(label: 'Price', controller: multiPrice, compact: true),
                      const Divider(height: 24),
                      LabeledField(label: 'Discount 1 %', controller: d1, compact: true),
                      const Divider(height: 24),
                      LabeledField(label: 'Discount 2 %', controller: d2, compact: true),
                      const Divider(height: 24),
                      LabeledField(label: 'Discount 3 %', controller: d3, compact: true),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Calculate', onPressed: ready ? _calc : null),
        ],
      ),
    );
  }
}
