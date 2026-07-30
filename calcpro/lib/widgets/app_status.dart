import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

enum AppStateKind { empty, loading, error }

class AppStatusView extends StatelessWidget {
  final AppStateKind kind;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppStatusView({
    super.key,
    required this.kind,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  factory AppStatusView.empty({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      AppStatusView(
        kind: AppStateKind.empty,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  factory AppStatusView.loading({
    String title = 'Calculating...',
    String message = 'Crunching the numbers for you.',
  }) =>
      AppStatusView(
        kind: AppStateKind.loading,
        title: title,
        message: message,
      );

  factory AppStatusView.error({
    String title = 'Oops! Something went wrong',
    String message = 'Please try again in a moment.',
    String actionLabel = 'Try Again',
    VoidCallback? onAction,
  }) =>
      AppStatusView(
        kind: AppStateKind.error,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = switch (kind) {
      AppStateKind.empty => AppColors.primary,
      AppStateKind.loading => AppColors.primary,
      AppStateKind.error => AppColors.accentPink,
    };
    final icon = switch (kind) {
      AppStateKind.empty => Icons.search_off_rounded,
      AppStateKind.loading => Icons.hourglass_top_rounded,
      AppStateKind.error => Icons.error_outline_rounded,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(28),
              ),
              child: kind == AppStateKind.loading
                  ? Padding(
                      padding: const EdgeInsets.all(28),
                      child: CircularProgressIndicator(
                        color: accent,
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(icon, size: 44, color: accent),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: dark ? AppColors.inkDark : AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 1.4,
                color: dark ? AppColors.mutedDark : AppColors.muted,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 22),
              PrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
