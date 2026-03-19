<<<<<<< HEAD
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Material smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Expense Tracker'))),
    );

    expect(find.text('Expense Tracker'), findsOneWidget);
=======
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
>>>>>>> origin/feature/categories
  });
}
