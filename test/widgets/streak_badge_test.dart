import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/widgets/streak_badge.dart';

void main() {
  testWidgets('shows the fire icon and count when streak > 0', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StreakBadge(streak: 5, label: '5 day streak')),
      ),
    );

    expect(find.text('5'), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
  });

  testWidgets('shows an outline icon when streak is 0', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StreakBadge(streak: 0, label: 'No streak yet')),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
  });

  testWidgets('exposes the semantic label for screen readers', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StreakBadge(streak: 3, label: '3 day streak')),
      ),
    );

    expect(find.bySemanticsLabel('3 day streak'), findsOneWidget);

    handle.dispose();
  });
}
