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
  final customTip = TextEditingController();
  final people = TextEditingController();
  int selectedTip = 15;
  String? tipAmount;
  String? total;
  String? perPerson;

  final presets = const [10, 15, 20, 25];

  @override
  void initState() {
    super.initState();
    for (final c in [bill, customTip, people]) {
      c.addListener(_recalc);
    }
  }

  @override
  void dispose() {
    for (final c in [bill, customTip, people]) {
      c.removeListener(_recalc);
      c.dispose();
    }
    super.dispose();
  }

  void _clear() {
    setState(() {
      bill.clear();
      customTip.clear();
      people.clear();
      selectedTip = 15;
      tipAmount = total = perPerson = null;
    });
  }

  void _recalc() {
    final billAmount = double.tryParse(bill.text);
    final tipPercent = double.tryParse(customTip.text) ?? selectedTip.toDouble();
    final nPeople = int.tryParse(people.text) ?? 1;
    if (billAmount == null || nPeople <= 0) {
      setState(() => tipAmount = total = perPerson = null);
      return;
    }
    final tip = billAmount * (tipPercent / 100);
    final tot = billAmount + tip;
    setState(() {
      tipAmount = tip.toStringAsFixed(2);
      total = tot.toStringAsFixed(2);
      perPerson = (tot / nPeople).toStringAsFixed(2);
    });
  }

  void _commitHistory() {
    if (total == null) return;
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
          if (tipAmount != null)
            PremiumResultCard(
              eyebrow: 'Total with tip',
              value: '\$$total',
              detail: 'Tip \$$tipAmount · Per person \$$perPerson',
              colors: dark
                  ? null
                  : const [
                      Color(0xFFEDE8FF),
                      Color(0xFFFFF0F5),
                      Color(0xFFE8F4FF),
                    ],
            )
          else
            Text(
              'Enter a bill — tip updates instantly.',
              style: AppFonts.body2(
                color: dark ? AppColors.mutedDark : AppColors.muted,
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
                          _recalc();
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
          PrimaryButton(
            label: tipAmount == null ? 'Enter bill above' : 'Save to history',
            onPressed: tipAmount == null ? null : _commitHistory,
          ),
        ],
      ),
    );
  }
}
