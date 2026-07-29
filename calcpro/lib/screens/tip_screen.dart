import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

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

  final presets = const [10, 15, 20, 25];

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

  void _calculate() {
    final billAmount = double.tryParse(bill.text);
    final tipPercent = double.tryParse(customTip.text) ?? selectedTip.toDouble();
    final nPeople = int.tryParse(people.text) ?? 1;
    if (billAmount == null || nPeople <= 0) return;
    final tip = billAmount * (tipPercent / 100);
    final tot = billAmount + tip;
    setState(() {
      tipAmount = tip.toStringAsFixed(2);
      total = tot.toStringAsFixed(2);
      perPerson = (tot / nPeople).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = bill.text.isNotEmpty &&
        customTip.text.isNotEmpty &&
        people.text.isNotEmpty;

    return CalcScaffold(
      title: 'Tip Calculator',
      icon: Icons.restaurant,
      description: 'Calculate tip amounts and split the bill.',
      onClear: _clear,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Bill Amount (\$)',
            controller: bill,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          const Text('Tip %', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final p in presets)
                ChoiceChip(
                  label: Text('$p%'),
                  selected: selectedTip == p,
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  onSelected: (_) {
                    setState(() {
                      selectedTip = p;
                      customTip.text = '$p';
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          LabeledField(
            label: 'Custom Tip %',
            controller: customTip,
            onChanged: (v) {
              setState(() {
                selectedTip = int.tryParse(v) ?? selectedTip;
              });
            },
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Number of People',
            controller: people,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: ready ? _calculate : null,
            child: const Text('Calculate'),
          ),
          if (tipAmount != null)
            ResultPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tip Amount: \$$tipAmount'),
                  Text('Total: \$$total'),
                  Text(
                    'Per Person: \$$perPerson',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
