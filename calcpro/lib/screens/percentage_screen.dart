import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  int mode = 0;
  int advancedTab = 0;

  String percent = '25';
  String ofValue = '200';
  bool editingPercent = true;
  String? basicResult = '50';

  final p2a = TextEditingController();
  final p2b = TextEditingController();
  final p3a = TextEditingController();
  final p3b = TextEditingController();
  String? result2;
  String? result3;
  Color changeColor = AppColors.resultText;

  @override
  void initState() {
    super.initState();
    for (final c in [p2a, p2b, p3a, p3b]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [p2a, p2b, p3a, p3b]) {
      c.dispose();
    }
    super.dispose();
  }

  void _clear() {
    setState(() {
      percent = '';
      ofValue = '';
      editingPercent = true;
      basicResult = null;
      p2a.clear();
      p2b.clear();
      p3a.clear();
      p3b.clear();
      result2 = result3 = null;
    });
  }

  void _append(String digit) {
    setState(() {
      basicResult = null;
      if (editingPercent) {
        if (digit == '.' && percent.contains('.')) return;
        if (percent == '0' && digit != '.') {
          percent = digit;
        } else {
          percent += digit;
        }
      } else {
        if (digit == '.' && ofValue.contains('.')) return;
        if (ofValue == '0' && digit != '.') {
          ofValue = digit;
        } else {
          ofValue += digit;
        }
      }
    });
  }

  void _backspace() {
    setState(() {
      basicResult = null;
      if (editingPercent) {
        if (percent.isNotEmpty) {
          percent = percent.substring(0, percent.length - 1);
        }
      } else if (ofValue.isNotEmpty) {
        ofValue = ofValue.substring(0, ofValue.length - 1);
      } else {
        editingPercent = true;
      }
    });
  }

  void _calculateBasic() {
    final a = double.tryParse(percent);
    final b = double.tryParse(ofValue);
    if (a == null || b == null) return;
    final result = (a * b) / 100;
    final formatted = result == result.roundToDouble()
        ? result.toInt().toString()
        : result.toStringAsFixed(2);
    setState(() => basicResult = formatted);
    AppState.instance.addHistory(
      route: '/percentage',
      title: 'Percentage',
      result: '$percent% of $ofValue = $formatted',
    );
  }

  String get _displayLine {
    final p = percent.isEmpty ? '0' : percent;
    final o = ofValue.isEmpty ? '0' : ofValue;
    if (basicResult != null) return '$p% of $o = $basicResult';
    return '$p% of $o';
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Percentage Calculator'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/percentage');
              return IconButton(
                onPressed: () =>
                    AppState.instance.toggleFavorite('/percentage'),
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? AppColors.accentPink : null,
                ),
              );
            },
          ),
          IconButton(
            onPressed: _clear,
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            children: [
              SegmentControl(
                labels: const ['Basic', 'Advanced'],
                index: mode,
                onChanged: (i) => setState(() => mode = i),
              ),
              const SizedBox(height: 16),
              if (mode == 0)
                Expanded(child: _buildBasic(dark))
              else
                Expanded(child: _buildAdvanced(dark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasic(bool dark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
              color: dark ? AppColors.surfaceDark : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadii.xl),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _fieldChip('Percent', percent, editingPercent, () {
                      setState(() => editingPercent = true);
                    }),
                    const SizedBox(width: 8),
                    _fieldChip('Of', ofValue, !editingPercent, () {
                      setState(() => editingPercent = false);
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _displayLine,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: dark ? AppColors.inkDark : AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          QuickActionRow(
            onCopy: basicResult == null
                ? null
                : () {
                    Clipboard.setData(ClipboardData(text: _displayLine));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied')),
                    );
                  },
            onShare: basicResult == null
                ? null
                : () {
                    Clipboard.setData(ClipboardData(text: _displayLine));
                  },
            onSave: () => AppState.instance.toggleFavorite('/percentage'),
          ),
          const SizedBox(height: 16),
          _keypad(),
        ],
      ),
    );
  }

  Widget _fieldChip(
    String label,
    String value,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.line,
          ),
        ),
        child: Text(
          '$label: ${value.isEmpty ? '0' : value}',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? AppColors.primary : AppColors.muted,
          ),
        ),
      ),
    );
  }

  Widget _keypad() {
    final rows = [
      ['AC', '%', '⌫', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
    ];

    return Column(
      children: [
        for (final row in rows) ...[
          Row(
            children: [
              for (var i = 0; i < row.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                KeypadButton(
                  label: row[i],
                  style: _styleFor(row[i]),
                  onTap: () => _onKey(row[i]),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            KeypadButton(label: '0', flex: 1, onTap: () => _onKey('0')),
            const SizedBox(width: 10),
            KeypadButton(label: '.', onTap: () => _onKey('.')),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Material(
                color: percent.isEmpty || ofValue.isEmpty
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                child: InkWell(
                  onTap: percent.isEmpty || ofValue.isEmpty
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          _calculateBasic();
                        },
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  child: SizedBox(
                    height: 58,
                    child: Center(
                      child: Text(
                        '=',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  KeyStyle _styleFor(String label) {
    if (label == 'AC') return KeyStyle.danger;
    if ('%⌫÷×−+'.contains(label)) return KeyStyle.function;
    return KeyStyle.number;
  }

  void _onKey(String key) {
    if (key == 'AC') {
      _clear();
      return;
    }
    if (key == '⌫') {
      _backspace();
      return;
    }
    if (key == '%') {
      setState(() => editingPercent = true);
      return;
    }
    if ('÷×−+'.contains(key)) {
      setState(() => editingPercent = false);
      return;
    }
    _append(key);
  }

  Widget _buildAdvanced(bool dark) {
    return ListView(
      children: [
        SegmentControl(
          labels: const ['X of Y', 'Change'],
          index: advancedTab,
          onChanged: (i) => setState(() => advancedTab = i),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: advancedTab == 0
              ? Column(
                  children: [
                    LabeledField(label: 'Number', controller: p2a),
                    const SizedBox(height: 8),
                    Text(
                      'is what percent of',
                      style: AppFonts.body2(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LabeledField(label: 'Total', controller: p2b),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: 'Calculate',
                      onPressed: p2a.text.isEmpty || p2b.text.isEmpty
                          ? null
                          : () {
                              final num = double.tryParse(p2a.text) ?? 0;
                              final total = double.tryParse(p2b.text) ?? 0;
                              if (total == 0) {
                                setState(() => result2 = 'Error');
                                return;
                              }
                              final r =
                                  '${((num / total) * 100).toStringAsFixed(2)}%';
                              setState(() => result2 = r);
                              AppState.instance.addHistory(
                                route: '/percentage',
                                title: 'Percentage',
                                result: r,
                              );
                            },
                    ),
                    if (result2 != null)
                      ResultPanel(child: Text('Result: $result2')),
                  ],
                )
              : Column(
                  children: [
                    LabeledField(label: 'From', controller: p3a),
                    const SizedBox(height: 8),
                    LabeledField(label: 'To', controller: p3b),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: 'Calculate',
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
                              final r =
                                  '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%';
                              setState(() {
                                result3 = r;
                                changeColor = change > 0
                                    ? AppColors.resultText
                                    : change < 0
                                        ? const Color(0xFFB91C1C)
                                        : Colors.grey.shade700;
                              });
                              AppState.instance.addHistory(
                                route: '/percentage',
                                title: 'Percent Change',
                                result: r,
                              );
                            },
                    ),
                    if (result3 != null)
                      ResultPanel(
                        foreground: changeColor,
                        child: Text('Change: $result3'),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
