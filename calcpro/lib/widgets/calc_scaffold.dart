import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/theme/app_theme.dart';

class CalcScaffold extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget body;
  final VoidCallback? onClear;
  final String? description;
  final bool purpleHeader;

  const CalcScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.body,
    this.onClear,
    this.description,
    this.purpleHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDeep],
              ),
            ),
          ),
          title: Text(title),
          actions: [
            if (onClear != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    onClear!();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Clear'),
                ),
              ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            if (description != null) ...[
              Text(
                description!,
                style: TextStyle(
                  color: AppColors.muted,
                  height: 1.45,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 14),
            ],
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.line),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: body,
            ),
          ],
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
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: background ?? AppColors.resultBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border ?? AppColors.resultBorder),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: foreground ?? AppColors.resultText,
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

  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColors.muted,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: AppColors.ink,
          ),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;
  final bool expand;

  const KeypadButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isOperator = false,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: isOperator ? AppColors.primary : AppColors.keyBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 58,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: label.length > 2 ? 15 : 22,
                fontWeight: FontWeight.w700,
                color: isOperator ? Colors.white : AppColors.keyText,
                letterSpacing: label.length > 2 ? 0 : -0.3,
              ),
            ),
          ),
        ),
      ),
    );

    if (expand) return child;
    return Expanded(child: child);
  }
}

class CalcDisplay extends StatelessWidget {
  final String value;
  final String? subtitle;

  const CalcDisplay({super.key, required this.value, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.displayBg, AppColors.primaryDeep],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            Text(
              subtitle!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 14,
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
