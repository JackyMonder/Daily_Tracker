// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:expenses_app/main.dart';

void main() {
  testWidgets('App shows Expenses title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyExpensesApp());

    // Verify the home screen title is present.
    expect(find.text('Expenses'), findsOneWidget);
  });
}
