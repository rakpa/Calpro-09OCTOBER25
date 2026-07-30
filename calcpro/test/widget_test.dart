import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/main.dart';
import 'package:calcpro/services/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'onboarded': true});
    await AppState.instance.load();
  });

  testWidgets('splash then home greeting', (tester) async {
    await tester.pumpWidget(const CalcProApp());
    expect(find.text('CalcPro'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    expect(find.textContaining('Good'), findsOneWidget);
    expect(find.text('Popular Calculators'), findsOneWidget);
    expect(find.text('Percentage'), findsWidgets);
  });

  testWidgets('navigates to percentage calculator', (tester) async {
    await tester.pumpWidget(const CalcProApp());
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Percentage').first);
    await tester.pumpAndSettle();

    expect(find.text('Percentage Calculator'), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);
  });
}
