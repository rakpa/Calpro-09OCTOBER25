import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  final principal = TextEditingController();
  final rate = TextEditingController();
  final time = TextEditingController();
  double? futureValue;
  double? interestEarned;
  final currency = NumberFormat.currency(symbol: '\$');

  @override
  void dispose() {
    principal.dispose();
    rate.dispose();
    time.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      principal.clear();
      rate.clear();
      time.clear();
      futureValue = null;
      interestEarned = null;
    });
  }

  void _calculate() {
    final p = double.tryParse(principal.text);
    final r = double.tryParse(rate.text);
    final t = double.tryParse(time.text);
    if (p == null || r == null || t == null) return;
    final amount = p * math.pow(1 + r / 100, t);
    setState(() {
      futureValue = double.parse(amount.toStringAsFixed(2));
      interestEarned = futureValue! - p;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = principal.text.isNotEmpty &&
        rate.text.isNotEmpty &&
        time.text.isNotEmpty;

    return CalcScaffold(
      title: 'Financial',
      route: '/financial',
      icon: Icons.attach_money,
      description: 'Annual compound interest future value: A = P(1+r)^t',
      onClear: _clear,
      body: Column(
        children: [
          LabeledField(
            label: 'Principal Amount',
            controller: principal,
            hint: '\$',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Annual Interest Rate (%)',
            controller: rate,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Time (Years)',
            controller: time,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: ready ? _calculate : null,
            child: const Text('Calculate'),
          ),
          if (futureValue != null)
            ResultPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Future Value: ${currency.format(futureValue)}'),
                  const SizedBox(height: 6),
                  Text('Interest Earned: ${currency.format(interestEarned)}'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
