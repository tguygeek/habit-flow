import '../models/habit.dart';

/// Abstraction over habit persistence so [HabitProvider] never depends on a
/// concrete storage mechanism. Makes the provider trivially testable with
/// an in-memory fake.
abstract class HabitRepository {
  Future<List<Habit>> loadAll();
  Future<void> saveAll(List<Habit> habits);
}
