import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class TipScreen extends StatefulWidget {
  const TipScreen({super.key});

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  final bill = TextEditingController();
  final customTip = TextEditingController(text: '15');
  final people = TextEditingController(text: '1');
  int selectedTip = 15;
  String? tipAmount;
  String? total;
  String? perPerson;
  bool calculating = false;

  final presets = const [10, 15, 20, 25];

  @override
  void initState() {
    super.initState();
    for (final c in [bill, customTip, people]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    bill.dispose();
    customTip.dispose();
    people.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      bill.clear();
      customTip.text = '15';
      people.text = '1';
      selectedTip = 15;
      tipAmount = total = perPerson = null;
    });
  }

  Future<void> _calculate() async {
    final billAmount = double.tryParse(bill.text);
    final tipPercent = double.tryParse(customTip.text) ?? selectedTip.toDouble();
    final nPeople = int.tryParse(people.text) ?? 1;
    if (billAmount == null || nPeople <= 0) return;
    setState(() => calculating = true);
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final tip = billAmount * (tipPercent / 100);
    final tot = billAmount + tip;
    setState(() {
      tipAmount = tip.toStringAsFixed(2);
      total = tot.toStringAsFixed(2);
      perPerson = (tot / nPeople).toStringAsFixed(2);
      calculating = false;
    });
    AppState.instance.addHistory(
      route: '/tip',
      title: 'Tip',
      result: '\$$total total',
    );
    WidgetSync.publish();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ready = bill.text.isNotEmpty &&
        customTip.text.isNotEmpty &&
        people.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Tip'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/tip');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/tip'),
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
          if (AppState.instance.showTips)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Split the bill and tip fairly.',
                style: AppFonts.body2(
                  color: dark ? AppColors.mutedDark : AppColors.muted,
                ),
              ),
            ),
          if (tipAmount != null)
            AppCard(
              child: Column(
                children: [
                  Text(
                    'Total',
                    style: AppFonts.body2(
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                  ),
                  Text('\$$total', style: AppFonts.result()),
                  const SizedBox(height: 8),
                  Text('Tip \$$tipAmount · Per person \$$perPerson',
                      style: AppFonts.body1()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledField(label: 'Bill Amount', controller: bill, compact: true),
                const Divider(height: 24),
                Text('Tip %', style: AppFonts.caption()),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final p in presets)
                      ChoiceChip(
                        label: Text('$p%'),
                        selected: selectedTip == p,
                        onSelected: (_) {
                          AppState.instance.selectionFeedback();
                          setState(() {
                            selectedTip = p;
                            customTip.text = '$p';
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                LabeledField(label: 'Custom Tip %', controller: customTip, compact: true),
                const Divider(height: 24),
                LabeledField(
                  label: 'People',
                  controller: people,
                  compact: true,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (calculating)
            const Center(child: CircularProgressIndicator())
          else
            PrimaryButton(
              label: 'Calculate',
              onPressed: ready ? _calculate : null,
            ),
        ],
      ),
    );
  }
}
