import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';
import 'package:calcpro/widgets/calcara_brand.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;

  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardPage(
      title: 'Calcara',
      subtitle: 'Smart calculators for everyday life.',
      showBrand: true,
    ),
    _OnboardPage(
      title: 'Popular tools',
      subtitle: 'Percentage, Mortgage, BMI, EMI and more — ready when you are.',
      showBrand: false,
    ),
    _OnboardPage(
      title: 'Fast & accurate',
      subtitle: 'Beautiful keypad, clear results, and favorites that stick.',
      showBrand: false,
    ),
  ];

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _page,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final p = _pages[i];
                    if (p.showBrand) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(28, 36, 28, 12),
                        child: Column(
                          children: [
                            const CalcaraBrandHeader(),
                            const SizedBox(height: 28),
                            const FeaturePitchCard(),
                            const Spacer(),
                            const CalculatorMascot(width: 260),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(28, 48, 28, 12),
                      child: Column(
                        children: [
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: AppFonts.h1(color: AppColors.brandNavy),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            p.subtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.brandMuted,
                              height: 1.4,
                            ),
                          ),
                          const Spacer(),
                          if (i == 1) const _PopularPreview() else const CalculatorMascot(width: 240),
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _index == i ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _index == i
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: PrimaryButton(
                  label: _index == _pages.length - 1 ? 'Get Started' : 'Continue',
                  onPressed: () {
                    if (_index == _pages.length - 1) {
                      widget.onDone();
                    } else {
                      _page.nextPage(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage {
  final String title;
  final String subtitle;
  final bool showBrand;
  const _OnboardPage({
    required this.title,
    required this.subtitle,
    required this.showBrand,
  });
}

class _PopularPreview extends StatelessWidget {
  const _PopularPreview();

  @override
  Widget build(BuildContext context) {
    final cards = [
      (AppColors.accentPink, Icons.percent_rounded, 'Percentage'),
      (AppColors.accentBlue, Icons.home_rounded, 'Mortgage'),
      (AppColors.accentGreen, Icons.favorite_rounded, 'BMI'),
      (AppColors.accentLime, Icons.calculate_rounded, 'EMI'),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        for (final c in cards)
          Container(
            decoration: BoxDecoration(
              color: c.$1,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: c.$1.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(c.$2, color: Colors.white, size: 28),
                const Spacer(),
                Text(
                  c.$3,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
