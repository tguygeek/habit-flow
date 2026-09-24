// This file exists so that `flutter create .` does not regenerate the
// default counter-app template test (which references a non-existent
// `MyApp` class) on top of this project.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('HabitFlowApp launches and shows the home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const HabitFlowApp());
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
