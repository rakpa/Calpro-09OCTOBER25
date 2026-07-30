import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;

  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              const Spacer(flex: 1),
              FadeTransition(
                opacity: _intro,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _intro,
                    curve: Curves.easeOutCubic,
                  )),
                  child: Column(
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(48),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 40,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.calculate_rounded,
                          size: 88,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Calculate Anything,\nBeautifully.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                              height: 1.15,
                            ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'A suite of smart calculators for everyday math, '
                        'finance, health, and more — designed to feel native.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: dark ? AppColors.mutedDark : AppColors.muted,
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                label: 'Get Started',
                onPressed: widget.onDone,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
