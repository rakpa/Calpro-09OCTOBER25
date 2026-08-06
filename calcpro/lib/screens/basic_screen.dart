import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class BasicScreen extends StatefulWidget {
  const BasicScreen({super.key});

  @override
  State<BasicScreen> createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  String display = '0';
  String expression = '';
  String operation = '';
  double? prevValue;
  bool newNumber = true;

  void _clear() {
    setState(() {
      display = '0';
      expression = '';
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
            case '-':
              result = prevValue! - current;
            case '*':
              result = prevValue! * current;
            case '/':
              result = current == 0 ? double.nan : prevValue! / current;
            default:
              result = current;
          }
          final formatted = _format(result);
          expression = '${_format(prevValue!)} ${_opLabel(operation)} $display';
          display = formatted;
          prevValue = null;
          operation = '';
          newNumber = true;
          if (formatted != 'Error') {
            AppState.instance.addHistory(
              route: '/basic',
              title: 'Basic',
              result: '$expression = $formatted',
            );
          }
        }
      } else if (op == 'C') {
        _clear();
      } else {
        prevValue = current;
        operation = op;
        expression = '${_format(current)} ${_opLabel(op)}';
        newNumber = true;
      }
    });
  }

  String _opLabel(String op) => switch (op) {
        '*' => '×',
        '/' => '÷',
        '-' => '−',
        _ => op,
      };

  String _format(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    const rows = [
      [
        ('AC', KeyStyle.danger),
        ('%', KeyStyle.function),
        ('÷', KeyStyle.function),
        ('×', KeyStyle.function),
      ],
      [
        ('7', KeyStyle.number),
        ('8', KeyStyle.number),
        ('9', KeyStyle.number),
        ('−', KeyStyle.function),
      ],
      [
        ('4', KeyStyle.number),
        ('5', KeyStyle.number),
        ('6', KeyStyle.number),
        ('+', KeyStyle.function),
      ],
      [
        ('1', KeyStyle.number),
        ('2', KeyStyle.number),
        ('3', KeyStyle.number),
        ('.', KeyStyle.number),
      ],
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Basic'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/basic');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/basic'),
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
              Expanded(
                child: CalcDisplay(
                  value: display,
                  subtitle: expression.isEmpty ? null : expression,
                ),
              ),
              for (final row in rows) ...[
                Row(
                  children: [
                    for (var i = 0; i < row.length; i++) ...[
                      if (i > 0) const SizedBox(width: 10),
                      KeypadButton(
                        label: row[i].$1,
                        style: row[i].$2,
                        onTap: () => _handle(row[i].$1),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
              ],
              Row(
                children: [
                  KeypadButton(
                    label: '0',
                    flex: 2,
                    onTap: () => _handle('0'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: '=',
                      onPressed: () => _handle('='),
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

  void _handle(String v) {
    switch (v) {
      case 'AC':
        _onOperator('C');
      case '.':
        _onDecimal();
      case '=':
        _onOperator('=');
      case '+':
        _onOperator('+');
      case '−':
        _onOperator('-');
      case '×':
        _onOperator('*');
      case '÷':
        _onOperator('/');
      case '%':
        final n = double.tryParse(display) ?? 0;
        setState(() {
          display = _format(n / 100);
          newNumber = true;
        });
      default:
        _onNumber(v);
    }
  }
}
