import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/models/habit_category.dart';
import 'package:habit_flow/services/streak_calculator.dart';

Habit _habit({Set<DateTime>? completions, int weeklyTarget = 5}) {
  return Habit(
    id: 'h1',
    name: 'Test',
    category: HabitCategory.health,
    createdAt: DateTime(2026, 1, 1),
    weeklyTarget: weeklyTarget,
    completions: completions ?? <DateTime>{},
  );
}

void main() {
  final DateTime today = DateTime(2026, 9, 20); // fixed reference "now"

  group('StreakCalculator.currentStreak', () {
    test('returns 0 when there are no completions', () {
      final Habit habit = _habit();
      expect(StreakCalculator.currentStreak(habit, now: today), 0);
    });

    test('counts today when today is completed', () {
      final Habit habit = _habit(completions: <DateTime>{today});
      expect(StreakCalculator.currentStreak(habit, now: today), 1);
    });

    test('counts consecutive days ending today', () {
      final Habit habit = _habit(completions: <DateTime>{
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      });
      expect(StreakCalculator.currentStreak(habit, now: today), 3);
    });

    test('still counts streak through yesterday if today not done yet', () {
      final Habit habit = _habit(completions: <DateTime>{
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 2)),
      });
      expect(StreakCalculator.currentStreak(habit, now: today), 2);
    });

    test('resets to 0 if there is a gap before yesterday', () {
      final Habit habit = _habit(completions: <DateTime>{
        today.subtract(const Duration(days: 3)),
      });
      expect(StreakCalculator.currentStreak(habit, now: today), 0);
    });

    test('breaks the streak on a gap even with older completions', () {
      final Habit habit = _habit(completions: <DateTime>{
        today,
        today.subtract(const Duration(days: 1)),
        today.subtract(const Duration(days: 5)),
      });
      expect(StreakCalculator.currentStreak(habit, now: today), 2);
    });
  });

  group('StreakCalculator.bestStreak', () {
    test('returns 0 for an empty habit', () {
      expect(StreakCalculator.bestStreak(_habit()), 0);
    });

    test('returns 1 for a single isolated completion', () {
      final Habit habit = _habit(completions: <DateTime>{today});
      expect(StreakCalculator.bestStreak(habit), 1);
    });

    test('finds the longest run even if it is not the most recent', () {
      final Habit habit = _habit(completions: <DateTime>{
        DateTime(2026, 9, 1),
        DateTime(2026, 9, 2),
        DateTime(2026, 9, 3),
        DateTime(2026, 9, 4),
        DateTime(2026, 9, 10),
        DateTime(2026, 9, 11),
      });
      expect(StreakCalculator.bestStreak(habit), 4);
    });
  });

  group('StreakCalculator.completionRate', () {
    test('returns 0 for an empty habit', () {
      expect(StreakCalculator.completionRate(_habit(), now: today), 0);
    });

    test('returns 1.0 when every day in the window is completed', () {
      final Set<DateTime> completions = <DateTime>{
        for (int i = 0; i < 7; i++) today.subtract(Duration(days: i)),
      };
      final Habit habit = _habit(completions: completions);
      expect(
        StreakCalculator.completionRate(habit, now: today),
        closeTo(1.0, 0.0001),
      );
    });

    test('returns a partial rate for partial completion', () {
      final Habit habit = _habit(completions: <DateTime>{
        today,
        today.subtract(const Duration(days: 1)),
      });
      expect(
        StreakCalculator.completionRate(habit, windowDays: 4, now: today),
        closeTo(0.5, 0.0001),
      );
    });
  });

  group('StreakCalculator.metWeeklyTarget', () {
    test('true when completions meet the weekly target', () {
      final Set<DateTime> completions = <DateTime>{
        for (int i = 0; i < 5; i++) today.subtract(Duration(days: i)),
      };
      final Habit habit = _habit(completions: completions, weeklyTarget: 5);
      expect(StreakCalculator.metWeeklyTarget(habit, now: today), isTrue);
    });

    test('false when completions fall short of the weekly target', () {
      final Habit habit = _habit(
        completions: <DateTime>{today},
        weeklyTarget: 5,
      );
      expect(StreakCalculator.metWeeklyTarget(habit, now: today), isFalse);
    });
  });
}
