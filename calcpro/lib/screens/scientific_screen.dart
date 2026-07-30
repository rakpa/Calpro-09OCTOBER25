import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';
import 'package:math_expressions/math_expressions.dart';

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
      if (value == 'C' || value == 'AC') {
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
      final expr = display.replaceAll('π', '(${math.pi})').replaceAll('×', '*').replaceAll('÷', '/').replaceAll('−', '-');
      final parser = GrammarParser();
      final parsed = parser.parse(expr);
      final evaluator = RealEvaluator(ContextModel());
      final result = evaluator.evaluate(parsed);
      final formatted = _format(result);
      setState(() {
        display = formatted;
        justEvaluated = true;
      });
      if (formatted != 'Error') {
        AppState.instance.addHistory(
          route: '/scientific',
          title: 'Scientific',
          result: formatted,
        );
        WidgetSync.publish();
      }
    } catch (_) {
      setState(() {
        display = 'Error';
        justEvaluated = true;
      });
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

  bool _isDigit(String v) => RegExp(r'^[0-9.]$').hasMatch(v);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    const rows = [
      [('sin', 'sin('), ('cos', 'cos('), ('tan', 'tan('), ('^', '^')],
      [('7', '7'), ('8', '8'), ('9', '9'), ('÷', '/')],
      [('4', '4'), ('5', '5'), ('6', '6'), ('×', '*')],
      [('1', '1'), ('2', '2'), ('3', '3'), ('−', '-')],
      [('(', '('), (')', ')'), ('π', 'π'), ('+', '+')],
    ];

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Scientific'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/scientific');
              return IconButton(
                onPressed: () =>
                    AppState.instance.toggleFavorite('/scientific'),
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? AppColors.accentPink : null,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: [
              Expanded(child: CalcDisplay(value: display)),
              for (final row in rows) ...[
                Row(
                  children: [
                    for (var i = 0; i < row.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      KeypadButton(
                        label: row[i].$1,
                        style: _isDigit(row[i].$2)
                            ? KeyStyle.number
                            : KeyStyle.function,
                        onTap: () => _append(row[i].$2),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  KeypadButton(
                    label: 'AC',
                    style: KeyStyle.danger,
                    onTap: _clear,
                  ),
                  const SizedBox(width: 8),
                  KeypadButton(label: '0', onTap: () => _append('0')),
                  const SizedBox(width: 8),
                  KeypadButton(label: '.', onTap: () => _append('.')),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      label: '=',
                      onPressed: () => _append('='),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
