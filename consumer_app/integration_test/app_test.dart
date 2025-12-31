import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:consumer_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Consumer App E2E Tests', () {
    testWidgets('Complete Consumer workflow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Test 1: Home screen loads
      expect(find.text('Remote Inventory'), findsOneWidget);
      expect(find.text('Consumer'), findsOneWidget);

      // Test 2: Enter session ID
      final sessionField = find.byKey(const Key('session_id_input'));
      await tester.enterText(sessionField, 'TEST-SESSION-123');
      await tester.pumpAndSettle();

      // Test 3: Enter consumer name
      final nameField = find.byKey(const Key('consumer_name_input'));
      await tester.enterText(nameField, 'E2E Test Consumer');
      await tester.pumpAndSettle();

      // Test 4: Join session
      final joinButton = find.text('JOIN SESSION');
      await tester.tap(joinButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test 5: Controller screen appears
      expect(find.text('J.A.R.V.I.S'), findsOneWidget);
      expect(find.text('CONTROLLER'), findsOneWidget);

      // Test 6: Touch controls are present
      expect(find.byKey(const Key('touch_controller')), findsOneWidget);
      expect(find.byKey(const Key('command_buttons')), findsOneWidget);

      // Test 7: Test swipe gestures
      final controller = find.byKey(const Key('touch_controller'));
      if (controller.evaluate().isNotEmpty) {
        // Swipe left
        await tester.fling(controller, const Offset(-200, 0), 500);
        await tester.pumpAndSettle();

        // Swipe right
        await tester.fling(controller, const Offset(200, 0), 500);
        await tester.pumpAndSettle();

        // Swipe up
        await tester.fling(controller, const Offset(0, -200), 500);
        await tester.pumpAndSettle();

        // Swipe down
        await tester.fling(controller, const Offset(0, 200), 500);
        await tester.pumpAndSettle();
      }

      // Test 8: Test double tap (stop command)
      await tester.tap(controller);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(controller);
      await tester.pumpAndSettle();

      // Test 9: Test long press (laser pointer)
      await tester.longPress(controller);
      await tester.pumpAndSettle();

      // Test 10: Command history is visible
      expect(find.byKey(const Key('command_history')), findsOneWidget);

      // Test 11: Stop button works
      final stopButton = find.byKey(const Key('stop_button'));
      if (stopButton.evaluate().isNotEmpty) {
        await tester.tap(stopButton);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Voice command test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to controller
      // ... (setup code)

      // Test voice command button
      final voiceButton = find.byKey(const Key('voice_command_button'));
      if (voiceButton.evaluate().isNotEmpty) {
        await tester.tap(voiceButton);
        await tester.pumpAndSettle();

        // TODO: Mock speech recognition
        // Verify voice command UI appears
      }
    });

    testWidgets('Text command test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to controller
      // ... (setup code)

      // Test text command input
      final textButton = find.byKey(const Key('text_command_button'));
      if (textButton.evaluate().isNotEmpty) {
        await tester.tap(textButton);
        await tester.pumpAndSettle();

        final textField = find.byKey(const Key('command_text_field'));
        await tester.enterText(textField, 'move left');
        await tester.pumpAndSettle();

        final sendButton = find.byKey(const Key('send_command_button'));
        await tester.tap(sendButton);
        await tester.pumpAndSettle();

        // Verify command was sent
        expect(find.text('move left'), findsOneWidget);
      }
    });

    testWidgets('Gesture recognition performance', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to controller
      // ... (setup code)

      final controller = find.byKey(const Key('touch_controller'));

      // Measure gesture response time
      final stopwatch = Stopwatch()..start();

      await tester.fling(controller, const Offset(-200, 0), 500);
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Gesture should be recognized in less than 100ms
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
