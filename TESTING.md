# Testing Guide

This guide explains how to test the Remote Inventory View App.

## Quick Test

Run all tests at once:
```bash
./test-all.sh
```

This will:
- ✅ Build backend
- ✅ Test HTTP API endpoints
- ✅ Run Provider app tests
- ✅ Run Consumer app tests
- ✅ Check code formatting

---

## Individual Test Suites

### 1. Backend API Tests

Test session management endpoints:
```bash
cd backend
./test-session.sh
```

Tests:
- Session creation
- Session joining
- Heartbeat
- Invalid session handling
- Session termination

**Note**: Backend must be running on `localhost:8081`

### 2. Backend Build Test

Verify backend compiles:
```bash
cd backend
./test.sh
```

### 3. Provider App Tests

```bash
cd provider_app
flutter test
```

### 4. Consumer App Tests

```bash
cd consumer_app
flutter test
```

---

## Manual Testing

### Test Session Flow

1. **Start Backend**:
   ```bash
   cd backend
   make run
   ```

2. **Open Web Demo**:
   ```bash
   open web-demo/index.html
   ```

3. **Test Operations**:
   - Create session
   - Join session
   - Send heartbeat
   - End session

### Test Flutter Apps

1. **Run Provider App**:
   ```bash
   cd provider_app
   flutter run
   ```

2. **Run Consumer App** (separate terminal):
   ```bash
   cd consumer_app
   flutter run
   ```

3. **Test Flow**:
   - Provider creates session
   - Consumer joins with session ID
   - Test touch gestures (swipe, pinch, long-press, double-tap)
   - Test voice commands
   - Test text commands
   - End session

---

## Privacy Testing (CRITICAL)

⚠️  **Privacy must be verified before production use**

### Manual Privacy Verification

1. Start backend with real camera
2. Have a person in front of camera
3. Verify face is ALWAYS blurred
4. Test various angles and distances
5. Test with multiple people
6. Test in poor lighting
7. Verify blur is not reversible

**NEVER deploy if faces are visible**

---

## Performance Testing

### Measure Latency

1. Start Provider app
2. Start Consumer app
3. Measure time from Provider camera to Consumer display
4. Expected: 200-300ms

### Frame Rate

Monitor FPS in Consumer app:
- Expected: 20-30 FPS
- Minimum acceptable: 15 FPS

### Load Testing

Test multiple concurrent sessions:
```bash
cd backend
# Start server
make run

# In another terminal
for i in {1..5}; do
  curl -X POST http://localhost:8081/v1/sessions \
    -H "Content-Type: application/json" \
    -d "{\"provider_id\":\"test-$i\",\"provider_name\":\"Load Test $i\"}" &
done
```

---

## Test Checklist

Before marking testing as complete:

### Functionality
- [ ] Sessions create successfully
- [ ] Consumers can join sessions
- [ ] Heartbeats keep sessions alive
- [ ] Sessions end properly
- [ ] Touch gestures work (swipe, pinch, long-press, double-tap)
- [ ] Voice commands work
- [ ] Text commands work
- [ ] Provider receives all commands
- [ ] Laser pointer displays correctly
- [ ] Stop command works immediately

### Privacy
- [ ] Faces ALWAYS blurred
- [ ] Bodies/skin ALWAYS blurred
- [ ] Fallback to full-frame blur works
- [ ] No identifiable features visible
- [ ] Tested with real person in various conditions

### Performance
- [ ] Latency < 300ms
- [ ] Frame rate > 15 FPS
- [ ] No memory leaks after 30min session
- [ ] Backend handles 5+ concurrent sessions
- [ ] Graceful degradation on poor network

### User Experience
- [ ] UI responsive and smooth
- [ ] Haptic feedback works
- [ ] Visual feedback clear
- [ ] Error messages helpful
- [ ] Session flow intuitive

---

## Continuous Testing

### Pre-commit Tests

Run before committing:
```bash
./test-all.sh
```

### Pre-deployment Tests

Before deploying to Cloud Run:
```bash
# Build backend
cd backend
./test.sh

# Test API
./test-session.sh

# Test Flutter apps
cd ../provider_app && flutter test
cd ../consumer_app && flutter test
```

---

## Troubleshooting

### "Backend not running"
```bash
cd backend
make run
```

### "Tests fail"
Check logs:
```bash
cd backend
cat logs/server.log
```

### Flutter tests fail
```bash
cd provider_app  # or consumer_app
flutter pub get
flutter test --verbose
```

---

## Adding New Tests

### Backend Tests

Add to `backend/test-session.sh`:
```bash
# Test 7: Your new test
echo "7️⃣ Testing new feature..."
# Add test logic
```

### Flutter Tests

Add to `provider_app/test/` or `consumer_app/test/`:
```dart
test('should do something', () {
  // Test code
});
```

---

## See Also

- [Testing Plan](/.gemini/antigravity/brain/.../testing_plan.md) - Comprehensive test plan
- [backend/README.md](backend/README.md) - Backend testing details
- [DEPLOYMENT.md](DEPLOYMENT.md) - Production testing checklist
