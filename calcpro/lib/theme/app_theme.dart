import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fade page transitions so prior sections don't flash underneath.
class SoftFadeTransitionsBuilder extends PageTransitionsBuilder {
  const SoftFadeTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == Navigator.defaultRouteName) {
      return child;
    }
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
  }
}

/// Calcara design system — Inter typography + playful accents.
class AppColors {
  static const Color primary = Color(0xFF5A31F4);
  static const Color primaryDeep = Color(0xFF4520D4);
  static const Color primarySoft = Color(0xFF7B5CFF);
  static const Color primaryMuted = Color(0xFFEDE8FF);
  static const Color lavender = Color(0xFFF3F0FF);

  /// Splash / onboarding light wash from Calcara snip.
  static const Color splashBgTop = Color(0xFFF5F7FF);
  static const Color splashBgBottom = Color(0xFFE8F3F0);
  static const Color brandNavy = Color(0xFF1A1A40);
  static const Color brandMuted = Color(0xFF6B7394);
  static const Color sparkle = Color(0xFFFFB020);

  /// Soft cool wash — never flat white page chrome.
  static const Color bg = Color(0xFFEEF2F8);
  static const Color bgWarm = Color(0xFFF7F1EB);
  static const Color bgMint = Color(0xFFE9F5F1);
  static const Color surface = Color(0xFFF8FAFD);
  static const Color surfaceRaised = Color(0xFFFFFCF9);
  static const Color surfaceAlt = Color(0xFFE6ECF5);
  static const Color ink = Color(0xFF1A1A40);
  static const Color muted = Color(0xFF6B7394);
  static const Color line = Color(0xFFD8DEEA);

  static const Color keyBg = Color(0xFFFFFFFF);
  static const Color keyFn = Color(0xFFF0ECFF);
  static const Color keyText = Color(0xFF1A1A40);

  static const Color bgDark = Color(0xFF12121A);
  static const Color surfaceDark = Color(0xFF1E1E28);
  static const Color inkDark = Color(0xFFF7F7FA);
  static const Color mutedDark = Color(0xFF9A9AA8);
  static const Color lineDark = Color(0xFF2C2C38);
  static const Color keyBgDark = Color(0xFF2A2A36);
  static const Color keyFnDark = Color(0xFF322E48);

  static const Color accentPink = Color(0xFFFF6B8A);
  static const Color accentOrange = Color(0xFFFF8F3D);
  static const Color accentBlue = Color(0xFF5BA8FF);
  static const Color accentGreen = Color(0xFF3DDC84);
  static const Color accentLime = Color(0xFFB8E63A);
  static const Color accentTeal = Color(0xFF3FD0C9);
  static const Color accentPurple = Color(0xFF5A31F4);

  /// High-energy CTA magenta (search / calculate actions).
  static const Color ctaMagenta = Color(0xFFC5007E);
  static const Color ctaMagentaDeep = Color(0xFFA10066);

  /// Soft pastel card washes from Calcara home snip.
  static const Color pastelPink = Color(0xFFFFF0F3);
  static const Color pastelBlue = Color(0xFFE8F4FF);
  static const Color pastelGreen = Color(0xFFE8F9F1);
  static const Color pastelLime = Color(0xFFF4F9E8);
  static const Color pastelLavender = Color(0xFFEDE8FF);
  static const Color pastelOrange = Color(0xFFFFF1E6);

  static const Color resultBg = Color(0xFFE8FFF3);
  static const Color resultBorder = Color(0xFFA7F3D0);
  static const Color resultText = Color(0xFF0B6B3A);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B5CFF), Color(0xFF5A31F4)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [splashBgTop, Color(0xFFEEF4F8), splashBgBottom],
  );

  /// Page atmosphere used behind transparent scaffolds.
  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF3F0FF),
      Color(0xFFEEF4FB),
      Color(0xFFE8F6F1),
      Color(0xFFF8F1E9),
    ],
    stops: [0.0, 0.35, 0.7, 1.0],
  );

  static const LinearGradient pageGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF161622),
      Color(0xFF141820),
      Color(0xFF121A18),
      Color(0xFF1A1614),
    ],
    stops: [0.0, 0.35, 0.7, 1.0],
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
  static const double sm = 14;
  static const double md = 18;
  static const double lg = 22;
  static const double xl = 24;
  static const double pill = 999;
}

class AppFonts {
  static TextStyle display({Color? color}) => GoogleFonts.inter(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.brandNavy,
        height: 1.1,
      );

  static TextStyle h1({Color? color}) => GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.ink,
        height: 1.2,
      );

  static TextStyle h2({Color? color}) => GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.ink,
        height: 1.25,
      );

  static TextStyle h3({Color? color}) => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.ink,
        height: 1.3,
      );

  static TextStyle body1({Color? color}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.ink,
        height: 1.4,
      );

  static TextStyle body2({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.muted,
        height: 1.4,
      );

  static TextStyle caption({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.muted,
        height: 1.3,
      );

  static TextStyle keypad({Color? color, double size = 28}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.keyText,
      );

  static TextStyle result({Color? color}) => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.ink,
        height: 1.05,
      );
}

class AppTheme {
  static TextTheme _textTheme(Color ink) {
    final base = GoogleFonts.interTextTheme().apply(
      bodyColor: ink,
      displayColor: ink,
    );
    return base.copyWith(
      displayLarge: AppFonts.display(color: ink),
      headlineMedium: AppFonts.h1(color: ink),
      headlineSmall: AppFonts.h2(color: ink),
      titleLarge: AppFonts.h2(color: ink),
      titleMedium: AppFonts.h3(color: ink),
      bodyLarge: AppFonts.body1(color: ink),
      bodyMedium: AppFonts.body2(color: ink),
      labelLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      labelSmall: AppFonts.caption(color: ink),
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
      scaffoldBackgroundColor: Colors.transparent,
    );
    return _apply(base, _textTheme(AppColors.ink), dark: false);
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
      scaffoldBackgroundColor: Colors.transparent,
    );
    return _apply(base, _textTheme(AppColors.inkDark), dark: true);
  }

  static ThemeData _apply(ThemeData base, TextTheme textTheme,
      {required bool dark}) {
    final muted = dark ? AppColors.mutedDark : AppColors.muted;
    final line = dark ? AppColors.lineDark : AppColors.line;

    return base.copyWith(
      textTheme: textTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: SoftFadeTransitionsBuilder(),
          TargetPlatform.macOS: SoftFadeTransitionsBuilder(),
          TargetPlatform.android: SoftFadeTransitionsBuilder(),
          TargetPlatform.linux: SoftFadeTransitionsBuilder(),
          TargetPlatform.windows: SoftFadeTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: dark ? AppColors.inkDark : AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: dark ? AppColors.inkDark : AppColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: dark ? AppColors.inkDark : AppColors.ink,
          size: 26,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ctaMagenta,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.ctaMagenta.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: dark ? AppColors.surfaceDark : AppColors.surfaceAlt,
          side: BorderSide.none,
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.surfaceDark : AppColors.surfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: GoogleFonts.inter(color: muted, fontSize: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      dividerColor: line,
      chipTheme: ChipThemeData(
        backgroundColor: dark ? AppColors.surfaceDark : AppColors.surfaceAlt,
        selectedColor: AppColors.primaryMuted,
        labelStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
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
