import '../models/habit.dart';

/// Pure functions computing streaks and completion rates from a [Habit]'s
/// completion set. Kept free of Flutter/UI imports so it is trivial to
/// unit test in isolation.
class StreakCalculator {
  const StreakCalculator._();

  /// Number of consecutive days, ending today (or yesterday if today isn't
  /// done yet), on which the habit was completed.
  static int currentStreak(Habit habit, {DateTime? now}) {
    final DateTime today = Habit.dateOnly(now ?? DateTime.now());
    DateTime cursor = today;

    if (!habit.completions.contains(cursor)) {
      // Today not done yet: streak can still be "alive" through yesterday.
      cursor = cursor.subtract(const Duration(days: 1));
      if (!habit.completions.contains(cursor)) {
        return 0;
      }
    }

    int streak = 0;
    while (habit.completions.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Longest run of consecutive completed days in the habit's history.
  static int bestStreak(Habit habit) {
    if (habit.completions.isEmpty) return 0;
    final List<DateTime> sorted = habit.completions.toList()..sort();
    int best = 1;
    int running = 1;
    for (int i = 1; i < sorted.length; i++) {
      final int gap = sorted[i].difference(sorted[i - 1]).inDays;
      if (gap == 1) {
        running++;
      } else if (gap > 1) {
        running = 1;
      }
      if (running > best) best = running;
    }
    return best;
  }

  /// Fraction (0.0–1.0) of the last [windowDays] days that were completed.
  static double completionRate(
    Habit habit, {
    int windowDays = 7,
    DateTime? now,
  }) {
    if (windowDays <= 0) return 0;
    final DateTime today = Habit.dateOnly(now ?? DateTime.now());
    int done = 0;
    for (int i = 0; i < windowDays; i++) {
      final DateTime day = today.subtract(Duration(days: i));
      if (habit.completions.contains(day)) done++;
    }
    return done / windowDays;
  }

  /// Whether the habit met its weekly target for the last 7 days.
  static bool metWeeklyTarget(Habit habit, {DateTime? now}) {
    final int done =
        (completionRate(habit, windowDays: 7, now: now) * 7).round();
    return done >= habit.weeklyTarget;
  }
}
