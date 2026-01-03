#!/bin/bash
# E2E Test: Full Provider-Consumer Flow (grpcurl)

SERVER="localhost:8080"
PROTO="proto/inventory_service.proto"
SERVICE="inventory.RemoteInventoryService"

echo "======================================"
echo "🧪 E2E Test: Provider-Consumer Flow"
echo "======================================"

# Step 1: Verify backend is running
echo -e "\n1️⃣  Checking backend..."
if ! lsof -i :8080 > /dev/null 2>&1; then
  echo "❌ Backend not running on port 8080"
  echo "   Start with: cd backend-python && python3 server.py"
  exit 1
fi
echo "✅ Backend running"

#Step 2: Initial state - no sessions
echo -e "\n2️⃣  Listing sessions (should be empty)..."
SESSIONS=$(grpcurl -plaintext -import-path proto -proto $PROTO \
  -d '{"search_query":""}' \
  $SERVER $SERVICE/ListSessions 2>&1)

if echo "$SESSIONS" | grep -q "error"; then
  echo "❌ Failed to connect to backend"
  echo "$SESSIONS"
  exit 1
fi

SESSION_COUNT=$(echo "$SESSIONS" | jq -r '.sessions | length' 2>/dev/null || echo "0")
echo "Sessions found: $SESSION_COUNT"

# Step 3: Provider creates session
echo -e "\n3️⃣  Provider creates session..."
CREATE_RESPONSE=$(grpcurl -plaintext -import-path proto -proto $PROTO \
  -d '{"provider_name":"E2E Test Provider","provider_id":"e2e-test-1"}' \
  $SERVER $SERVICE/CreateSession 2>&1)

if echo "$CREATE_RESPONSE" | grep -q "error"; then
  echo "❌ Failed to create session"
  echo "$CREATE_RESPONSE"
  exit 1
fi

SESSION_ID=$(echo "$CREATE_RESPONSE" | jq -r '.sessionId' 2>/dev/null)
echo "✅ Session created: $SESSION_ID"

# Step 4: Consumer lists sessions (should see 1)
echo -e "\n4️⃣  Consumer lists sessions..."
sleep 0.5
SESSIONS=$(grpcurl -plaintext -import-path proto -proto $PROTO \
  -d '{"search_query":""}' \
  $SERVER $SERVICE/ListSessions 2>&1)

SESSION_COUNT=$(echo "$SESSIONS" | jq -r '.sessions | length' 2>/dev/null || echo "0")
echo "Sessions found: $SESSION_COUNT"

if [ "$SESSION_COUNT" == "1" ]; then
  echo "✅ Provider session visible to Consumer"
  PROVIDER_NAME=$(echo "$SESSIONS" | jq -r '.sessions[0].providerName' 2>/dev/null)
  echo "   Provider: $PROVIDER_NAME"
else
  echo "❌ Expected 1 session, found $SESSION_COUNT"
  # Don't exit - continue cleanup
fi

# Step 5: Consumer requests connection
echo -e "\n5️⃣  Consumer requests connection..."
CONNECTION=$(grpcurl -plaintext -import-path proto -proto $PROTO \
  -d "{\"session_id\":\"$SESSION_ID\",\"consumer_id\":\"e2e-consumer\",\"consumer_name\":\"E2E Test Consumer\"}" \
  $SERVER $SERVICE/RequestConnection 2>&1)

if echo "$CONNECTION" | grep -q "error"; then
  echo "⚠️  RequestConnection failed: $CONNECTION"
else
  REQUEST_ID=$(echo "$CONNECTION" | jq -r '.requestId' 2>/dev/null)
  echo "✅ Connection requested: $REQUEST_ID"
fi

# Step 6: Provider ends session
echo -e "\n6️⃣  Provider ends session..."
END_RESULT=$(grpcurl -plaintext -import-path proto -proto $PROTO \
  -d "{\"session_id\":\"$SESSION_ID\"}" \
  $SERVER $SERVICE/EndSession 2>&1 | jq -r '.success' 2>/dev/null)

if [ "$END_RESULT" == "true" ]; then
  echo "✅ Session ended successfully"
else
  echo "⚠️  EndSession returned: $END_RESULT"
fi

# Step 7: Verify cleanup
echo -e "\n7️⃣  Verifying cleanup..."
sleep 0.5
FINAL_SESSIONS=$(grpcurl -plaintext -import-path proto -proto $PROTO \
  -d '{"search_query":""}' \
  $SERVER $SERVICE/ListSessions 2>&1 | jq -r '.sessions | length' 2>/dev/null || echo "0")

if [ "$FINAL_SESSIONS" == "0" ]; then
  echo "✅ Session cleaned up successfully"
else
  echo "⚠️  Expected 0 sessions after cleanup, found $FINAL_SESSIONS"
fi

echo -e "\n======================================"
echo "✅ E2E Test Complete!"
echo "======================================"
echo ""
echo "💡 Tip: Watch backend logs while testing:"
echo "   tail -f backend-python/server.log"
