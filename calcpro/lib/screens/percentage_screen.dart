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
  /// 0 = X% of Y, 1 = what %, 2 = percent change
  int mode = 0;
  int activeField = 0;
  final fields = ['', ''];

  /// Answer is only shown after tapping Calculate (search-style flow).
  bool _showAnswer = false;
  _PctResult? _committed;

  bool get _canCalculate =>
      fields[0].isNotEmpty &&
      fields[1].isNotEmpty &&
      double.tryParse(fields[0]) != null &&
      double.tryParse(fields[1]) != null;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Percentage'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/percentage');
              return IconButton(
                tooltip: fav ? 'Unfavorite' : 'Favorite',
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
            tooltip: 'Clear',
            onPressed: _clear,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            children: [
              _ModeTabs(
                index: mode,
                onChanged: (i) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    mode = i;
                    activeField = 0;
                    _showAnswer = false;
                    _committed = null;
                    fields[0] = '';
                    fields[1] = '';
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showAnswer && _committed != null
                      ? _AnswerView(
                          key: const ValueKey('answer'),
                          dark: dark,
                          eyebrow: _eyebrow,
                          formula: _formulaLine,
                          result: _committed!,
                          onCopy: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: '$_formulaLine = ${_committed!.display}',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied')),
                            );
                          },
                          onEdit: () => setState(() {
                            _showAnswer = false;
                          }),
                          onNew: _clear,
                        )
                      : _InputView(
                          key: ValueKey('input-$mode'),
                          dark: dark,
                          labelA: _labelA,
                          labelB: _labelB,
                          valueA: fields[0],
                          valueB: fields[1],
                          activeField: activeField,
                          canCalculate: _canCalculate,
                          onSelectField: (i) => setState(() => activeField = i),
                          onKey: _onKey,
                          onCalculate: _calculate,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _labelA => switch (mode) {
        0 => 'Percent',
        1 => 'Part',
        _ => 'From',
      };

  String get _labelB => switch (mode) {
        0 => 'Of value',
        1 => 'Whole',
        _ => 'To',
      };

  String get _eyebrow => switch (mode) {
        0 => 'What is X% of Y?',
        1 => 'X is what % of Y?',
        _ => 'Percent change',
      };

  String get _formulaLine {
    final a = fields[0].isEmpty ? '0' : fields[0];
    final b = fields[1].isEmpty ? '0' : fields[1];
    return switch (mode) {
      0 => '$a% of $b',
      1 => '$a is what % of $b',
      _ => '$a → $b',
    };
  }

  _PctResult? get _liveResult {
    final a = double.tryParse(fields[0]);
    final b = double.tryParse(fields[1]);
    if (a == null || b == null) return null;

    if (mode == 0) {
      return _PctResult(_fmt((a * b) / 100));
    }
    if (mode == 1) {
      if (b == 0) return const _PctResult('Error', positive: null);
      return _PctResult('${_fmt((a / b) * 100)}%');
    }
    if (a == 0) return const _PctResult('Error', positive: null);
    final change = ((b - a) / a) * 100;
    final sign = change > 0 ? '+' : '';
    return _PctResult(
      '$sign${_fmt(change)}%',
      positive: change == 0 ? null : change > 0,
    );
  }

  String _fmt(double v) {
    if (v.isNaN || v.isInfinite) return 'Error';
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  void _calculate() {
    final r = _liveResult;
    if (r == null) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _committed = r;
      _showAnswer = true;
    });
    if (r.display != 'Error') {
      AppState.instance.addHistory(
        route: '/percentage',
        title: 'Percentage',
        result: '$_formulaLine = ${r.display}',
      );
    }
  }

  void _clear() {
    HapticFeedback.mediumImpact();
    setState(() {
      fields[0] = '';
      fields[1] = '';
      activeField = 0;
      _showAnswer = false;
      _committed = null;
    });
  }

  void _onKey(String key) {
    if (key == 'AC') {
      _clear();
      return;
    }
    if (key == '⌫') {
      setState(() {
        _showAnswer = false;
        _committed = null;
        final cur = fields[activeField];
        if (cur.isNotEmpty) {
          fields[activeField] = cur.substring(0, cur.length - 1);
        } else if (activeField == 1) {
          activeField = 0;
        }
      });
      return;
    }
    if (key == 'next') {
      setState(() => activeField = activeField == 0 ? 1 : 0);
      return;
    }

    setState(() {
      _showAnswer = false;
      _committed = null;
      var cur = fields[activeField];
      if (key == '.') {
        if (cur.contains('.')) return;
        if (cur.isEmpty) cur = '0';
        fields[activeField] = '$cur.';
        return;
      }
      if (cur == '0' && key != '.') {
        fields[activeField] = key;
      } else {
        if (cur.length >= 12) return;
        fields[activeField] = '$cur$key';
      }
    });
  }
}

class _PctResult {
  final String display;
  final bool? positive;
  const _PctResult(this.display, {this.positive});
}

class _ModeTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _ModeTabs({required this.index, required this.onChanged});

  static const _labels = ['X% of Y', 'What %', 'Change'];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: dark ? AppColors.keyBgDark : const Color(0xFFE8E6F0),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: index == i
                        ? (dark ? AppColors.surfaceDark : Colors.white)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    boxShadow: index == i && !dark
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    _labels[i],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: index == i
                          ? AppColors.ink
                          : (dark ? AppColors.mutedDark : AppColors.muted),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InputView extends StatelessWidget {
  final bool dark;
  final String labelA;
  final String labelB;
  final String valueA;
  final String valueB;
  final int activeField;
  final bool canCalculate;
  final ValueChanged<int> onSelectField;
  final ValueChanged<String> onKey;
  final VoidCallback onCalculate;

  const _InputView({
    super.key,
    required this.dark,
    required this.labelA,
    required this.labelB,
    required this.valueA,
    required this.valueB,
    required this.activeField,
    required this.canCalculate,
    required this.onSelectField,
    required this.onKey,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FieldCard(
          label: labelA,
          value: valueA,
          selected: activeField == 0,
          onTap: () => onSelectField(0),
        ),
        const SizedBox(height: 10),
        _FieldCard(
          label: labelB,
          value: valueB,
          selected: activeField == 1,
          onTap: () => onSelectField(1),
        ),
        const SizedBox(height: 14),
        Expanded(child: _Keypad(onKey: onKey)),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Calculate',
          icon: Icons.calculate_rounded,
          color: AppColors.ctaMagenta,
          onPressed: canCalculate ? onCalculate : null,
        ),
      ],
    );
  }
}

class _AnswerView extends StatelessWidget {
  final bool dark;
  final String eyebrow;
  final String formula;
  final _PctResult result;
  final VoidCallback onCopy;
  final VoidCallback onEdit;
  final VoidCallback onNew;

  const _AnswerView({
    super.key,
    required this.dark,
    required this.eyebrow,
    required this.formula,
    required this.result,
    required this.onCopy,
    required this.onEdit,
    required this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    final answerColor = result.positive == null
        ? (dark ? AppColors.inkDark : AppColors.ink)
        : (result.positive! ? AppColors.resultText : const Color(0xFFB91C1C));

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: dark ? AppColors.surfaceDark : Colors.white,
                boxShadow: dark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          eyebrow,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: dark ? AppColors.mutedDark : AppColors.muted,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onCopy,
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 20,
                          color: dark ? AppColors.mutedDark : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formula,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: dark ? AppColors.inkDark : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Answer',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.ctaMagenta,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      result.display,
                      style: GoogleFonts.inter(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                        letterSpacing: -1,
                        color: answerColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Edit numbers',
          color: AppColors.ctaMagenta,
          icon: Icons.edit_rounded,
          onPressed: onEdit,
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onNew,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.ctaMagenta,
            side: const BorderSide(color: AppColors.ctaMagenta, width: 1.4),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            'New calculation',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class _FieldCard extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _FieldCard({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        decoration: BoxDecoration(
          color: dark ? AppColors.surfaceDark : const Color(0xFFECEAF3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.ctaMagenta
                : Colors.transparent,
            width: 1.6,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: selected
                    ? AppColors.ctaMagenta
                    : (dark ? AppColors.mutedDark : AppColors.muted),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value.isEmpty ? '0' : value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: dark ? AppColors.inkDark : const Color(0xFF2B1B4E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const _Keypad({required this.onKey});

  @override
  Widget build(BuildContext context) {
    final rows = [
      [('AC', KeyStyle.danger), ('⌫', KeyStyle.function), ('next', KeyStyle.function)],
      [('7', KeyStyle.number), ('8', KeyStyle.number), ('9', KeyStyle.number)],
      [('4', KeyStyle.number), ('5', KeyStyle.number), ('6', KeyStyle.number)],
      [('1', KeyStyle.number), ('2', KeyStyle.number), ('3', KeyStyle.number)],
      [('0', KeyStyle.number), ('.', KeyStyle.number)],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final rowCount = rows.length;
        final available = constraints.maxHeight - gap * (rowCount - 1);
        final keyH = (available / rowCount).clamp(44.0, 64.0);

        return Column(
          children: [
            for (var r = 0; r < rows.length; r++) ...[
              if (r > 0) const SizedBox(height: gap),
              Expanded(
                child: Row(
                  children: [
                    for (var i = 0; i < rows[r].length; i++) ...[
                      if (i > 0) const SizedBox(width: gap),
                      Expanded(
                        flex: rows[r][i].$1 == '0' ? 2 : 1,
                        child: _PadKey(
                          label:
                              rows[r][i].$1 == 'next' ? 'Next' : rows[r][i].$1,
                          style: rows[r][i].$2,
                          height: keyH,
                          onTap: () => onKey(rows[r][i].$1),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _PadKey extends StatelessWidget {
  final String label;
  final KeyStyle style;
  final double height;
  final VoidCallback onTap;

  const _PadKey({
    required this.label,
    required this.style,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    late Color bg;
    late Color fg;
    switch (style) {
      case KeyStyle.equals:
        bg = AppColors.ctaMagenta;
        fg = Colors.white;
      case KeyStyle.function:
        bg = dark ? AppColors.keyFnDark : const Color(0xFFECEAF3);
        fg = dark ? AppColors.inkDark : const Color(0xFF2B1B4E);
      case KeyStyle.danger:
        bg = dark
            ? AppColors.ctaMagenta.withValues(alpha: 0.22)
            : const Color(0xFFFCE4F1);
        fg = AppColors.ctaMagenta;
      case KeyStyle.number:
        bg = dark ? AppColors.keyBgDark : const Color(0xFFF7F6FA);
        fg = dark ? AppColors.inkDark : AppColors.keyText;
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          AppState.instance.lightFeedback();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: label.length > 2 ? 15 : 24,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
