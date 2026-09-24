import 'package:flutter/material.dart';

/// Small pill showing a streak count with a flame icon. Const-constructible
/// so it never rebuilds unless its own props change.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.streak, required this.label});

  final int streak;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color bg =
        streak > 0 ? scheme.primaryContainer : scheme.surfaceContainerHighest;
    final Color fg =
        streak > 0 ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;

    return Semantics(
      label: label,
      // container + excludeSemantics: this Semantics node stands alone with
      // exactly `label` as its accessible label, instead of merging with
      // the child Text's own semantics (which would produce something like
      // "3 day streak\n3" — the streak number spoken twice).
      container: true,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              streak > 0 ? Icons.local_fire_department : Icons.circle_outlined,
              size: 16,
              color: fg,
            ),
            const SizedBox(width: 4),
            Text(
              '$streak',
              style: TextStyle(color: fg, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
