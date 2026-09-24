import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Category a [Habit] belongs to. Kept as an enum so it is trivially
/// serializable and exhaustively switchable across the UI layer.
enum HabitCategory {
  health,
  productivity,
  learning,
  mindfulness,
  other;

  static HabitCategory fromName(String name) => HabitCategory.values.firstWhere(
        (HabitCategory c) => c.name == name,
        orElse: () => HabitCategory.other,
      );

  IconData get icon => switch (this) {
        HabitCategory.health => Icons.favorite,
        HabitCategory.productivity => Icons.bolt,
        HabitCategory.learning => Icons.menu_book,
        HabitCategory.mindfulness => Icons.self_improvement,
        HabitCategory.other => Icons.star,
      };

  Color get color => switch (this) {
        HabitCategory.health => Colors.redAccent,
        HabitCategory.productivity => Colors.orangeAccent,
        HabitCategory.learning => Colors.blueAccent,
        HabitCategory.mindfulness => Colors.teal,
        HabitCategory.other => Colors.purpleAccent,
      };

  String label(AppLocalizations l10n) => switch (this) {
        HabitCategory.health => l10n.categoryHealth,
        HabitCategory.productivity => l10n.categoryProductivity,
        HabitCategory.learning => l10n.categoryLearning,
        HabitCategory.mindfulness => l10n.categoryMindfulness,
        HabitCategory.other => l10n.categoryOther,
      };
}
