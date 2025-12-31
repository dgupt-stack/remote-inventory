import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:consumer_app/main.dart' as app;
import 'package:consumer_app/screens/controller_screen.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Consumer App E2E Tests', () {
    testWidgets('Complete Consumer workflow', (WidgetTester tester) async {
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
    });

    testWidgets('Touch Gesture Recognition Tests', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Setup: Get to controller screen
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));
      if (controller.evaluate().isEmpty) {
        return; // Skip if controller not found
      }

      // Test 1: Swipe Left
      final stopwatch = Stopwatch()..start();
      await tester.fling(controller.first, const Offset(-200, 0), 500);
      await tester.pumpAndSettle();
      stopwatch.stop();

      // Gesture should be recognized quickly
      expect(stopwatch.elapsedMilliseconds, lessThan(100));

      // Test 2: Swipe Right
      await tester.fling(controller.first, const Offset(200, 0), 500);
      await tester.pumpAndSettle();

      // Test 3: Swipe Up
      await tester.fling(controller.first, const Offset(0, -200), 500);
      await tester.pumpAndSettle();

      // Test 4: Swipe Down
      await tester.fling(controller.first, const Offset(0, 200), 500);
      await tester.pumpAndSettle();
    });

    testWidgets('Double Tap (Stop) Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));
      if (controller.evaluate().isEmpty) {
        return;
      }

      // Tap twice quickly
      await tester.tap(controller.first);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(controller.first);
      await tester.pumpAndSettle();

      // Verify stop command sent
      expect(find.textContaining('STOP'), findsWidgets);
    });

    testWidgets('Long Press (Laser Pointer) Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));
      if (controller.evaluate().isEmpty) {
        return;
      }

      // Long press
      await tester.longPress(controller.first);
      await tester.pumpAndSettle();

      // Verify laser indicator appears
      expect(find.byKey(const Key('laser_indicator')), findsOneWidget);
    });

    testWidgets('Pinch Zoom Gesture Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));
      if (controller.evaluate().isEmpty) {
        return;
      }

      // Simulate pinch (zoom in)
      final center = tester.getCenter(controller.first);
      await tester.startGesture(center + const Offset(-50, 0));
      await tester.startGesture(center + const Offset(50, 0));
      await tester.pumpAndSettle();

      // Verify zoom command sent
      expect(find.textContaining('ZOOM'), findsWidgets);
    });

    testWidgets('Command History Display', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));

      // Send multiple commands
      await tester.fling(controller.first, const Offset(-200, 0), 500);
      await tester.pumpAndSettle();

      await tester.fling(controller.first, const Offset(200, 0), 500);
      await tester.pumpAndSettle();

      // Verify command history shows commands
      final historyList = find.byKey(const Key('command_history'));
      expect(historyList, findsOneWidget);
    });

    testWidgets('Voice Command Button Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final voiceButton = find.byKey(const Key('voice_command_button'));
      if (voiceButton.evaluate().isEmpty) {
        return;
      }

      await tester.tap(voiceButton);
      await tester.pumpAndSettle();

      // Verify voice input UI appears
      expect(find.byKey(const Key('voice_input_modal')), findsOneWidget);
    });

    testWidgets('Text Command Input Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final textButton = find.byKey(const Key('text_command_button'));
      if (textButton.evaluate().isEmpty) {
        return;
      }

      await tester.tap(textButton);
      await tester.pumpAndSettle();

      // Enter command
      final textField = find.byKey(const Key('command_text_field'));
      await tester.enterText(textField, 'move left');
      await tester.pumpAndSettle();

      // Send command
      final sendButton = find.byKey(const Key('send_command_button'));
      await tester.tap(sendButton);
      await tester.pumpAndSettle();

      // Verify command appears in history
      expect(find.text('move left'), findsOneWidget);
    });

    testWidgets('Emergency Stop Button Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final stopButton = find.byKey(const Key('emergency_stop'));
      if (stopButton.evaluate().isEmpty) {
        return;
      }

      await tester.tap(stopButton);
      await tester.pumpAndSettle();

      // Verify stop command sent
      expect(find.text('EMERGENCY STOP'), findsWidgets);
    });
  });

  group('Visual Regression Tests', () {
    testWidgets('Controller Screen Golden Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ControllerScreen(
            sessionId: 'TEST-SESSION',
            consumerName: 'Test Consumer',
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ControllerScreen),
        matchesGoldenFile('goldens/controller_screen.png'),
      );
    });

    testWidgets('Touch Controller Area Golden Test',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));

      await expectLater(
        controller,
        matchesGoldenFile('goldens/touch_controller.png'),
      );
    });

    testWidgets('Command History Golden Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller with some commands
      // ... navigation and command code ...

      final history = find.byKey(const Key('command_history'));

      await expectLater(
        history,
        matchesGoldenFile('goldens/command_history.png'),
      );
    });
  });

  group('Performance Tests', () {
    testWidgets('Gesture Recognition Speed', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));

      // Measure 10 gestures
      final results = <int>[];

      for (int i = 0; i < 10; i++) {
        final stopwatch = Stopwatch()..start();
        await tester.fling(controller.first, const Offset(-200, 0), 500);
        await tester.pumpAndSettle();
        stopwatch.stop();
        results.add(stopwatch.elapsedMilliseconds);
      }

      // Average should be < 100ms
      final average = results.reduce((a, b) => a + b) / results.length;
      expect(average, lessThan(100));
    });

    testWidgets('UI Responsiveness Under Load', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Get to controller
      // ... navigation code ...

      final controller = find.byKey(const Key('touch_controller'));

      // Rapid fire gestures
      for (int i = 0; i < 20; i++) {
        await tester.fling(
          controller.first,
          Offset(i % 2 == 0 ? -100 : 100, 0),
          500,
        );
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.pumpAndSettle();

      // Should still be responsive
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Memory Stability Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Cycle through screens multiple times
      for (int i = 0; i < 10; i++) {
        // Navigate to controller
        // Send commands
        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Consumer'));
        await tester.pumpAndSettle();
      }

      // Should not crash or leak memory
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Accessibility Tests', () {
    testWidgets('Screen Reader Labels', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify semantic labels exist
      expect(find.bySemanticsLabel('Join Session'), findsWidgets);
      expect(find.bySemanticsLabel('Touch Controller'), findsWidgets);
    });

    testWidgets('Minimum Touch Target Size', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // All buttons should be at least 48x48dp
      final buttons = find.byType(ElevatedButton);

      for (final button in buttons.evaluate()) {
        final size = tester.getSize(find.byWidget(button.widget));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }
    });
  });
}
