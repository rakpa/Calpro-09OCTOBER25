import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

/// Full-bleed page chrome. Each route paints its own atmosphere so the
/// previous screen never bleeds through during section switches.
class SoftPage extends StatelessWidget {
  final Widget child;
  final Color? accent;

  const SoftPage({super.key, required this.child, this.accent});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ColoredBox(
      // Opaque base — critical so prior routes cannot show through.
      color: dark ? AppColors.bgDark : AppColors.bg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AtmosphereBackground(accent: accent),
          child,
        ],
      ),
    );
  }
}

/// Fade + tiny lift — cleaner than the default slide that flashes old UI.
class SoftPageRoute<T> extends PageRouteBuilder<T> {
  SoftPageRoute({
    required WidgetBuilder builder,
    super.settings,
    Color? accent,
  }) : super(
          opaque: true,
          barrierDismissible: false,
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (context, animation, secondaryAnimation) {
            return SoftPage(accent: accent, child: builder(context));
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            final out = CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeIn,
            );
            return FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(out),
              child: FadeTransition(
                opacity: curved,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.018),
                    end: Offset.zero,
                  ).animate(curved),
                  child: child,
                ),
              ),
            );
          },
        );
}
