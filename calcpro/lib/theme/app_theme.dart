import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand (kept from CalcPro web)
  static const Color primary = Color(0xFF4B0082);
  static const Color primaryDeep = Color(0xFF2E0057);
  static const Color primarySoft = Color(0xFF7C3AED);

  // Atmosphere
  static const Color pageTop = Color(0xFFF3EEFF);
  static const Color pageBottom = Color(0xFFF8FAFC);
  static const Color ink = Color(0xFF1E1233);
  static const Color muted = Color(0xFF6B7280);
  static const Color surface = Colors.white;
  static const Color surfaceAlt = Color(0xFFF5F3FF);
  static const Color line = Color(0xFFE8E4F0);

  // Results
  static const Color resultBg = Color(0xFFECFDF5);
  static const Color resultBorder = Color(0xFFA7F3D0);
  static const Color resultText = Color(0xFF065F46);

  // Keypad
  static const Color keyBg = Color(0xFFF3F0FA);
  static const Color keyText = Color(0xFF1E1233);
  static const Color displayBg = Color(0xFF1E1233);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primarySoft,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.pageBottom,
    );

    final textTheme = GoogleFonts.outfitTextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.35),
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.line, width: 1.5),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.outfit(color: AppColors.muted, fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primarySoft, width: 1.5),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.muted,
        indicatorColor: AppColors.primary,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14),
        unselectedLabelStyle:
            GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      dividerColor: AppColors.line,
    );
  }
}

/// Soft atmospheric background used across screens.
class AppBackdrop extends StatelessWidget {
  final Widget child;

  const AppBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.pageTop,
            Color(0xFFF7F5FF),
            AppColors.pageBottom,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primarySoft.withValues(alpha: 0.12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -70,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.07),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
