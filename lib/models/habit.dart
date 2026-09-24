import 'package:flutter/foundation.dart';
import 'habit_category.dart';

/// Immutable domain model for a single habit.
///
/// Completions are stored as a set of date-only [DateTime]s (time
/// components stripped) so equality and lookups are cheap and unambiguous.
@immutable
class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    this.description = '',
    this.weeklyTarget = 5,
    this.completions = const <DateTime>{},
    this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final HabitCategory category;
  final int weeklyTarget;
  final DateTime createdAt;
  final Set<DateTime> completions;
  final String? imageUrl;

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool isDoneOn(DateTime day) => completions.contains(dateOnly(day));

  bool get isDoneToday => isDoneOn(DateTime.now());

  Habit copyWith({
    String? name,
    String? description,
    HabitCategory? category,
    int? weeklyTarget,
    Set<DateTime>? completions,
    String? imageUrl,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      weeklyTarget: weeklyTarget ?? this.weeklyTarget,
      createdAt: createdAt,
      completions: completions ?? this.completions,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Habit toggleDay(DateTime day) {
    final DateTime key = dateOnly(day);
    final Set<DateTime> next = Set<DateTime>.from(completions);
    if (!next.remove(key)) {
      next.add(key);
    }
    return copyWith(completions: next);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'category': category.name,
        'weeklyTarget': weeklyTarget,
        'createdAt': createdAt.toIso8601String(),
        'completions':
            completions.map((DateTime d) => d.toIso8601String()).toList(),
        'imageUrl': imageUrl,
      };

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      category: HabitCategory.fromName(json['category'] as String),
      weeklyTarget: (json['weeklyTarget'] as num?)?.toInt() ?? 5,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completions: ((json['completions'] as List<dynamic>?) ?? <dynamic>[])
          .map((dynamic e) => DateTime.parse(e as String))
          .toSet(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.category == category &&
        other.weeklyTarget == weeklyTarget &&
        other.createdAt == createdAt &&
        setEquals(other.completions, completions) &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        category,
        weeklyTarget,
        createdAt,
        completions.length,
        imageUrl,
      );
}
