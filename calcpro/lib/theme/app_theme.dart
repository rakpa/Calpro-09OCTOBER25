import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Calcura-inspired design tokens for CalcPro.
class AppColors {
  static const Color primary = Color(0xFF705CF6);
  static const Color primaryDeep = Color(0xFF5B47E0);
  static const Color primarySoft = Color(0xFF8B7CFF);
  static const Color primaryMuted = Color(0xFFEDE9FE);

  // Light
  static const Color bg = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF12121A);
  static const Color muted = Color(0xFF8B8B9A);
  static const Color line = Color(0xFFEBECF2);
  static const Color keyBg = Color(0xFFFFFFFF);
  static const Color keyFn = Color(0xFFE8F0FE);
  static const Color keyText = Color(0xFF12121A);

  // Dark
  static const Color bgDark = Color(0xFF0D0D15);
  static const Color surfaceDark = Color(0xFF1A1A24);
  static const Color inkDark = Color(0xFFF5F5F7);
  static const Color mutedDark = Color(0xFF8E8E9A);
  static const Color lineDark = Color(0xFF2A2A36);
  static const Color keyBgDark = Color(0xFF242430);
  static const Color keyFnDark = Color(0xFF2C2C3A);

  // Accents by category
  static const Color accentPink = Color(0xFFFF5A7A);
  static const Color accentOrange = Color(0xFFFF8A3D);
  static const Color accentBlue = Color(0xFF4C8DFF);
  static const Color accentGreen = Color(0xFF34C759);
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentPurple = Color(0xFF705CF6);

  static const Color resultBg = Color(0xFFECFDF5);
  static const Color resultBorder = Color(0xFFA7F3D0);
  static const Color resultText = Color(0xFF065F46);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B7CFF), Color(0xFF705CF6), Color(0xFF5B47E0)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF8B7CFF), Color(0xFF705CF6), Color(0xFF4F3AD6)],
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double huge = 32;
}

class AppRadii {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double pill = 999;
}

class AppTheme {
  static TextTheme _textTheme(Color ink) {
    return GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: ink,
      displayColor: ink,
    );
  }

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
      scaffoldBackgroundColor: AppColors.bg,
    );

    return _applyCommon(base, _textTheme(AppColors.ink), dark: false);
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primarySoft,
        surface: AppColors.surfaceDark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,
    );

    return _applyCommon(base, _textTheme(AppColors.inkDark), dark: true);
  }

  static ThemeData _applyCommon(ThemeData base, TextTheme textTheme,
      {required bool dark}) {
    final muted = dark ? AppColors.mutedDark : AppColors.muted;
    final line = dark ? AppColors.lineDark : AppColors.line;
    final fill = dark ? AppColors.surfaceDark : AppColors.primaryMuted;

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: dark ? AppColors.inkDark : AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: dark ? AppColors.inkDark : AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(
          color: dark ? AppColors.inkDark : AppColors.ink,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: line, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fill.withValues(alpha: dark ? 1 : 0.55),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.plusJakartaSans(color: muted, fontSize: 15),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      dividerColor: line,
      cardTheme: CardThemeData(
        color: dark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
      ),
    );
  }
}
