// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child common_widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:nchito/main.dart';

void main() {
  testWidgets('MyApp builds and renders initial frame', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
    // Let the splash screen timer finish so no pending timers remain
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
