import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class FractionScreen extends StatefulWidget {
  const FractionScreen({super.key});

  @override
  State<FractionScreen> createState() => _FractionScreenState();
}

class _FractionScreenState extends State<FractionScreen> {
  final aNum = TextEditingController();
  final aDen = TextEditingController();
  final bNum = TextEditingController();
  final bDen = TextEditingController();
  int op = 0; // + - × ÷
  String? result;

  @override
  void initState() {
    super.initState();
    for (final c in [aNum, aDen, bNum, bDen]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    aNum.dispose();
    aDen.dispose();
    bNum.dispose();
    bDen.dispose();
    super.dispose();
  }

  int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a == 0 ? 1 : a;
  }

  void _recalc() {
    final an = int.tryParse(aNum.text);
    final ad = int.tryParse(aDen.text);
    final bn = int.tryParse(bNum.text);
    final bd = int.tryParse(bDen.text);
    if (an == null || ad == null || bn == null || bd == null || ad == 0 || bd == 0) {
      setState(() => result = null);
      return;
    }
    int rn;
    int rd;
    switch (op) {
      case 0:
        rn = an * bd + bn * ad;
        rd = ad * bd;
        break;
      case 1:
        rn = an * bd - bn * ad;
        rd = ad * bd;
        break;
      case 2:
        rn = an * bn;
        rd = ad * bd;
        break;
      default:
        if (bn == 0) {
          setState(() => result = null);
          return;
        }
        rn = an * bd;
        rd = ad * bn;
    }
    if (rd < 0) {
      rn = -rn;
      rd = -rd;
    }
    final g = _gcd(rn, rd);
    rn ~/= g;
    rd ~/= g;
    setState(() => result = rd == 1 ? '$rn' : '$rn/$rd');
  }

  @override
  Widget build(BuildContext context) {
    const ops = ['+', '−', '×', '÷'];
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Fractions')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (result != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('Result', style: AppFonts.body2()),
                  Text(result!, style: AppFonts.result()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: LabeledField(label: 'A num', controller: aNum, compact: true)),
                    const SizedBox(width: 8),
                    Expanded(child: LabeledField(label: 'A den', controller: aDen, compact: true)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < ops.length; i++)
                      ChoiceChip(
                        label: Text(ops[i]),
                        selected: op == i,
                        onSelected: (_) {
                          setState(() => op = i);
                          _recalc();
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: LabeledField(label: 'B num', controller: bNum, compact: true)),
                    const SizedBox(width: 8),
                    Expanded(child: LabeledField(label: 'B den', controller: bDen, compact: true)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: result == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/fraction',
                      title: 'Fraction',
                      result: result!,
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
