import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/theme/app_theme.dart';

/// Soft multi-wash backdrop so pages never read as flat white.
class AtmosphereBackground extends StatelessWidget {
  final Color? accent;

  const AtmosphereBackground({super.key, this.accent});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tint = accent ?? AppColors.primarySoft;

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: dark ? AppColors.pageGradientDark : AppColors.pageGradient,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Blob(
              alignment: const Alignment(-1.05, -0.95),
              size: 280,
              color: dark
                  ? tint.withValues(alpha: 0.18)
                  : AppColors.pastelLavender.withValues(alpha: 0.95),
            ),
            _Blob(
              alignment: const Alignment(1.1, -0.55),
              size: 240,
              color: dark
                  ? AppColors.accentTeal.withValues(alpha: 0.12)
                  : AppColors.pastelBlue.withValues(alpha: 0.9),
            ),
            _Blob(
              alignment: const Alignment(-0.85, 0.55),
              size: 260,
              color: dark
                  ? AppColors.accentGreen.withValues(alpha: 0.10)
                  : AppColors.pastelGreen.withValues(alpha: 0.85),
            ),
            _Blob(
              alignment: const Alignment(0.95, 0.95),
              size: 300,
              color: dark
                  ? AppColors.accentOrange.withValues(alpha: 0.10)
                  : AppColors.pastelOrange.withValues(alpha: 0.8),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: dark
                      ? [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.18),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.18),
                          Colors.transparent,
                          const Color(0xFF1A1A40).withValues(alpha: 0.04),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Alignment alignment;
  final double size;
  final Color color;

  const _Blob({
    required this.alignment,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bold answer panel used across calculator tools.
class PremiumResultCard extends StatelessWidget {
  final String eyebrow;
  final String value;
  final String? detail;
  final List<Color>? colors;

  const PremiumResultCard({
    super.key,
    required this.eyebrow,
    required this.value,
    this.detail,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final washes = colors ??
        (dark
            ? const [Color(0xFF243028), Color(0xFF1E2430)]
            : const [Color(0xFFE8FFF3), Color(0xFFE8F4FF), Color(0xFFEDE8FF)]);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: washes,
        ),
        border: Border.all(
          color: dark
              ? AppColors.lineDark
              : Colors.white.withValues(alpha: 0.75),
        ),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: AppColors.accentGreen.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: -0.6,
                color: dark ? AppColors.inkDark : AppColors.ink,
              ),
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: 8),
            Text(
              detail!,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: dark ? AppColors.mutedDark : AppColors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: onPressed == null
          ? AppColors.primary.withValues(alpha: 0.35)
          : AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: InkWell(
        onTap: onPressed == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: SizedBox(
          height: 58,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = color ??
        (dark ? AppColors.surfaceDark : AppColors.surfaceRaised);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: dark
              ? AppColors.lineDark.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.72),
          width: 1,
        ),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF1C1C28).withValues(alpha: 0.07),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
        gradient: color == null && !dark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFDFB),
                  Color(0xFFF5F7FC),
                  Color(0xFFF2F8F5),
                ],
              )
            : null,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class SegmentControl extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  const SegmentControl({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

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
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (i == index) return;
                  HapticFeedback.selectionClick();
                  onChanged(i);
                },
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
                    labels[i],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
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

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool showMic;
  final VoidCallback? onMicTap;

  const SearchField({
    super.key,
    this.controller,
    this.hint = 'Search calculators...',
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onClear,
    this.focusNode,
    this.autofocus = false,
    this.showMic = false,
    this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      autofocus: autofocus,
      onTap: onTap,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: dark ? AppColors.inkDark : AppColors.ink,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: dark ? AppColors.mutedDark : AppColors.muted,
        ),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, size: 20),
              )
            : (showMic
                ? IconButton(
                    onPressed: onMicTap,
                    icon: Icon(
                      Icons.mic_none_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                  )
                : null),
        filled: true,
        fillColor: dark ? AppColors.surfaceDark : AppColors.surfaceRaised,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide(
            color: dark ? AppColors.lineDark : AppColors.line,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide(
            color: dark ? AppColors.lineDark : AppColors.line,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class AccentIconTile extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final double size;

  const AccentIconTile({
    super.key,
    required this.icon,
    required this.accent,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: Icon(icon, color: accent, size: size * 0.46),
    );
  }
}

class BrandMark extends StatelessWidget {
  final double size;
  final bool light;

  const BrandMark({super.key, this.size = 72, this.light = true});

  @override
  Widget build(BuildContext context) {
    return CalcaraMark(size: size, light: light);
  }
}

/// Calcara app mark: rounded purple tile with 4 dots + equals bar.
class CalcaraMark extends StatelessWidget {
  final double size;
  final bool light;

  const CalcaraMark({super.key, this.size = 72, this.light = true});

  @override
  Widget build(BuildContext context) {
    final pad = size * 0.22;
    final dot = size * 0.12;
    final gap = size * 0.08;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: light ? Colors.white.withValues(alpha: 0.2) : AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(dot),
                SizedBox(width: gap),
                _dot(dot),
              ],
            ),
            SizedBox(height: gap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(dot),
                SizedBox(width: gap),
                _dot(dot),
              ],
            ),
            SizedBox(height: gap * 1.2),
            Container(
              width: size * 0.42,
              height: size * 0.07,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool selected;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: selected ? color : color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: selected ? Colors.white : color,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: selected ? color : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
