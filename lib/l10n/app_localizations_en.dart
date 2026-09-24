// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HabitFlow';

  @override
  String get homeTitle => 'My Habits';

  @override
  String get emptyHabitsTitle => 'No habits yet';

  @override
  String get emptyHabitsSubtitle => 'Tap + to create your first habit';

  @override
  String get addHabit => 'Add habit';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get habitName => 'Habit name';

  @override
  String get habitNameHint => 'e.g. Drink water, Read 10 pages';

  @override
  String get habitDescription => 'Description (optional)';

  @override
  String get category => 'Category';

  @override
  String get weeklyTarget => 'Target days per week';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteConfirmTitle => 'Delete habit?';

  @override
  String deleteConfirmBody(String name) {
    return 'This will permanently remove $name and its history.';
  }

  @override
  String currentStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count day streak',
      one: '1 day streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String completionRate(int percent) {
    return '$percent% this week';
  }

  @override
  String get markDoneToday => 'Mark done today';

  @override
  String get markedDoneToday => 'Done today';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get totalHabits => 'Total habits';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get overallCompletion => 'Overall completion';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get about => 'About';

  @override
  String get aboutBody =>
      'HabitFlow helps you build lasting habits, one day at a time.';

  @override
  String get nameRequired => 'Please enter a habit name';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryProductivity => 'Productivity';

  @override
  String get categoryLearning => 'Learning';

  @override
  String get categoryMindfulness => 'Mindfulness';

  @override
  String get categoryOther => 'Other';

  @override
  String get habitDetailTitle => 'Habit details';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get history => 'History';
}
