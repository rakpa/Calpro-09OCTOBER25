import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/finance_math.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final amount = TextEditingController(text: '100');
  String from = 'USD';
  String to = 'EUR';
  final fmt = NumberFormat('#,##0.####');

  @override
  void initState() {
    super.initState();
    amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  double? get result {
    final v = double.tryParse(amount.text);
    if (v == null) return null;
    return CurrencyRates.convert(amount: v, from: from, to: to);
  }

  void _swap() => setState(() {
        final t = from;
        from = to;
        to = t;
      });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final codes = CurrencyRates.perUsd.keys.toList()..sort();

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Currency'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/currency');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/currency'),
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
          if (result != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('${amount.text} $from =', style: AppFonts.body2()),
                  Text('${fmt.format(result)} $to', style: AppFonts.result()),
                  const SizedBox(height: 8),
                  Text(CurrencyRates.updatedLabel, style: AppFonts.body2()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Amount', controller: amount, compact: true),
                const Divider(height: 24),
                DropdownButtonFormField<String>(
                  value: from,
                  decoration: const InputDecoration(labelText: 'From'),
                  items: codes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => from = v);
                  },
                ),
                IconButton(
                  onPressed: _swap,
                  icon: const Icon(Icons.swap_vert_rounded,
                      color: AppColors.primary),
                ),
                DropdownButtonFormField<String>(
                  value: to,
                  decoration: const InputDecoration(labelText: 'To'),
                  items: codes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => to = v);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save conversion',
            onPressed: result == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/currency',
                      title: 'Currency',
                      result: '${fmt.format(result)} $to',
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
