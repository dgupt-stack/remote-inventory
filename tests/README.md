# E2E Testing Guide

## Overview

Comprehensive end-to-end tests for the JARVIS Remote Inventory Provider→Consumer flow.

## Test Suites

### 1. grpcurl E2E Test (Manual/Quick)

**File**: `e2e_grpcurl.sh`

**What it tests**:
- Backend connectivity
- Provider creates session
- Consumer discovers session
- Consumer requests connection
- Provider ends session
- Session cleanup

**Run**:
```bash
cd /Users/djgupt/Development/360/remote-inventory
./tests/e2e_grpcurl.sh
```

**Requirements**:
- Backend running on `localhost:8080`
- `grpcurl` installed
- `jq` installed (for JSON parsing)

---

### 2. Python E2E Test Suite (Automated/Comprehensive)

**File**: `e2e_python.py`

**What it tests** (9 tests):
1. Backend connectivity
2. Initial clean state
3. Provider creates session
4. Consumer discovers session
5. Consumer requests connection
6. Provider ends session
7. Session cleanup verification
8. Concurrent multiple sessions
9. Error handling

**Run**:
```bash
# Local backend
python3 tests/e2e_python.py

# Cloud Run backend
python3 tests/e2e_python.py --server jarvis-backend-XXX.run.app:443
```

**Requirements**:
- Backend running
- Python 3.12+
- grpcio, protobuf installed

---

## Before Running Tests

### 1. Start Backend

```bash
cd backend-python
nohup python3 server.py > server.log 2>&1 &
```

### 2. Verify Backend Running

```bash
lsof -i :8080
```

### 3. Monitor Logs (Optional)

```bash
tail -f backend-python/server.log
```

---

## Running Tests

### Quick Test (grpcurl)

```bash
./tests/e2e_grpcurl.sh
```

**Expected output**:
```
======================================
🧪 E2E Test: Provider-Consumer Flow
======================================

1️⃣  Checking backend...
✅ Backend running

2️⃣  Listing sessions (should be empty)...
Sessions found: 0

3️⃣  Provider creates session...
✅ Session created: session-1767411XXX

4️⃣  Consumer lists sessions...
Sessions found: 1
✅ Provider session visible to Consumer
   Provider: E2E Test Provider

5️⃣  Consumer requests connection...
✅ Connection requested: request-1767411XXX

6️⃣  Provider ends session...
✅ Session ended successfully

7️⃣  Verifying cleanup...
✅ Session cleaned up successfully

======================================
✅ E2E Test Complete!
======================================
```

### Comprehensive Test (Python)

```bash
python3 tests/e2e_python.py
```

**Expected output**:
```
============================================================
🚀 E2E Test Suite: Provider-Consumer Flow
============================================================
📡 Backend: localhost:8080

🧪 Test 1: Backend connectivity
✅ Backend accessible: PASS

🧪 Test 2: Initial state check
📝 Found 0 existing sessions
✅ Clean initial state: PASS

🧪 Test 3: Provider creates session
📝 Session ID: session-1767411XXX
✅ CreateSession success: PASS
✅ Token generated: PASS

🧪 Test 4: Consumer discovers session
✅ Session count after create: PASS
✅ Provider name: PASS
✅ Session ID match: PASS
✅ Accepting connections: PASS

🧪 Test 5: Consumer requests connection
📝 Request ID: request-1767411XXX
✅ RequestConnection success: PASS

🧪 Test 6: Provider ends session
✅ EndSession success: PASS

🧪 Test 7: Session cleanup verification
✅ Sessions after cleanup: PASS

🧪 Test 8: Concurrent sessions
✅ Concurrent sessions count: PASS

🧪 Test 9: Error handling
📝 EndSession on non-existent returned: false
✅ Error handling: PASS

============================================================
Results: 14/14 tests passed (100.0%)
✅ All E2E tests passed!
============================================================
```

---

## Testing with Flutter App

### Full E2E Flow

1. **Start Backend**:
   ```bash
   cd backend-python && python3 server.py
   ```

2. **Monitor Backend** (separate terminal):
   ```bash
   tail -f backend-python/server.log
   ```

3. **Phone 1 - Provider Mode**:
   - Open app → Select "Provider Mode"
   - Check logs → Should see "CreateSession" call
   - Note the session_id

4. **Phone 2 - Consumer Mode**:
   - Open app → Select "Consumer Mode"
   - Should see Phone 1's provider in list
   - Click on provider
   - Check logs → Should see "RequestConnection"

5. **Phone 1 - Exit Provider**:
   - Go back / exit Provider mode
   - Check logs → Should see "EndSession"

6. **Phone 2 - Refresh**:
   - Provider should disappear from list

---

## Automated CI/CD Integration

### Add to GitHub Actions

```yaml
name: E2E Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.12'
      
      - name: Install dependencies
        run: |
          pip install grpcio protobuf
      
      - name: Start backend
        run: |
          cd backend-python
          python3 server.py &
          sleep 2
      
      - name: Run E2E tests
        run: python3 tests/e2e_python.py
```

---

## Troubleshooting

### Backend not running
```
❌ Backend not running on port 8080
```

**Fix**:
```bash
cd backend-python
python3 server.py
```

### Connection refused
```
❌ Failed to connect to backend
```

**Check**:
1. Backend is running: `lsof -i :8080`
2. Firewall not blocking port 8080
3. Correct IP/port in test

### jq not found (grpcurl test)
```
jq: command not found
```

**Fix**:
```bash
brew install jq
```

### Module not found (Python test)
```
ModuleNotFoundError: No module named 'grpc'
```

**Fix**:
```bash
pip install grpcio protobuf
```

---

## Test Coverage

| Component | Tested |
|-----------|--------|
| Backend connectivity | ✅ |
| CreateSession RPC | ✅ |
| ListSessions RPC | ✅ |
| RequestConnection RPC | ✅ |
| EndSession RPC | ✅ |
| Session persistence | ✅ |
| Session cleanup | ✅ |
| Concurrent sessions | ✅ |
| Error handling | ✅ |
| Provider→Backend integration | ✅ (via Flutter app) |
| Consumer discovery | ✅ (via Flutter app) |

---

## Next Steps

1. **Manual Phone Testing**:
   - Test Provider creates session
   - Test Consumer sees session
   - Test end-to-end flow

2. **Add Flutter Integration Tests**:
   ```bash
   cd consumer_app
   flutter test integration_test/app_test.dart
   ```

3. **Performance Testing**:
   - Test with 10+ concurrent providers
   - Measure ListSessions latency
   - Test connection request throughput

4. **Load Testing**:
   - Simulate 100 providers
   - Measure backend memory usage
   - Test session cleanup under load
