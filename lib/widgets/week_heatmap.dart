import 'package:flutter/material.dart';

import '../models/habit.dart';

/// Row of 7 small squares showing completion for the last [days] days,
/// oldest first. Pure presentational widget, const-constructible.
class WeekHeatmap extends StatelessWidget {
  const WeekHeatmap({super.key, required this.habit, this.days = 7});

  final Habit habit;
  final int days;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final DateTime today = Habit.dateOnly(DateTime.now());
    final List<DateTime> range = List<DateTime>.generate(
      days,
      (int i) => today.subtract(Duration(days: days - 1 - i)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (final DateTime day in range)
          Semantics(
            label:
                '${day.day}/${day.month}: ${habit.isDoneOn(day) ? 'done' : 'not done'}',
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: habit.isDoneOn(day)
                    ? habit.category.color
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 11,
                  color: habit.isDoneOn(day)
                      ? scheme.onPrimary
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
