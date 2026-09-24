import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../services/streak_calculator.dart';
import 'streak_badge.dart';

/// A single row in the habit list: icon/cover, name, streak badge and a
/// checkbox to mark today done. Stateless and const-friendly so
/// [ListView.builder] can recycle it cheaply — the list itself is the only
/// thing that rebuilds when a habit changes.
class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onToggleToday,
  });

  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onToggleToday;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final int streak = StreakCalculator.currentStreak(habit);
    final bool doneToday = habit.isDoneToday;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: _Leading(habit: habit),
        title: Text(habit.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          l10n.currentStreak(streak),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StreakBadge(streak: streak, label: l10n.currentStreak(streak)),
            const SizedBox(width: 8),
            Semantics(
              label: doneToday ? l10n.markedDoneToday : l10n.markDoneToday,
              button: true,
              child: Checkbox(
                value: doneToday,
                onChanged: (_) => onToggleToday(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final String? url = habit.imageUrl;
    if (url == null || url.isEmpty) {
      return CircleAvatar(
        backgroundColor: habit.category.color.withValues(alpha: 0.15),
        child: Icon(habit.category.icon, color: habit.category.color),
      );
    }
    // Lazy-loaded, disk+memory cached, and decoded at display resolution
    // so large remote images never blow up memory for a 40x40 avatar.
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        memCacheWidth: 80,
        placeholder: (BuildContext context, String _) => Container(
          width: 40,
          height: 40,
          color: habit.category.color.withValues(alpha: 0.15),
        ),
        errorWidget: (BuildContext context, String _, Object __) => Icon(
          habit.category.icon,
          color: habit.category.color,
        ),
      ),
    );
  }
}
