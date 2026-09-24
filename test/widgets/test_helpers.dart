import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/l10n/app_localizations.dart';
import 'package:habit_flow/providers/habit_provider.dart';
import 'package:habit_flow/providers/settings_provider.dart';
import 'package:habit_flow/repositories/habit_repository.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:provider/provider.dart';

/// In-memory repository shared by widget tests so no real storage plugin
/// is required.
class InMemoryHabitRepository implements HabitRepository {
  InMemoryHabitRepository([List<Habit>? initial])
      : _habits = List<Habit>.of(initial ?? <Habit>[]);

  List<Habit> _habits;

  @override
  Future<List<Habit>> loadAll() async => List<Habit>.of(_habits);

  @override
  Future<void> saveAll(List<Habit> habits) async {
    _habits = List<Habit>.of(habits);
  }
}

/// Wraps [child] with MaterialApp + localization delegates + the app's
/// providers, so widget tests can pump real screens/widgets directly.
Widget wrapForTest(
  Widget child, {
  List<Habit>? initialHabits,
  Locale locale = const Locale('en'),
}) {
  return MultiProvider(
    providers: <ChangeNotifierProvider<dynamic>>[
      ChangeNotifierProvider<HabitProvider>(
        create: (_) => HabitProvider(
          repository: InMemoryHabitRepository(initialHabits),
        )..load(),
      ),
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(),
      ),
    ],
    // Mirrors the real app's _AppView: MaterialApp.locale follows
    // SettingsProvider so a language change in a Settings screen test
    // actually re-renders localized text, just like in production.
    child: Consumer<SettingsProvider>(
      builder: (BuildContext context, SettingsProvider settings, _) {
        return MaterialApp(
          locale: settings.locale ?? locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: child,
        );
      },
    ),
  );
}

/// Pumps [child] and waits for the async provider load() to settle.
Future<void> pumpAndSettleTest(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(child);
  await tester.pumpAndSettle();
}
