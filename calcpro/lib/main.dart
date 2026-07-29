import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/screens/home_screen.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalcProApp());
}

class CalcProApp extends StatelessWidget {
  const CalcProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
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
  }
}
