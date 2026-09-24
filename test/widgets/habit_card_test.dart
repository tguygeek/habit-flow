import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/l10n/app_localizations.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/models/habit_category.dart';
import 'package:habit_flow/widgets/habit_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(body: child),
  );
}

void main() {
  final Habit habit = Habit(
    id: '1',
    name: 'Drink water',
    category: HabitCategory.health,
    createdAt: DateTime(2026, 1, 1),
  );

  testWidgets('renders the habit name', (WidgetTester tester) async {
    await tester.pumpWidget(
      _wrap(
        HabitCard(habit: habit, onTap: () {}, onToggleToday: () {}),
      ),
    );
    expect(find.text('Drink water'), findsOneWidget);
  });

  testWidgets('tapping the card triggers onTap', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      _wrap(
        HabitCard(
          habit: habit,
          onTap: () => tapped = true,
          onToggleToday: () {},
        ),
      ),
    );
    await tester.tap(find.byType(ListTile));
    expect(tapped, isTrue);
  });

  testWidgets('tapping the checkbox triggers onToggleToday',
      (WidgetTester tester) async {
    bool toggled = false;
    await tester.pumpWidget(
      _wrap(
        HabitCard(
          habit: habit,
          onTap: () {},
          onToggleToday: () => toggled = true,
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    expect(toggled, isTrue);
  });
}
