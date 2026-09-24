import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/models/habit_category.dart';
import 'package:habit_flow/screens/home_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows empty state when there are no habits', (WidgetTester tester) async {
    await pumpAndSettleTest(
      tester,
      wrapForTest(const HomeScreen(), initialHabits: <Habit>[]),
    );
    expect(find.text('No habits yet'), findsOneWidget);
  });

  testWidgets('lists existing habits and hides the empty state', (WidgetTester tester) async {
    final List<Habit> habits = <Habit>[
      Habit(id: '1', name: 'Stretch', category: HabitCategory.health, createdAt: DateTime(2026, 1, 1)),
      Habit(id: '2', name: 'Read', category: HabitCategory.learning, createdAt: DateTime(2026, 1, 2)),
    ];
    await pumpAndSettleTest(
      tester,
      wrapForTest(const HomeScreen(), initialHabits: habits),
    );
    expect(find.text('Stretch'), findsOneWidget);
    expect(find.text('Read'), findsOneWidget);
    expect(find.text('No habits yet'), findsNothing);
  });

  testWidgets('the add-habit FAB is present and labeled', (WidgetTester tester) async {
    await pumpAndSettleTest(
      tester,
      wrapForTest(const HomeScreen(), initialHabits: <Habit>[]),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
