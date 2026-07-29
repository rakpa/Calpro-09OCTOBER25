import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class ScientificScreen extends StatefulWidget {
  const ScientificScreen({super.key});

  @override
  State<ScientificScreen> createState() => _ScientificScreenState();
}

class _ScientificScreenState extends State<ScientificScreen> {
  String display = '0';
  bool justEvaluated = false;

  void _clear() {
    setState(() {
      display = '0';
      justEvaluated = false;
    });
  }

  void _append(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
        return;
      }
      if (value == '=') {
        _evaluate();
        return;
      }
      if (display == '0' || display == 'Error' || justEvaluated) {
        display = value;
        justEvaluated = false;
      } else {
        display += value;
      }
    });
  }

  void _evaluate() {
    try {
      final expr = display.replaceAll('π', '(${math.pi})');
      // math_expressions uses sin/cos/tan in radians; ^ is power
      final parser = GrammarParser();
      final parsed = parser.parse(expr);
      final evaluator = RealEvaluator(ContextModel());
      final result = evaluator.evaluate(parsed);
      display = _format(result);
      justEvaluated = true;
    } catch (_) {
      display = 'Error';
      justEvaluated = true;
    }
  }

  String _format(num value) {
    if (value is double) {
      if (value.isNaN || value.isInfinite) return 'Error';
      if (value == value.roundToDouble()) return value.toInt().toString();
      return value.toStringAsFixed(10).replaceFirst(RegExp(r'\.?0+$'), '');
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['sin(', 'cos(', 'tan(', '^'],
      ['7', '8', '9', '/'],
      ['4', '5', '6', '*'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
      ['(', ')', 'π', 'C'],
    ];

    return CalcScaffold(
      title: 'Scientific Calculator',
      icon: Icons.science,
      description: 'Trigonometry, exponents, parentheses, and constants (radians).',
      onClear: _clear,
      body: Column(
        children: [
          CalcDisplay(value: display),
          const SizedBox(height: 16),
          for (final row in rows) ...[
            Row(
              children: [
                for (var i = 0; i < row.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  KeypadButton(
                    label: row[i].replaceAll('(', ''),
                    isOperator: !_isDigit(row[i]),
                    onTap: () => _append(row[i]),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  bool _isDigit(String v) => RegExp(r'^[0-9.]$').hasMatch(v);
}
