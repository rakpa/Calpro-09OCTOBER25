import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      duration: const Duration(milliseconds: 650),
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
              const Spacer(),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(44),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 36,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: const CalcaraMark(size: 120, light: false),
                      ),
                      const SizedBox(height: 36),
                      Text(
                        'Calcara',
                        textAlign: TextAlign.center,
                        style: AppFonts.h1(
                          color: dark ? AppColors.inkDark : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Calculate Anything,\nBeautifully.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: dark ? AppColors.inkDark : AppColors.ink,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Smart calculators for everyday life — math, '
                        'money, health, and more.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          color: dark ? AppColors.mutedDark : AppColors.muted,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(label: 'Get Started', onPressed: widget.onDone),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
