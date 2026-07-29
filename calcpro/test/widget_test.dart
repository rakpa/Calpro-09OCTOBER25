import 'package:flutter_test/flutter_test.dart';
import 'package:calcpro/main.dart';

void main() {
  testWidgets('CalcPro home shows title and calculator cards', (tester) async {
    await tester.pumpWidget(const CalcProApp());
    await tester.pumpAndSettle();

    expect(find.text('CalcPro'), findsOneWidget);
    expect(find.text('Multi-Purpose Calculator'), findsOneWidget);
    expect(find.text('Basic Calculator'), findsOneWidget);
    expect(find.text('Percentage Calculator'), findsOneWidget);
  });

  testWidgets('navigates to basic calculator', (tester) async {
    await tester.pumpWidget(const CalcProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Basic Calculator'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Basic Calculator'), findsWidgets);
    expect(find.text('C'), findsWidgets);
  });
}
