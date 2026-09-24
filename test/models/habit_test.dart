import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/models/habit_category.dart';

void main() {
  final Habit base = Habit(
    id: 'abc',
    name: 'Read',
    description: '10 pages a day',
    category: HabitCategory.learning,
    weeklyTarget: 6,
    createdAt: DateTime(2026, 3, 1),
    completions: <DateTime>{DateTime(2026, 3, 2)},
  );

  test('toJson/fromJson round-trip preserves all fields', () {
    final Map<String, dynamic> json = base.toJson();
    final Habit restored = Habit.fromJson(json);
    expect(restored, base);
  });

  test('toggleDay adds a day that was not completed', () {
    final Habit toggled = base.toggleDay(DateTime(2026, 3, 3));
    expect(toggled.isDoneOn(DateTime(2026, 3, 3)), isTrue);
    expect(toggled.completions.length, 2);
  });

  test('toggleDay removes a day that was already completed', () {
    final Habit toggled = base.toggleDay(DateTime(2026, 3, 2));
    expect(toggled.isDoneOn(DateTime(2026, 3, 2)), isFalse);
    expect(toggled.completions, isEmpty);
  });

  test('toggleDay ignores time-of-day components', () {
    final Habit toggled =
        base.toggleDay(DateTime(2026, 3, 2, 23, 59)); // same day, late
    expect(toggled.completions, isEmpty); // treated as already-completed day
  });

  test('copyWith only overrides provided fields', () {
    final Habit updated = base.copyWith(name: 'Read more');
    expect(updated.name, 'Read more');
    expect(updated.description, base.description);
    expect(updated.category, base.category);
    expect(updated.id, base.id);
  });

  test('equality is value-based, not identity-based', () {
    final Habit copy = Habit.fromJson(base.toJson());
    expect(identical(copy, base), isFalse);
    expect(copy, base);
  });
}
