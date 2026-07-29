import 'package:flutter_test/flutter_test.dart';
import 'package:calcpro/main.dart';

void main() {
  testWidgets('CalcPro home shows title and calculator cards', (tester) async {
    await tester.pumpWidget(const CalcProApp());
    await tester.pumpAndSettle();

    expect(find.text('CalcPro'), findsOneWidget);
    expect(find.textContaining('Every calculation'), findsOneWidget);
    expect(find.text('Basic'), findsOneWidget);
    expect(find.text('Percentage'), findsOneWidget);
  });

  testWidgets('navigates to basic calculator', (tester) async {
    await tester.pumpWidget(const CalcProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Basic'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Basic'), findsWidgets);
    expect(find.text('C'), findsWidgets);
  });
}
