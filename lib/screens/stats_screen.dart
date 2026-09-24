import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/habit_provider.dart';

/// Screen 4: aggregate stats across all habits.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final HabitProvider provider = context.watch<HabitProvider>();
    final int percent = (provider.overallCompletionRate * 100).round();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _StatCard(
            icon: Icons.checklist,
            label: l10n.totalHabits,
            value: '${provider.habits.length}',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.local_fire_department,
            label: l10n.bestStreak,
            value: '${provider.bestStreakAcrossAll}',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.donut_large,
            label: l10n.overallCompletion,
            value: '$percent%',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
