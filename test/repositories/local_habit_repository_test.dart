import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit.dart';
import 'package:habit_flow/models/habit_category.dart';
import 'package:habit_flow/repositories/local_habit_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    // In-memory fake platform channel backing for SharedPreferences.
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('loadAll returns an empty list when nothing has been saved', () async {
    final LocalHabitRepository repo = LocalHabitRepository();
    final List<Habit> result = await repo.loadAll();
    expect(result, isEmpty);
  });

  test('saveAll then loadAll round-trips the habit list', () async {
    final LocalHabitRepository repo = LocalHabitRepository();
    final List<Habit> habits = <Habit>[
      Habit(
        id: '1',
        name: 'Exercise',
        category: HabitCategory.health,
        createdAt: DateTime(2026, 2, 1),
        completions: <DateTime>{DateTime(2026, 2, 2)},
      ),
      Habit(
        id: '2',
        name: 'Journal',
        category: HabitCategory.mindfulness,
        createdAt: DateTime(2026, 2, 3),
      ),
    ];

    await repo.saveAll(habits);
    final List<Habit> reloaded = await repo.loadAll();

    expect(reloaded, hasLength(2));
    expect(reloaded.map((Habit h) => h.id), containsAll(<String>['1', '2']));
    expect(reloaded.firstWhere((Habit h) => h.id == '1').completions, hasLength(1));
  });

  test('saveAll overwrites any previously stored list', () async {
    final LocalHabitRepository repo = LocalHabitRepository();
    await repo.saveAll(<Habit>[
      Habit(id: '1', name: 'A', category: HabitCategory.other, createdAt: DateTime(2026, 1, 1)),
    ]);
    await repo.saveAll(<Habit>[
      Habit(id: '2', name: 'B', category: HabitCategory.other, createdAt: DateTime(2026, 1, 2)),
    ]);
    final List<Habit> reloaded = await repo.loadAll();
    expect(reloaded, hasLength(1));
    expect(reloaded.single.id, '2');
  });
}
