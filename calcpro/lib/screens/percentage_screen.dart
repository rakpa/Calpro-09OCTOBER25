import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  final p1a = TextEditingController();
  final p1b = TextEditingController();
  final p2a = TextEditingController();
  final p2b = TextEditingController();
  final p3a = TextEditingController();
  final p3b = TextEditingController();

  String? result1;
  String? result2;
  String? result3;
  Color changeColor = AppColors.resultText;

  @override
  void dispose() {
    p1a.dispose();
    p1b.dispose();
    p2a.dispose();
    p2b.dispose();
    p3a.dispose();
    p3b.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      for (final c in [p1a, p1b, p2a, p2b, p3a, p3b]) {
        c.clear();
      }
      result1 = result2 = result3 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalcScaffold(
      title: 'Percentage Calculator',
      icon: Icons.percent,
      description: 'Calculate percentages, proportions, and percent change.',
      onClear: _clear,
      body: Column(
        children: [
          _section(
            title: 'What is X% of Y?',
            accent: const Color(0xFF10B981),
            child: Column(
              children: [
                LabeledField(label: 'What is', controller: p1a, hint: 'Percent'),
                const SizedBox(height: 8),
                const Text('% of'),
                const SizedBox(height: 8),
                LabeledField(label: 'Number', controller: p1b),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: p1a.text.isEmpty || p1b.text.isEmpty
                      ? null
                      : () {
                          final a = double.tryParse(p1a.text) ?? 0;
                          final b = double.tryParse(p1b.text) ?? 0;
                          setState(() => result1 = ((a * b) / 100).toStringAsFixed(2));
                        },
                  child: const Text('Calculate'),
                ),
                if (result1 != null) ResultPanel(child: Text('Result: $result1')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(
            title: 'X is what percent of Y?',
            accent: const Color(0xFF3B82F6),
            child: Column(
              children: [
                LabeledField(label: 'Number', controller: p2a),
                const SizedBox(height: 8),
                const Text('is what percent of'),
                const SizedBox(height: 8),
                LabeledField(label: 'Total', controller: p2b),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: p2a.text.isEmpty || p2b.text.isEmpty
                      ? null
                      : () {
                          final num = double.tryParse(p2a.text) ?? 0;
                          final total = double.tryParse(p2b.text) ?? 0;
                          if (total == 0) {
                            setState(() => result2 = 'Error');
                            return;
                          }
                          setState(() =>
                              result2 = '${((num / total) * 100).toStringAsFixed(2)}%');
                        },
                  child: const Text('Calculate'),
                ),
                if (result2 != null)
                  ResultPanel(
                    background: const Color(0xFFEFF6FF),
                    border: const Color(0xFFBFDBFE),
                    foreground: const Color(0xFF1E40AF),
                    child: Text('Result: $result2'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(
            title: 'Percentage Change',
            accent: const Color(0xFFF97316),
            child: Column(
              children: [
                LabeledField(label: 'From', controller: p3a),
                const SizedBox(height: 8),
                const Text('to'),
                const SizedBox(height: 8),
                LabeledField(label: 'To', controller: p3b),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: p3a.text.isEmpty || p3b.text.isEmpty
                      ? null
                      : () {
                          final from = double.tryParse(p3a.text) ?? 0;
                          final to = double.tryParse(p3b.text) ?? 0;
                          if (from == 0) {
                            setState(() {
                              result3 = 'Error';
                              changeColor = Colors.grey;
                            });
                            return;
                          }
                          final change = ((to - from) / from) * 100;
                          setState(() {
                            result3 =
                                '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%';
                            changeColor = change > 0
                                ? AppColors.resultText
                                : change < 0
                                    ? const Color(0xFFB91C1C)
                                    : Colors.grey.shade700;
                          });
                        },
                  child: const Text('Calculate'),
                ),
                if (result3 != null)
                  ResultPanel(
                    background: changeColor == AppColors.resultText
                        ? AppColors.resultBg
                        : changeColor == const Color(0xFFB91C1C)
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFF3F4F6),
                    border: changeColor == const Color(0xFFB91C1C)
                        ? const Color(0xFFFECACA)
                        : AppColors.resultBorder,
                    foreground: changeColor,
                    child: Text('Change: $result3'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required Color accent,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
