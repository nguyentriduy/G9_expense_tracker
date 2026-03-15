import 'package:expense_tracker_app/app/expense_tracker_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen is shown on app start', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    expect(find.text('Expense Tracker'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.text('Đăng nhập'), findsAtLeastNWidgets(1));
  });
}
