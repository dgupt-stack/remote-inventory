# Cloud Spanner Setup for Remote Inventory

##  Overview

This project uses Cloud Spanner (local emulator) for persistent storage of users, devices, sessions, and WebRTC signaling data.

---

## ✅ What's Already Done

1. **Schema Created**: `backend-python/db/schema.sql`
   - `users` table
   - `devices` table  
   - `sessions` table
   - `webrtc_signals` table

2. **Scripts Created**:
   - `scripts/setup_spanner.sh` - Start Docker emulator
   - `scripts/create_spanner_db.sh` - Create database
   - `backend-python/test_spanner.py` - Test connection

3. **Dependencies**:
   - ✅ `google-cloud-spanner==3.49.1` added to requirements.txt
   - ✅ Installed via pip

---

## 🚀 Manual Setup (Current Status)

Since automated setup is having issues, here's the manual approach:

### Step 1: Start Spanner Emulator (Docker)

```bash
# Start emulator
docker run -d -p 9010:9010 \
  --name spanner-emulator \
  gcr.io/cloud-spanner-emulator/emulator:latest

# Verify it's running
docker ps | grep spanner
```

### Step 2: Set Environment Variable

```bash
# Add to ~/.zshrc or run in every terminal
export SPANNER_EMULATOR_HOST="localhost:9010"
```

### Step 3: Create Instance & Database

Use `gcloud` with emulator:

```bash
# Create instance
gcloud spanner instances create remote-inventory-local \
  --project=test-project \
  --config=emulator-config \
  --description="Local dev instance" \
  --nodes=1

# Create database with schema
gcloud spanner databases create remote-inventory \
  --project=test-project \
  --instance=remote-inventory-local \
  --ddl-file=backend-python/db/schema.sql
```

### Step 4: Test Connection

```bash
cd backend-python
python3 test_spanner.py
```

**Expected Output:**
```
✅ Connected to Spanner emulator
📋 Tables in database:
   ✓ users
   ✓ devices
   ✓ sessions
   ✓ webrtc_signals
👤 Creating test user...
✅ Test user created
```

---

## 🔧 Troubleshooting

### Issue: "Instance not found"

**Cause**: Database not created or gcloud not using emulator

**Fix**:
```bash
# Ensure env var is set
export SPANNER_EMULATOR_HOST="localhost:9010"

# List instances (should show remote-inventory-local)
gcloud spanner instances list --project=test-project
```

### Issue: "ERROR: gcloud components"

**Cause**: gcloud doesn't have spanner-emulator component

**Fix**: Use Docker approach above (simpler)

### Issue: Docker not running

**Fix**:
```bash
# Start Docker Desktop
open -a Docker

# Wait for it to start, then run docker commands
```

---

## 📊 Useful Commands

```bash
# List tables
gcloud spanner databases execute-sql remote-inventory \
  --instance=remote-inventory-local \
  --project=test-project \
  --sql="SELECT table_name FROM information_schema.tables WHERE table_schema = ''"

# Query users
gcloud spanner databases execute-sql remote-inventory \
  --instance=remote-inventory-local \
  --project=test-project \
  --sql="SELECT * FROM users"

# Stop emulator
docker stop spanner-emulator

# Start emulator
docker start spanner-emulator

# Remove emulator
docker rm -f spanner-emulator
```

---

## ⏭️  Next Steps

Once Spanner is working:

1. **Create Python Spanner Client** (`backend-python/db/spanner_client.py`)
2. **Update Proto** (add user/device RPCs)
3. **Implement Backend RPCs** (user registration, device linking)
4. **Flutter Integration** (user signup, device_id generation)

---

## 💡 Alternative: Skip Spanner for Now

If Spanner setup is blocking progress, we can:

1. **Use in-memory dict** (current approach) for initial WebRTC testing
2. **Add Spanner later** once WebRTC video is working

This keeps momentum while we debug Spanner setup issues.

**Recommendation**: Let's get WebRTC working first with in-memory storage, then add Spanner persistence as v2.
