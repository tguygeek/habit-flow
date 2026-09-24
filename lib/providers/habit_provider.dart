import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/habit.dart';
import '../models/habit_category.dart';
import '../repositories/habit_repository.dart';
import '../services/streak_calculator.dart';

/// Holds the in-memory list of habits, persists changes through a
/// [HabitRepository], and exposes derived stats. This is the single
/// source of truth the UI layer listens to via [ChangeNotifier].
class HabitProvider extends ChangeNotifier {
  HabitProvider({required HabitRepository repository, Uuid? uuid})
      : _repository = repository,
        _uuid = uuid ?? const Uuid();

  final HabitRepository _repository;
  final Uuid _uuid;

  List<Habit> _habits = <Habit>[];
  bool _isLoading = true;
  Completer<void>? _loadCompleter;

  List<Habit> get habits => List<Habit>.unmodifiable(_habits);
  bool get isLoading => _isLoading;

  Future<void> load() {
    final Completer<void> completer = Completer<void>();
    _loadCompleter = completer;
    unawaited(_runLoad(completer));
    return completer.future;
  }

  Future<void> _runLoad(Completer<void> completer) async {
    _isLoading = true;
    notifyListeners();
    final List<Habit> loaded = await _repository.loadAll();
    _habits = loaded;
    _isLoading = false;
    notifyListeners();
    completer.complete();
  }

  /// Waits for any in-flight initial [load] to finish before a mutation
  /// proceeds. Without this, a mutation issued right after construction
  /// (e.g. a fast tap right after the provider is lazily created) could
  /// run *before* [load] resolves, and then have its change silently
  /// clobbered when [load]'s stale snapshot overwrites [_habits].
  Future<void> _awaitInitialLoad() async {
    final Completer<void>? completer = _loadCompleter;
    if (completer != null && !completer.isCompleted) {
      await completer.future;
    }
  }

  Habit? byId(String id) {
    for (final Habit h in _habits) {
      if (h.id == id) return h;
    }
    return null;
  }

  Future<void> addHabit({
    required String name,
    String description = '',
    HabitCategory category = HabitCategory.other,
    int weeklyTarget = 5,
  }) async {
    await _awaitInitialLoad();
    final Habit habit = Habit(
      id: _uuid.v4(),
      name: name,
      description: description,
      category: category,
      weeklyTarget: weeklyTarget,
      createdAt: DateTime.now(),
    );
    _habits = <Habit>[..._habits, habit];
    notifyListeners();
    await _repository.saveAll(_habits);
  }

  Future<void> updateHabit(Habit updated) async {
    await _awaitInitialLoad();
    _habits = <Habit>[
      for (final Habit h in _habits) h.id == updated.id ? updated : h,
    ];
    notifyListeners();
    await _repository.saveAll(_habits);
  }

  Future<void> deleteHabit(String id) async {
    await _awaitInitialLoad();
    _habits = _habits.where((Habit h) => h.id != id).toList();
    notifyListeners();
    await _repository.saveAll(_habits);
  }

  Future<void> toggleToday(String id) async {
    await toggleDay(id, DateTime.now());
  }

  Future<void> toggleDay(String id, DateTime day) async {
    await _awaitInitialLoad();
    final int index = _habits.indexWhere((Habit h) => h.id == id);
    if (index == -1) return;
    _habits = <Habit>[..._habits];
    _habits[index] = _habits[index].toggleDay(day);
    notifyListeners();
    await _repository.saveAll(_habits);
  }

  int get bestStreakAcrossAll => _habits.isEmpty
      ? 0
      : _habits.map(StreakCalculator.bestStreak).reduce(
            (int a, int b) => a > b ? a : b,
          );

  double get overallCompletionRate {
    if (_habits.isEmpty) return 0;
    final double sum = _habits
        .map((Habit h) => StreakCalculator.completionRate(h))
        .fold(0.0, (double a, double b) => a + b);
    return sum / _habits.length;
  }
}
