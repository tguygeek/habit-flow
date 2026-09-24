import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/providers/habit_provider.dart';
import 'package:habit_flow/screens/add_edit_habit_screen.dart';
import 'package:provider/provider.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows a validation error when saving with an empty name', (WidgetTester tester) async {
    await pumpAndSettleTest(
      tester,
      wrapForTest(const AddEditHabitScreen()),
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a habit name'), findsOneWidget);
  });

  testWidgets('saving a valid name adds a habit and pops back to the previous screen', (WidgetTester tester) async {
    // Mount AddEditHabitScreen behind a real navigation stack (push/pop),
    // matching how it's actually reached in the app — pop()ing the very
    // last route in the stack (as would happen if this screen were the
    // test's `home`) tears down the whole tree, which isn't representative.
    await pumpAndSettleTest(
      tester,
      wrapForTest(
        Builder(
          builder: (BuildContext context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AddEditHabitScreen(),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Yoga');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Back on the previous screen.
    expect(find.text('Open'), findsOneWidget);

    final BuildContext context = tester.element(find.byType(Scaffold).first);
    final HabitProvider provider = Provider.of<HabitProvider>(context, listen: false);
    expect(provider.habits.any((h) => h.name == 'Yoga'), isTrue);
  });
}
