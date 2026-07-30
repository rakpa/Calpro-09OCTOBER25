import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
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
              tooltip: 'Clear',
              onPressed: () {
                HapticFeedback.selectionClick();
                onClear!();
              },
              icon: const Icon(Icons.refresh_rounded),
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
                    style: TextStyle(
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                      height: 1.45,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                    ? AppColors.primary.withValues(alpha: 0.35)
                    : AppColors.resultBorder),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: foreground ??
                (dark ? AppColors.inkDark : AppColors.resultText),
            fontSize: 16,
            fontWeight: FontWeight.w700,
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
              style: TextStyle(
                fontWeight: FontWeight.w600,
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
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: dark ? AppColors.inkDark : AppColors.ink,
              ),
              decoration: InputDecoration(
                hintText: hint ?? '0',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: dark ? AppColors.mutedDark : AppColors.muted,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: dark ? AppColors.inkDark : AppColors.ink,
          ),
          decoration: InputDecoration(hintText: hint),
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
        bg = dark ? AppColors.keyFnDark : AppColors.keyFn;
        fg = dark ? AppColors.inkDark : AppColors.primaryDeep;
      case KeyStyle.danger:
        bg = AppColors.accentPink.withValues(alpha: 0.14);
        fg = AppColors.accentPink;
      case KeyStyle.number:
        bg = dark ? AppColors.keyBgDark : AppColors.keyBg;
        fg = dark ? AppColors.inkDark : AppColors.keyText;
    }

    final child = Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      elevation: resolved == KeyStyle.number && !dark ? 0.5 : 0,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: SizedBox(
          height: 58,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: label.length > 2 ? 15 : 22,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: label.length > 2 ? 0 : -0.3,
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
    final useLight = light && !dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            Text(
              subtitle!,
              style: TextStyle(
                color: useLight
                    ? AppColors.muted
                    : Colors.white.withValues(alpha: 0.55),
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
              style: TextStyle(
                color: useLight
                    ? (dark ? AppColors.inkDark : AppColors.ink)
                    : Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                height: 1.1,
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
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
