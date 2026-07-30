import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class CalcScaffold extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget body;
  final VoidCallback? onClear;
  final String? description;
  final String? route;
  final bool scrollable;
  final List<Widget>? actions;
  final Color? accent;

  const CalcScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.body,
    this.onClear,
    this.description,
    this.route,
    this.scrollable = true,
    this.actions,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final favRoute = route;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (favRoute != null)
            ListenableBuilder(
              listenable: AppState.instance,
              builder: (context, _) {
                final fav = AppState.instance.isFavorite(favRoute);
                return IconButton(
                  tooltip: fav ? 'Remove favorite' : 'Save',
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    AppState.instance.toggleFavorite(favRoute);
                  },
                  icon: Icon(
                    fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: fav ? AppColors.accentPink : null,
                  ),
                );
              },
            ),
          if (onClear != null)
            IconButton(
              tooltip: 'More',
              onPressed: () {
                HapticFeedback.selectionClick();
                onClear!();
              },
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ...?actions,
        ],
      ),
      body: scrollable
          ? ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                if (description != null) ...[
                  Text(
                    description!,
                    style: AppFonts.body2(
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                AppCard(padding: const EdgeInsets.all(20), child: body),
              ],
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: body,
              ),
            ),
    );
  }
}

class ResultPanel extends StatelessWidget {
  final Widget child;
  final Color? background;
  final Color? border;
  final Color? foreground;

  const ResultPanel({
    super.key,
    required this.child,
    this.background,
    this.border,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: background ??
              (dark
                  ? AppColors.primary.withValues(alpha: 0.16)
                  : AppColors.resultBg),
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(
            color: border ??
                (dark
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.resultBorder),
          ),
        ),
        child: DefaultTextStyle(
          style: GoogleFonts.inter(
            color: foreground ??
                (dark ? AppColors.inkDark : AppColors.resultText),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.45,
          ),
          child: child,
        ),
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool compact;

  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.hint,
    this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (compact) {
      return Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: dark ? AppColors.inkDark : AppColors.ink,
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: dark ? AppColors.inkDark : AppColors.ink,
              ),
              decoration: InputDecoration(
                hintText: hint ?? '0',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: dark ? AppColors.mutedDark : AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: dark ? AppColors.inkDark : AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

enum KeyStyle { number, function, equals, danger }

class KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;
  final bool expand;
  final KeyStyle? style;
  final int flex;

  const KeypadButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isOperator = false,
    this.expand = false,
    this.style,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final resolved = style ??
        (isOperator
            ? (label == '=' ? KeyStyle.equals : KeyStyle.function)
            : KeyStyle.number);

    late Color bg;
    late Color fg;
    switch (resolved) {
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
        bg = dark ? AppColors.keyBgDark : const Color(0xFFF3F5FA);
        fg = dark ? AppColors.inkDark : AppColors.keyText;
    }

    final child = Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: () {
          AppState.instance.lightFeedback();
          onTap();
        },
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 64,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: label.length > 2 ? 18 : 28,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );

    if (expand) return child;
    return Expanded(flex: flex, child: child);
  }
}

class CalcDisplay extends StatelessWidget {
  final String value;
  final String? subtitle;
  final bool light;

  const CalcDisplay({
    super.key,
    required this.value,
    this.subtitle,
    this.light = true,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [Color(0xFF262636), Color(0xFF1A1F2A)]
              : const [Color(0xFFEDE8FF), Color(0xFFE8F4FF), Color(0xFFF4F9E8)],
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
                  color: AppColors.primary.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                color: dark ? AppColors.mutedDark : AppColors.muted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              style: GoogleFonts.inter(
                color: dark ? AppColors.inkDark : AppColors.ink,
                fontSize: 52,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionRow extends StatelessWidget {
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const QuickActionRow({
    super.key,
    this.onCopy,
    this.onShare,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(Icons.copy_rounded, 'Copy', onCopy),
        const SizedBox(width: 8),
        _chip(Icons.ios_share_rounded, 'Share', onShare),
        const SizedBox(width: 8),
        _chip(Icons.bookmark_border_rounded, 'Save', onSave),
      ],
    );
  }

  Widget _chip(IconData icon, String label, VoidCallback? onTap) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(42),
          padding: EdgeInsets.zero,
          textStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
