import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import 'add_edit_habit_screen.dart';
import 'habit_detail_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

/// Screen 1: the list of all habits with a quick "mark done today" action.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final HabitProvider provider = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: l10n.statsTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const StatsScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settingsTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: _Body(provider: provider, l10n: l10n),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AddEditHabitScreen(),
          ),
        ),
        tooltip: l10n.addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.provider, required this.l10n});

  final HabitProvider provider;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final List<Habit> habits = provider.habits;
    if (habits.isEmpty) {
      return _EmptyState(l10n: l10n);
    }
    // ListView.builder: only visible rows are built/laid out, keeping the
    // list smooth (no jank) regardless of how many habits exist.
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (BuildContext context, int index) {
        final Habit habit = habits[index];
        return HabitCard(
          key: ValueKey<String>(habit.id),
          habit: habit,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => HabitDetailScreen(habitId: habit.id),
            ),
          ),
          onToggleToday: () => provider.toggleToday(habit.id),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.checklist_rtl,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.emptyHabitsTitle,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyHabitsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
