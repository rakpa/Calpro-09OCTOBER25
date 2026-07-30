import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/main.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/screens/percentage_screen.dart';
import 'package:calcpro/screens/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'onboarded_v2': true});
    await AppState.instance.load();
  });

  testWidgets('Calcara splash shows brand and pitch', (tester) async {
    var finished = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(onFinished: () => finished = true),
      ),
    );
    await tester.pump();

    expect(find.text('Calcara'), findsOneWidget);
    expect(find.text('Smart calculators for everyday life.'), findsOneWidget);
    expect(find.textContaining('Fast. Beautiful. Accurate.'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3300));
    expect(finished, isTrue);
  });

  testWidgets('splash then home greeting', (tester) async {
    await tester.pumpWidget(const CalcProApp());
    expect(find.text('Calcara'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 3300));
    await tester.pumpAndSettle();

    expect(find.textContaining('Good'), findsOneWidget);
    expect(find.text('Popular Calculators'), findsOneWidget);
  });

  testWidgets('percentage screen shows keypad', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const PercentageScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Percentage'), findsOneWidget);
    expect(find.text('X% of Y'), findsOneWidget);
    expect(find.text('What %'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
