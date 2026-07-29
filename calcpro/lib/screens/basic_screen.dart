import 'package:flutter/material.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class BasicScreen extends StatefulWidget {
  const BasicScreen({super.key});

  @override
  State<BasicScreen> createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  String display = '0';
  String operation = '';
  double? prevValue;
  bool newNumber = true;

  void _clear() {
    setState(() {
      display = '0';
      operation = '';
      prevValue = null;
      newNumber = true;
    });
  }

  void _onNumber(String num) {
    setState(() {
      if (newNumber || display == '0') {
        display = num;
        newNumber = false;
      } else {
        display += num;
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (!display.contains('.')) {
        display += '.';
        newNumber = false;
      }
    });
  }

  void _onOperator(String op) {
    final current = double.tryParse(display) ?? 0;
    setState(() {
      if (op == '=') {
        if (prevValue != null && operation.isNotEmpty && !newNumber) {
          double result;
          switch (operation) {
            case '+':
              result = prevValue! + current;
              break;
            case '-':
              result = prevValue! - current;
              break;
            case '*':
              result = prevValue! * current;
              break;
            case '/':
              result = current == 0 ? double.nan : prevValue! / current;
              break;
            default:
              result = current;
          }
          display = _format(result);
          prevValue = null;
          operation = '';
          newNumber = true;
        }
      } else if (op == 'C') {
        _clear();
      } else {
        prevValue = current;
        operation = op;
        newNumber = true;
      }
    });
  }

  String _format(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', '*'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
    ];

    return CalcScaffold(
      title: 'Basic Calculator',
      icon: Icons.calculate,
      description: 'Simple arithmetic calculations',
      onClear: _clear,
      body: Column(
        children: [
          CalcDisplay(
            value: display,
            subtitle: operation.isEmpty ? null : operation,
          ),
          const SizedBox(height: 16),
          for (final row in rows) ...[
            Row(
              children: [
                for (var i = 0; i < row.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  KeypadButton(
                    label: row[i],
                    isOperator: '+-*/=C'.contains(row[i]),
                    onTap: () {
                      final v = row[i];
                      if (v == '.') {
                        _onDecimal();
                      } else if ('+-*/=C'.contains(v)) {
                        _onOperator(v);
                      } else {
                        _onNumber(v);
                      }
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
          ],
          KeypadButton(
            label: 'C',
            isOperator: true,
            expand: true,
            onTap: () => _onOperator('C'),
          ),
        ],
      ),
    );
  }
}
