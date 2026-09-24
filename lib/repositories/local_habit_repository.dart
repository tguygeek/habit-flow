import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';
import 'habit_repository.dart';

/// [HabitRepository] backed by [SharedPreferences], storing the habit list
/// as a single JSON-encoded string under [storageKey].
class LocalHabitRepository implements HabitRepository {
  LocalHabitRepository({SharedPreferences? preferences})
      : _preferences = preferences;

  static const String storageKey = 'habit_flow.habits.v1';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  @override
  Future<List<Habit>> loadAll() async {
    final SharedPreferences prefs = await _prefs;
    final String? raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return <Habit>[];
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((dynamic e) => Habit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAll(List<Habit> habits) async {
    final SharedPreferences prefs = await _prefs;
    final String encoded =
        jsonEncode(habits.map((Habit h) => h.toJson()).toList());
    await prefs.setString(storageKey, encoded);
  }
}
