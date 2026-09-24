import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../services/streak_calculator.dart';
import '../widgets/week_heatmap.dart';
import 'add_edit_habit_screen.dart';

/// Screen 2: detail + stats for a single habit, with edit/delete actions.
class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habitId});

  final String habitId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final HabitProvider provider = context.watch<HabitProvider>();
    final Habit? habit = provider.byId(habitId);

    if (habit == null) {
      // Habit was deleted elsewhere (e.g. another screen); pop gracefully.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final int streak = StreakCalculator.currentStreak(habit);
    final int best = StreakCalculator.bestStreak(habit);
    final int percent =
        (StreakCalculator.completionRate(habit) * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.habitDetailTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: l10n.editHabit,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AddEditHabitScreen(existing: habit),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.delete,
            onPressed: () => _confirmDelete(context, habit, l10n, provider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(habit.name, style: Theme.of(context).textTheme.headlineSmall),
          if (habit.description.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(habit.description),
          ],
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatTile(label: l10n.currentStreak(streak), value: '$streak'),
              ),
              Expanded(
                child: _StatTile(label: l10n.bestStreak, value: '$best'),
              ),
              Expanded(
                child: _StatTile(
                  label: l10n.completionRate(percent),
                  value: '$percent%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.last7Days, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          WeekHeatmap(habit: habit),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => provider.toggleToday(habit.id),
            icon: Icon(
              habit.isDoneToday ? Icons.check_circle : Icons.circle_outlined,
            ),
            label: Text(
              habit.isDoneToday ? l10n.markedDoneToday : l10n.markDoneToday,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Habit habit,
    AppLocalizations l10n,
    HabitProvider provider,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmBody(habit.name)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await provider.deleteHabit(habit.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
