import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/theme/app_theme.dart';

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
    return Material(
      color: color ?? (dark ? AppColors.surfaceDark : AppColors.surface),
      borderRadius: BorderRadius.circular(AppRadii.xl),
      elevation: dark ? 0 : 2,
      shadowColor: const Color(0xFF1C1C28).withValues(alpha: 0.18),
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
        color: dark ? AppColors.keyBgDark : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () {
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
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
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
        fillColor: dark ? AppColors.surfaceDark : AppColors.surfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide.none,
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
