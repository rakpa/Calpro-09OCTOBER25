import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  /// 0 = X% of Y, 1 = what %, 2 = percent change
  int mode = 0;
  int activeField = 0; // which input receives keypad digits
  final fields = ['25', '200'];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final result = _result;

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
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Column(
            children: [
              _ModeTabs(
                index: mode,
                onChanged: (i) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    mode = i;
                    activeField = 0;
                    fields[0] = i == 0 ? '25' : (i == 1 ? '50' : '100');
                    fields[1] = i == 0 ? '200' : (i == 1 ? '200' : '150');
                  });
                },
              ),
              const SizedBox(height: 14),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.03),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(mode),
                    child: Column(
                      children: [
                        _ResultHero(
                          dark: dark,
                          eyebrow: _eyebrow,
                          formula: _formulaLine,
                          answer: result?.display ?? '—',
                          accent: result?.positive,
                          onCopy: result == null
                              ? null
                              : () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: '$_formulaLine = ${result.display}',
                                    ),
                                  );
                                  _saveHistoryIfReady();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Copied')),
                                  );
                                },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _InputTile(
                                label: _labelA,
                                value: fields[0],
                                selected: activeField == 0,
                                accent: AppColors.accentPink,
                                onTap: () => setState(() => activeField = 0),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _InputTile(
                                label: _labelB,
                                value: fields[1],
                                selected: activeField == 1,
                                accent: AppColors.primary,
                                onTap: () => setState(() => activeField = 1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Expanded(child: _Keypad(onKey: _onKey)),
                      ],
                    ),
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

  _PctResult? get _result {
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

  void _clear() {
    HapticFeedback.mediumImpact();
    setState(() {
      fields[0] = '';
      fields[1] = '';
      activeField = 0;
    });
  }

  void _onKey(String key) {
    if (key == 'AC') {
      _clear();
      return;
    }
    if (key == '⌫') {
      setState(() {
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
      _saveHistoryIfReady();
      return;
    }

    setState(() {
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

  void _saveHistoryIfReady() {
    final r = _result;
    if (r == null || r.display == 'Error') return;
    if (fields[0].isEmpty || fields[1].isEmpty) return;
    AppState.instance.addHistory(
      route: '/percentage',
      title: 'Percentage',
      result: '$_formulaLine = ${r.display}',
    );
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
        color: dark ? AppColors.keyBgDark : AppColors.pastelLavender,
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
                              color: AppColors.primary.withValues(alpha: 0.14),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
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
                          ? AppColors.primary
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

class _ResultHero extends StatelessWidget {
  final bool dark;
  final String eyebrow;
  final String formula;
  final String answer;
  final bool? accent;
  final VoidCallback? onCopy;

  const _ResultHero({
    required this.dark,
    required this.eyebrow,
    required this.formula,
    required this.answer,
    required this.accent,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final answerColor = accent == null
        ? (dark ? AppColors.inkDark : AppColors.ink)
        : (accent! ? AppColors.resultText : const Color(0xFFB91C1C));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [
                  const Color(0xFF2A2438),
                  const Color(0xFF1E2430),
                ]
              : const [
                  Color(0xFFFFF0F5),
                  Color(0xFFEDE8FF),
                  Color(0xFFE8F4FF),
                ],
        ),
        border: Border.all(
          color: dark
              ? AppColors.lineDark
              : Colors.white.withValues(alpha: 0.8),
        ),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: AppColors.accentPink.withValues(alpha: 0.12),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
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
              if (onCopy != null)
                IconButton(
                  tooltip: 'Copy',
                  onPressed: onCopy,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: dark ? AppColors.mutedDark : AppColors.muted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: dark ? AppColors.inkDark : AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                height: 1.05,
                color: answerColor,
                letterSpacing: -0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputTile extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _InputTile({
    required this.label,
    required this.value,
    required this.selected,
    required this.accent,
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
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: dark
              ? AppColors.surfaceDark
              : (selected
                  ? accent.withValues(alpha: 0.10)
                  : AppColors.surfaceRaised),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? accent
                : (dark ? AppColors.lineDark : AppColors.line),
            width: selected ? 1.8 : 1,
          ),
          boxShadow: selected && !dark
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: selected
                    ? accent
                    : (dark ? AppColors.mutedDark : AppColors.muted),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value.isEmpty ? '0' : value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: dark ? AppColors.inkDark : AppColors.ink,
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
        final gap = 10.0;
        final rowCount = rows.length;
        final available = constraints.maxHeight - gap * (rowCount - 1);
        final keyH = (available / rowCount).clamp(48.0, 68.0);

        return Column(
          children: [
            for (var r = 0; r < rows.length; r++) ...[
              if (r > 0) SizedBox(height: gap),
              Expanded(
                child: Row(
                  children: [
                    for (var i = 0; i < rows[r].length; i++) ...[
                      if (i > 0) SizedBox(width: gap),
                      Expanded(
                        flex: rows[r][i].$1 == '0' ? 2 : 1,
                        child: _PadKey(
                          label: rows[r][i].$1 == 'next' ? 'Next' : rows[r][i].$1,
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
        bg = AppColors.primary;
        fg = Colors.white;
      case KeyStyle.function:
        bg = dark ? AppColors.keyFnDark : AppColors.pastelLavender;
        fg = AppColors.primary;
      case KeyStyle.danger:
        bg = dark
            ? AppColors.accentPink.withValues(alpha: 0.22)
            : AppColors.pastelPink;
        fg = AppColors.accentPink;
      case KeyStyle.number:
        bg = dark ? AppColors.keyBgDark : const Color(0xFFF4F6FB);
        fg = dark ? AppColors.inkDark : AppColors.keyText;
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          AppState.instance.lightFeedback();
          onTap();
        },
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: label.length > 2 ? 16 : 26,
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
