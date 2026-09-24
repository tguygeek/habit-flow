import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HabitFlow end-to-end', () {
    testWidgets(
      'creating a habit from the empty state shows it in the list',
      (WidgetTester tester) async {
        await tester.pumpWidget(const HabitFlowApp());
        await tester.pumpAndSettle();

        expect(find.text('No habits yet'), findsOneWidget);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, 'Morning run');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(find.text('Morning run'), findsOneWidget);
        expect(find.text('No habits yet'), findsNothing);
      },
    );

    testWidgets(
      'marking a habit done today updates the streak on the detail screen',
      (WidgetTester tester) async {
        await tester.pumpWidget(const HabitFlowApp());
        await tester.pumpAndSettle();

        // Create a habit first.
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).first, 'Meditate');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Toggle it done from the home list.
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Open the detail screen and confirm the streak reflects it.
        await tester.tap(find.text('Meditate'));
        await tester.pumpAndSettle();

        expect(find.text('1'), findsWidgets); // streak value shown as "1"
      },
    );
  });
}
