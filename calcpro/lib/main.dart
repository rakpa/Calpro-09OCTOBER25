import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/screens/splash_screen.dart';
import 'package:calcpro/screens/onboarding_screen.dart';
import 'package:calcpro/screens/main_shell.dart';
import 'package:calcpro/screens/basic_screen.dart';
import 'package:calcpro/screens/scientific_screen.dart';
import 'package:calcpro/screens/percentage_screen.dart';
import 'package:calcpro/screens/convert_screen.dart';
import 'package:calcpro/screens/financial_screen.dart';
import 'package:calcpro/screens/mortgage_screen.dart';
import 'package:calcpro/screens/age_screen.dart';
import 'package:calcpro/screens/time_screen.dart';
import 'package:calcpro/screens/date_diff_screen.dart';
import 'package:calcpro/screens/discount_screen.dart';
import 'package:calcpro/screens/tip_screen.dart';
import 'package:calcpro/screens/health_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.load();
  runApp(const CalcProApp());
}

class CalcProApp extends StatelessWidget {
  const CalcProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Calcara',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: AppState.instance.themeMode,
          home: const _RootGate(),
          routes: {
            '/basic': (_) => const BasicScreen(),
            '/scientific': (_) => const ScientificScreen(),
            '/percentage': (_) => const PercentageScreen(),
            '/convert': (_) => const ConvertScreen(),
            '/financial': (_) => const FinancialScreen(),
            '/mortgage': (_) => const MortgageScreen(),
            '/age': (_) => const AgeScreen(),
            '/time': (_) => const TimeScreen(),
            '/date-diff': (_) => const DateDiffScreen(),
            '/discount': (_) => const DiscountScreen(),
            '/tip': (_) => const TipScreen(),
            '/health': (_) => const HealthScreen(),
          },
        );
      },
    );
  }
}

class _RootGate extends StatefulWidget {
  const _RootGate();

  @override
  State<_RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<_RootGate> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onFinished: () => setState(() => _showSplash = false),
      );
    }
    if (!AppState.instance.onboarded) {
      return OnboardingScreen(
        onDone: () async {
          await AppState.instance.completeOnboarding();
          setState(() {});
        },
      );
    }
    return const MainShell();
  }
}
