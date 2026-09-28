/// Pure business logic for reminder calculations (no Flutter imports).
abstract class ReminderCalculator {
  /// Check if a habit should have reminders scheduled.
  ///
  /// Returns true if:
  /// - enableReminders is true
  /// - reminderHour and reminderMinute are set
  static bool shouldHaveReminder({
    required bool enableReminders,
    required int? reminderHour,
    required int? reminderMinute,
  }) {
    return enableReminders && reminderHour != null && reminderMinute != null;
  }

  /// Check if a task was completed before the deadline today.
  ///
  /// Returns true if the task is marked as done today.
  static bool wasCompletedBeforeDeadlineToday({
    required Set<DateTime> completions,
  }) {
    final DateTime today = DateTime.now();
    final DateTime dateOnlyToday = DateTime(today.year, today.month, today.day);
    return completions.contains(dateOnlyToday);
  }

  /// Get the next notification time after [currentTime] for the given hour/minute.
  /// If the time has already passed today, returns tomorrow at that time.
  static DateTime getNextReminderTime({
    required int reminderHour,
    required int reminderMinute,
    DateTime? currentTime,
  }) {
    currentTime ??= DateTime.now();
    final DateTime today = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
    );

    DateTime reminderDateTime = today.add(
      Duration(hours: reminderHour, minutes: reminderMinute),
    );

    if (reminderDateTime.isBefore(currentTime)) {
      reminderDateTime = reminderDateTime.add(const Duration(days: 1));
    }

    return reminderDateTime;
  }

  /// Check if we need to reset reminders for a new day.
  ///
  /// Returns true if the last scheduled day differs from today.
  static bool shouldResetRemindersForNewDay({
    required DateTime? lastScheduledDate,
  }) {
    if (lastScheduledDate == null) return true;

    final DateTime today = DateTime.now();
    final DateTime dateOnlyToday = DateTime(today.year, today.month, today.day);
    final DateTime dateOnlyLast = DateTime(
      lastScheduledDate.year,
      lastScheduledDate.month,
      lastScheduledDate.day,
    );

    return dateOnlyToday.isAfter(dateOnlyLast);
  }
}
