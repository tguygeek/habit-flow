import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/screens/settings_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('renders language and theme controls', (WidgetTester tester) async {
    await pumpAndSettleTest(tester, wrapForTest(const SettingsScreen()));

    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.byType(SegmentedButton<String>), findsOneWidget);
    expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
  });

  testWidgets('switching the language segment updates the locale-dependent text', (WidgetTester tester) async {
    await pumpAndSettleTest(tester, wrapForTest(const SettingsScreen()));

    await tester.tap(find.text('FR'));
    await tester.pumpAndSettle();

    expect(find.text('Paramètres'), findsOneWidget);
  });
}
