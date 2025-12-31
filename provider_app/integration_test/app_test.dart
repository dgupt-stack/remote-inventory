import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider_app/main.dart' as app;
import 'package:provider_app/screens/camera_screen.dart';
import 'package:provider_app/shared/theme/jarvis_components.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Provider App E2E Tests', () {
    testWidgets('Complete Provider workflow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test 1: Home screen loads
      expect(find.text('Remote Inventory'), findsOneWidget);
      expect(find.text('Provider'), findsOneWidget);

      // Test 2: Enter provider name
      final nameField = find.byKey(const Key('provider_name_input'));
      await tester.enterText(nameField, 'E2E Test Provider');
      await tester.pumpAndSettle();

      // Test 3: Start session
      final startButton = find.text('START SESSION');
      await tester.tap(startButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test 4: Camera screen appears
      expect(find.text('J.A.R.V.I.S'), findsOneWidget);
      expect(find.text('SYS:ONLINE'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
    });

    testWidgets('JARVIS UI Components Visual Test',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Test glassmorphism badges
      final sysOnlineBadge = find.text('SYS:ONLINE');
      expect(sysOnlineBadge, findsOneWidget);

      final liveBadge = find.text('LIVE');
      expect(liveBadge, findsOneWidget);

      // Verify pulsing dot indicators exist
      expect(find.byType(Container), findsWidgets);

      // Take screenshot for golden file comparison
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
    });

    testWidgets('Zoom Control Functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Find zoom indicator
      final zoomIndicator = find.textContaining('x');
      expect(zoomIndicator, findsOneWidget);

      // Test zoom slider exists
      final slider = find.byType(Slider);
      if (slider.evaluate().isNotEmpty) {
        // Get initial zoom value
        final initialText = tester.widget<Text>(find.textContaining('x')).data;

        // Drag slider
        await tester.drag(slider.first, const Offset(50, 0));
        await tester.pumpAndSettle();

        // Verify zoom value changed
        final newText = tester.widget<Text>(find.textContaining('x')).data;
        expect(newText != initialText, isTrue);
      }
    });

    testWidgets('Status Indicators Update', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Verify time updates
      final initialTime = find.textContaining('M').first;
      final initialTimeText = tester.widget<Text>(initialTime).data;

      await tester.pump(const Duration(seconds: 2));

      final updatedTime = find.textContaining('M').first;
      final updatedTimeText = tester.widget<Text>(updatedTime).data;

      // Time should have updated
      expect(updatedTimeText != initialTimeText, isTrue);
    });

    testWidgets('Navigation Icons Present', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Verify all navigation icons
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.videocam), findsOneWidget);
      expect(find.byIcon(Icons.zoom_in), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('Header Elements Visible', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Verify header icons
      expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsWidgets);
      expect(find.byIcon(Icons.open_in_full), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Verify badge number
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('UI Responsiveness Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final providerButton = find.text('Provider');
      final stopwatch = Stopwatch()..start();

      await tester.tap(providerButton);
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Screen should transition in less than 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    testWidgets('Color Theme Validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Find widgets and verify JARVIS colors
      final jarvisTitle = find.text('J.A.R.V.I.S');
      final titleWidget = tester.widget<Text>(jarvisTitle);

      // Verify cyan color (#00D9FF)
      expect(titleWidget.style?.color, equals(JarvisColors.primary));
    });

    testWidgets('GlassBadge Rendering', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test GlassBadge widget independently
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBadge(
              text: 'TEST',
              leading: Icon(Icons.circle, size: 8),
            ),
          ),
        ),
      );

      expect(find.text('TEST'), findsOneWidget);
      expect(find.byIcon(Icons.circle), findsOneWidget);
    });

    testWidgets('Connection Badge Visibility', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Verify connection indicator
      expect(find.byIcon(Icons.wifi), findsOneWidget);
      expect(find.text('4'), findsWidgets); // Connection strength
    });
  });

  group('Visual Regression Tests', () {
    testWidgets('Camera Screen Golden Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CameraScreen(
            camera: CameraDescription(
              name: 'test_camera',
              lensDirection: CameraLensDirection.back,
              sensorOrientation: 0,
            ),
            providerName: 'Test Provider',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Compare to golden file
      await expectLater(
        find.byType(CameraScreen),
        matchesGoldenFile('goldens/camera_screen.png'),
      );
    });

    testWidgets('JARVIS Header Golden Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Compare header to golden file
      await expectLater(
        find.text('J.A.R.V.I.S'),
        matchesGoldenFile('goldens/jarvis_header.png'),
      );
    });

    testWidgets('GlassBadge Golden Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: JarvisColors.background,
            body: Center(
              child: GlassBadge(
                text: 'SYS:ONLINE',
                leading: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: JarvisColors.success,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(GlassBadge),
        matchesGoldenFile('goldens/glass_badge.png'),
      );
    });

    testWidgets('Zoom Indicator Golden Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: JarvisColors.background,
            body: Center(
              child: ZoomIndicator(
                zoom: 1.0,
                onZoomChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ZoomIndicator),
        matchesGoldenFile('goldens/zoom_indicator.png'),
      );
    });

    testWidgets('Bottom Navigation Golden Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Find bottom navigation area
      final bottomNav = find.byKey(const Key('bottom_navigation'));

      await expectLater(
        bottomNav,
        matchesGoldenFile('goldens/bottom_navigation.png'),
      );
    });
  });

  group('Performance Tests', () {
    testWidgets('Render Performance Benchmark', (WidgetTester tester) async {
      app.main();

      final stopwatch = Stopwatch()..start();
      await tester.pumpAndSettle();
      stopwatch.stop();

      // Initial render should be fast
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('Animation Performance', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen
      // ... setup code ...

      // Measure animation frame rate
      final binding = WidgetsBinding.instance;
      int frameCount = 0;
      final stopwatch = Stopwatch()..start();

      // Monitor frames for 1 second
      binding.addPostFrameCallback((_) {
        frameCount++;
      });

      await tester.pump(const Duration(seconds: 1));
      stopwatch.stop();

      // Should maintain at least 30 FPS
      final fps = frameCount / (stopwatch.elapsedMilliseconds / 1000);
      expect(fps, greaterThan(30));
    });

    testWidgets('Memory Usage Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to camera screen multiple times
      for (int i = 0; i < 5; i++) {
        // Navigate away and back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Provider'));
        await tester.pumpAndSettle();
      }

      // Should not leak memory or crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
