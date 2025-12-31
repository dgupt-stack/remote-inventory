# E2E Testing Guide

This guide covers end-to-end testing for the Remote Inventory View App.

## Test Categories

### 1. Backend API Tests (`test-e2e.sh`)

Automated tests for the complete session lifecycle:

```bash
./test-e2e.sh
```

**What it tests**:
- ✅ Backend availability
- ✅ Provider session creation
- ✅ Consumer joining session
- ✅ Heartbeat mechanism
- ✅ Invalid token rejection
- ✅ Session isolation
- ✅ Concurrent sessions (5 simultaneous)
- ✅ Session cleanup
- ✅ Session unavailability after end

**Requirements**:
- Backend running on `localhost:8081`
- `curl` installed

---

### 2. Privacy Layer Tests (`test-privacy-e2e.sh`)

Manual verification procedures for privacy:

```bash
./test-privacy-e2e.sh
```

**What it tests**:
- Face detection and blurring
- Distance-based graduated blur
- Full-frame fallback
- Processing latency
- Stress scenarios

**Critical**: Face must NEVER be visible in output

---

### 3. Provider App Integration Tests

Flutter integration tests for Provider UI and workflow:

```bash
cd provider_app
flutter test integration_test/app_test.dart
```

**What it tests**:
- Complete provider workflow
- JARVIS UI components
- Camera initialization
- Zoom controls
- Session management
- UI responsiveness (< 1s transitions)

---

### 4. Consumer App Integration Tests

Flutter integration tests for Consumer controls:

```bash
cd consumer_app
flutter test integration_test/app_test.dart
```

**What it tests**:
- Session joining flow
- Touch gesture recognition (swipe, tap, long-press)
- Voice command interface
- Text command input
- Command history
- Gesture response time (< 100ms)

---

## Running All E2E Tests

### Automated Tests

```bash
# 1. Start backend
cd backend && make run &

# 2. Run backend API tests
./test-e2e.sh

# 3. Run Provider integration tests
cd provider_app && flutter test integration_test/

# 4. Run Consumer integration tests
cd consumer_app && flutter test integration_test/
```

### Manual Tests

```bash
# Privacy verification
./test-privacy-e2e.sh

# Follow the manual steps for:
# - Face detection verification
# - Distance blur testing
# - Performance measurement
```

---

## Test Requirements

### For Backend Tests
- Backend server running
- `curl` command available
- `grep` command available

### For Flutter Tests
- Flutter SDK installed
- `integration_test` package added
- Physical device or emulator
- Camera permissions granted

---

## Adding E2E Tests to CI/CD

### GitHub Actions Example

```yaml
name: E2E Tests

on: [push, pull_request]

jobs:
  backend-e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Start Backend
        run: cd backend && make run &
      - name: Wait for Backend
        run: sleep 5
      - name: Run E2E Tests
        run: ./test-e2e.sh

  flutter-e2e:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - name: Run Provider Tests
        run: cd provider_app && flutter test integration_test/
      - name: Run Consumer Tests
        run: cd consumer_app && flutter test integration_test/
```

---

## E2E Test Checklist

Before considering E2E testing complete:

**Backend**:
- [ ] All API endpoints tested
- [ ] Session lifecycle verified
- [ ] Concurrent sessions work
- [ ] Token validation works
- [ ] Error handling tested

**Privacy**:
- [ ] Faces always blurred
- [ ] Distance blur works
- [ ] Performance acceptable
- [ ] Tested with real person
- [ ] Tested various lighting

**Provider App**:
- [ ] Session creation works
- [ ] Camera initializes
- [ ] UI renders correctly
- [ ] Zoom controls work
- [ ] Can end session

**Consumer App**:
- [ ] Can join session
- [ ] All gestures recognized
- [ ] Voice commands work
- [ ] Text commands work
- [ ] Stop command works

**Integration**:
- [ ] Provider-Consumer communication
- [ ] Commands reach Provider
- [ ] Video stream flows
- [ ] Latency acceptable
- [ ] Tested on real devices

---

## Troubleshooting

### Backend tests fail
```bash
# Check if backend is running
curl http://localhost:8081

# Check backend logs
cd backend && tail -f logs/server.log
```

### Flutter tests timeout
```bash
# Increase timeout in test
testWidgets('...', (tester) async {
  // ...
}, timeout: const Timeout(Duration(minutes: 5)));
```

### Integration tests can't find keys
```bash
# Make sure widgets have keys:
Container(
  key: const Key('my_widget'),
  // ...
)
```

---

## Performance Benchmarks

Expected performance from E2E tests:

| Metric | Target | Measured |
|--------|--------|----------|
| API Response | < 100ms | - |
| Session Creation | < 200ms | - |
| UI Transition | < 1000ms | - |
| Gesture Recognition | < 100ms | - |
| Frame Processing | < 300ms | - |
| Privacy Blur | < 350ms | - |

Run tests and update this table with actual measurements.

---

## Future Enhancements

Planned E2E test improvements:

1. **Automated Privacy Testing**:
   - ML-based face detection in output
   - Automated blur verification
   - Dataset of test faces

2. **Load Testing**:
   - 100+ concurrent sessions
   - Sustained streaming
   - Memory leak detection

3. **Network Testing**:
   - Variable latency simulation
   - Packet loss scenarios
   - Bandwidth throttling

4. **Visual Regression**:
   - Screenshot comparison
   - UI consistency check
   - Responsive design testing

5. **Cross-Platform**:
   - iOS device testing
   - Android device testing
   - Different screen sizes
