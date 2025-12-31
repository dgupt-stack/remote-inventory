# Visual Regression Testing Guide

## Overview

Visual regression testing compares screenshots of your UI against "golden" reference images to catch unintended visual changes.

## How It Works

```dart
testWidgets('Screen matches golden file', (tester) async {
  await tester.pumpWidget(MyWidget());
  
  // Compare to saved reference image
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('goldens/my_widget.png'),
  );
});
```

## Setting Up Golden Files

### 1. Generate Initial Golden Files

```bash
cd provider_app
flutter test --update-goldens integration_test/
```

This creates reference images in `integration_test/goldens/`

### 2. File Structure

```
provider_app/
├── integration_test/
│   ├── app_test.dart
│   └── goldens/
│       ├── camera_screen.png
│       ├── jarvis_header.png
│       ├── glass_badge.png
│       ├── zoom_indicator.png
│       └── bottom_navigation.png
```

### 3. Running Visual Tests

```bash
# Run tests and compare to golden files
flutter test integration_test/

# If visuals match: PASS ✓
# If visuals differ: FAIL ✗ (shows diff)
```

## Golden Files Created

### Provider App
- `camera_screen.png` - Full camera screen layout
- `jarvis_header.png` - Header with J.A.R.V.I.S title
- `glass_badge.png` - Glassmorphism badge component
- `zoom_indicator.png` - Zoom control slider
- `bottom_navigation.png` - Bottom icon navigation

### Consumer App
- `controller_screen.png` - Full controller layout
- `touch_controller.png` - Touch gesture area
- `command_history.png` - Command history list

## When Tests Fail

### Visual Diff Example

```
Golden file mismatch!
Expected: goldens/camera_screen.png
Actual:   failures/camera_screen_masterImage.png
Diff:     failures/camera_screen_diff.png
```

### Interpreting Failures

**legitimate change** → Update golden:
```bash
flutter test --update-goldens
```

**Unexpected change** → Fix the code

## Best Practices

### 1. Test Individual Components

```dart
testWidgets('GlassBadge Golden Test', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: GlassBadge(text: 'TEST'),
      ),
    ),
  );
  
  await expectLater(
    find.byType(GlassBadge),
    matchesGoldenFile('goldens/glass_badge.png'),
  );
});
```

### 2. Use Consistent Test Data

```dart
// Always use same data for consistency
const testData = {
  'name': 'Test User',
  'time': '12:00:00 PM',
  'zoom': 1.0,
};
```

### 3. Handle Animations

```dart
// Wait for animations to complete
await tester.pumpAndSettle();

// Or disable animations
binding.disableAnimations();
```

## Platform Considerations

### Different Platforms = Different Pixels

Golden files are platform-specific:

```
goldens/
├── camera_screen_android.png
├── camera_screen_ios.png
└── camera_screen_macos.png
```

### Platform-Specific Tests

```dart
testWidgets('Camera Screen', (tester) async {
  // ...
  
  final platform = Theme.of(context).platform;
  await expectLater(
    find.byType(CameraScreen),
    matchesGoldenFile('goldens/camera_screen_$platform.png'),
  );
});
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Visual Regression Tests

on: [push, pull_request]

jobs:
  golden-tests:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      
      - name: Run Golden Tests
        run: |
          cd provider_app
          flutter test integration_test/
          
      - name: Upload Failures
        if: failure()
        uses: actions/upload-artifact@v2
        with:
          name: golden-failures
          path: provider_app/integration_test/failures/
```

## Troubleshooting

### Fonts Not Matching

```dart
testWidgets('...', (tester) async {
  // Load custom fonts
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Orbitron',
      ),
      home: MyWidget(),
    ),
  );
});
```

### Colors Off

Ensure consistent background:

```dart
await tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      backgroundColor: JarvisColors.background,
      body: MyWidget(),
    ),
  ),
);
```

### Size Mismatches

Set explicit size:

```dart
await tester.pumpWidget(
  MaterialApp(
    home: SizedBox(
      width: 375,  // iPhone size
      height: 812,
      child: MyWidget(),
    ),
  ),
);
```

## Advanced: Threshold Tolerance

Allow minor pixel differences:

```dart
await expectLater(
  find.byType(MyWidget),
  matchesGoldenFile(
    'goldens/my_widget.png',
    // Allow 0.1% pixel difference
    threshold: 0.001,
  ),
);
```

## Maintenance

### Regular Updates

Update goldens when intentionally changing UI:

```bash
# After approved design change
flutter test --update-goldens integration_test/

# Commit updated golden files
git add integration_test/goldens/
git commit -m "Update golden files for new design"
```

### Review Process

1. Design change approved
2. Update goldens locally
3. Verify changes in PR review
4. Merge with updated goldens

## Example Test Output

```
Running visual regression tests...

✓ Camera Screen Golden Test (500ms)
✓ JARVIS Header Golden Test (300ms)
✓ GlassBadge Golden Test (200ms)
✓ Zoom Indicator Golden Test (250ms)
✗ Bottom Navigation Golden Test (400ms)
  
  Pixel diff: 2.3% (threshold: 0.1%)
  See: integration_test/failures/bottom_navigation_diff.png

4/5 tests passed
1 test failed
```

## Benefits

✅ **Catches unintended visual changes**  
✅ **Validates responsive design**  
✅ **Ensures cross-platform consistency**  
✅ **Automated UI regression prevention**  
✅ **Perfect for JARVIS theme color/glow validation**  

## Files to Commit

```bash
git add integration_test/goldens/
git commit -m "Add visual regression golden files"
```

**Important**: Golden files should be committed to git for CI/CD comparison.
