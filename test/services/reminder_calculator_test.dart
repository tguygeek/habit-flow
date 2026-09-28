import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/services/reminder_calculator.dart';

void main() {
  group('ReminderCalculator.shouldHaveReminder', () {
    test('returns false when enableReminders is false', () {
      expect(
        ReminderCalculator.shouldHaveReminder(
          enableReminders: false,
          reminderHour: 9,
          reminderMinute: 0,
        ),
        isFalse,
      );
    });

    test('returns false when reminderHour is null', () {
      expect(
        ReminderCalculator.shouldHaveReminder(
          enableReminders: true,
          reminderHour: null,
          reminderMinute: 0,
        ),
        isFalse,
      );
    });

    test('returns false when reminderMinute is null', () {
      expect(
        ReminderCalculator.shouldHaveReminder(
          enableReminders: true,
          reminderHour: 9,
          reminderMinute: null,
        ),
        isFalse,
      );
    });

    test('returns false when both hour and minute are null', () {
      expect(
        ReminderCalculator.shouldHaveReminder(
          enableReminders: true,
          reminderHour: null,
          reminderMinute: null,
        ),
        isFalse,
      );
    });

    test('returns true when all conditions are met', () {
      expect(
        ReminderCalculator.shouldHaveReminder(
          enableReminders: true,
          reminderHour: 9,
          reminderMinute: 30,
        ),
        isTrue,
      );
    });

    test('returns true with edge case: hour 0, minute 0', () {
      expect(
        ReminderCalculator.shouldHaveReminder(
          enableReminders: true,
          reminderHour: 0,
          reminderMinute: 0,
        ),
        isTrue,
      );
    });

    test('returns true with edge case: hour 23, minute 59', () {
      expect(
        ReminderCalculator.shouldHaveReminder(
          enableReminders: true,
          reminderHour: 23,
          reminderMinute: 59,
        ),
        isTrue,
      );
    });
  });

  group('ReminderCalculator.wasCompletedBeforeDeadlineToday', () {
    test('returns true when task is completed today', () {
      final DateTime today = DateTime.now();
      final DateTime dateOnlyToday = DateTime(today.year, today.month, today.day);

      expect(
        ReminderCalculator.wasCompletedBeforeDeadlineToday(
          completions: <DateTime>{dateOnlyToday},
        ),
        isTrue,
      );
    });

    test('returns false when task is not completed today', () {
      expect(
        ReminderCalculator.wasCompletedBeforeDeadlineToday(
          completions: <DateTime>{},
        ),
        isFalse,
      );
    });

    test('returns false when only yesterday is completed', () {
      final DateTime yesterday =
          DateTime.now().subtract(const Duration(days: 1));
      final DateTime dateOnlyYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day);

      expect(
        ReminderCalculator.wasCompletedBeforeDeadlineToday(
          completions: <DateTime>{dateOnlyYesterday},
        ),
        isFalse,
      );
    });

    test('returns true when today and other days are completed', () {
      final DateTime today = DateTime.now();
      final DateTime dateOnlyToday = DateTime(today.year, today.month, today.day);
      final DateTime yesterday =
          today.subtract(const Duration(days: 1));
      final DateTime dateOnlyYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day);

      expect(
        ReminderCalculator.wasCompletedBeforeDeadlineToday(
          completions: <DateTime>{dateOnlyToday, dateOnlyYesterday},
        ),
        isTrue,
      );
    });
  });

  group('ReminderCalculator.getNextReminderTime', () {
    test('returns today at specified time when time has not passed yet', () {
      final DateTime now = DateTime(2026, 9, 20, 8, 0); // 08:00
      final DateTime nextReminder =
          ReminderCalculator.getNextReminderTime(
            reminderHour: 9,
            reminderMinute: 30,
            currentTime: now,
          );

      expect(nextReminder.hour, 9);
      expect(nextReminder.minute, 30);
      expect(nextReminder.year, 2026);
      expect(nextReminder.month, 9);
      expect(nextReminder.day, 20);
    });

    test('returns tomorrow at specified time when time has passed today', () {
      final DateTime now = DateTime(2026, 9, 20, 10, 0); // 10:00
      final DateTime nextReminder =
          ReminderCalculator.getNextReminderTime(
            reminderHour: 9,
            reminderMinute: 0,
            currentTime: now,
          );

      expect(nextReminder.hour, 9);
      expect(nextReminder.minute, 0);
      expect(nextReminder.day, 21); // tomorrow
    });

    test('handles midnight boundary correctly', () {
      final DateTime now = DateTime(2026, 9, 20, 23, 30); // 23:30
      final DateTime nextReminder =
          ReminderCalculator.getNextReminderTime(
            reminderHour: 0,
            reminderMinute: 0,
            currentTime: now,
          );

      expect(nextReminder.hour, 0);
      expect(nextReminder.minute, 0);
      expect(nextReminder.day, 21); // tomorrow
    });

    test('uses current time as default when currentTime is null', () {
      final DateTime nextReminder =
          ReminderCalculator.getNextReminderTime(
            reminderHour: 23,
            reminderMinute: 59,
            currentTime: null,
          );

      // Should return a valid DateTime in the future
      expect(nextReminder.isAfter(DateTime.now()), true);
      expect(nextReminder.hour, 23);
      expect(nextReminder.minute, 59);
    });

    test('returns exact time at edge case: 00:00', () {
      final DateTime now = DateTime(2026, 9, 20, 1, 0);
      final DateTime nextReminder =
          ReminderCalculator.getNextReminderTime(
            reminderHour: 0,
            reminderMinute: 0,
            currentTime: now,
          );

      expect(nextReminder.hour, 0);
      expect(nextReminder.minute, 0);
      expect(nextReminder.day, 21); // tomorrow at midnight
    });

    test('returns exact time at edge case: 23:59', () {
      final DateTime now = DateTime(2026, 9, 20, 8, 0);
      final DateTime nextReminder =
          ReminderCalculator.getNextReminderTime(
            reminderHour: 23,
            reminderMinute: 59,
            currentTime: now,
          );

      expect(nextReminder.hour, 23);
      expect(nextReminder.minute, 59);
      expect(nextReminder.day, 20); // today
    });
  });

  group('ReminderCalculator.shouldResetRemindersForNewDay', () {
    test('returns true when lastScheduledDate is null', () {
      expect(
        ReminderCalculator.shouldResetRemindersForNewDay(
          lastScheduledDate: null,
        ),
        isTrue,
      );
    });

    test('returns false when lastScheduledDate is today', () {
      final DateTime today = DateTime.now();
      final DateTime dateOnlyToday =
          DateTime(today.year, today.month, today.day);

      expect(
        ReminderCalculator.shouldResetRemindersForNewDay(
          lastScheduledDate: dateOnlyToday,
        ),
        isFalse,
      );
    });

    test('returns true when lastScheduledDate is yesterday', () {
      final DateTime now = DateTime.now();
      final DateTime yesterday = now.subtract(const Duration(days: 1));
      final DateTime dateOnlyYesterday =
          DateTime(yesterday.year, yesterday.month, yesterday.day);

      expect(
        ReminderCalculator.shouldResetRemindersForNewDay(
          lastScheduledDate: dateOnlyYesterday,
        ),
        isTrue,
      );
    });

    test('returns true when lastScheduledDate is several days ago', () {
      final DateTime now = DateTime.now();
      final DateTime daysAgo = now.subtract(const Duration(days: 5));
      final DateTime dateOnlyDaysAgo =
          DateTime(daysAgo.year, daysAgo.month, daysAgo.day);

      expect(
        ReminderCalculator.shouldResetRemindersForNewDay(
          lastScheduledDate: dateOnlyDaysAgo,
        ),
        isTrue,
      );
    });

    test('returns false when time components differ but date is the same', () {
      final DateTime now = DateTime.now();
      final DateTime todayWithTime =
          DateTime(now.year, now.month, now.day, 10, 30, 45);

      expect(
        ReminderCalculator.shouldResetRemindersForNewDay(
          lastScheduledDate: todayWithTime,
        ),
        isFalse,
      );
    });
  });
}
