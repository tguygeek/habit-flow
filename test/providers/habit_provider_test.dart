import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/models/habit_category.dart';
import 'package:habit_flow/providers/habit_provider.dart';
import 'package:habit_flow/repositories/habit_repository.dart';

/// In-memory fake so provider tests never touch platform channels
/// (SharedPreferences) and stay fast and deterministic.
class FakeHabitRepository implements HabitRepository {
  List<Habit> stored = <Habit>[];
  int saveCallCount = 0;

  @override
  Future<List<Habit>> loadAll() async => List<Habit>.of(stored);

  @override
  Future<void> saveAll(List<Habit> habits) async {
    stored = List<Habit>.of(habits);
    saveCallCount++;
  }
}

void main() {
  late FakeHabitRepository repo;
  late HabitProvider provider;

  setUp(() {
    repo = FakeHabitRepository();
    provider = HabitProvider(repository: repo);
  });

  test('load() populates habits from the repository', () async {
    repo.stored = <Habit>[
      Habit(
        id: '1',
        name: 'Existing',
        category: HabitCategory.other,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];
    await provider.load();
    expect(provider.habits, hasLength(1));
    expect(provider.isLoading, isFalse);
  });

  test('addHabit appends a new habit and persists it', () async {
    await provider.load();
    await provider.addHabit(
        name: 'Meditate', category: HabitCategory.mindfulness);
    expect(provider.habits, hasLength(1));
    expect(provider.habits.first.name, 'Meditate');
    expect(repo.saveCallCount, greaterThan(0));
  });

  test('deleteHabit removes the habit by id', () async {
    await provider.load();
    await provider.addHabit(name: 'Temp');
    final String id = provider.habits.first.id;
    await provider.deleteHabit(id);
    expect(provider.habits, isEmpty);
  });

  test('toggleToday flips today\'s completion for the given habit', () async {
    await provider.load();
    await provider.addHabit(name: 'Water');
    final String id = provider.habits.first.id;

    expect(provider.habits.first.isDoneToday, isFalse);
    await provider.toggleToday(id);
    expect(provider.byId(id)!.isDoneToday, isTrue);
    await provider.toggleToday(id);
    expect(provider.byId(id)!.isDoneToday, isFalse);
  });

  test('updateHabit replaces the matching habit in place', () async {
    await provider.load();
    await provider.addHabit(name: 'Old name');
    final Habit original = provider.habits.first;
    await provider.updateHabit(original.copyWith(name: 'New name'));
    expect(provider.byId(original.id)!.name, 'New name');
    expect(provider.habits, hasLength(1));
  });

  test('bestStreakAcrossAll returns 0 when there are no habits', () async {
    await provider.load();
    expect(provider.bestStreakAcrossAll, 0);
  });

  test('overallCompletionRate averages across all habits', () async {
    await provider.load();
    await provider.addHabit(name: 'A');
    await provider.addHabit(name: 'B');
    final String idA = provider.habits[0].id;
    await provider.toggleToday(idA); // A done today, B not
    // A contributes ~1/7 today-only, B contributes 0 -> average is small but > 0
    expect(provider.overallCompletionRate, greaterThan(0));
    expect(provider.overallCompletionRate, lessThan(1));
  });

  test(
    'a mutation issued right after construction is not clobbered by the '
    'in-flight initial load (regression test)',
    () async {
      // Deliberately do NOT await load() before mutating, to reproduce a
      // fast tap that fires before the initial load resolves.
      final Future<void> loadFuture = provider.load();
      final Future<void> addFuture = provider.addHabit(name: 'Fast tap');

      await Future.wait<void>(<Future<void>>[loadFuture, addFuture]);

      expect(provider.habits.any((Habit h) => h.name == 'Fast tap'), isTrue);
    },
  );
}
