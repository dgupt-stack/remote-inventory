#!/bin/bash
# JARVIS Backend - grpcurl Test Commands
# Quick reference for testing all RPCs

echo "======================================"
echo "🎯 JARVIS Backend grpcurl Commands"
echo "======================================"
echo ""

# Setup
SERVER="localhost:8080"
PROTO_PATH="proto/inventory_service.proto"
IMPORT_PATH="proto"
SERVICE="inventory.RemoteInventoryService"

echo "Server: $SERVER"
echo "Proto: $PROTO_PATH"
echo ""

# Test 1: ListSessions
echo "1️⃣  ListSessions (empty)"
echo "Command:"
echo "  grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \\"
echo "    -d '{\"search_query\":\"\"}' \\"
echo "    $SERVER $SERVICE/ListSessions"
echo ""

grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \
  -d '{"search_query":""}' \
  $SERVER $SERVICE/ListSessions

echo ""
echo "======================================"

# Test 2: CreateSession
echo "2️⃣  CreateSession"
echo "Command:"
echo "  grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \\"
echo "    -d '{\"provider_name\":\"CLI Test Phone\",\"provider_id\":\"cli-001\"}' \\"
echo "    $SERVER $SERVICE/CreateSession"
echo ""

SESSION_RESPONSE=$(grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \
  -d '{"provider_name":"CLI Test Phone","provider_id":"cli-001"}' \
  $SERVER $SERVICE/CreateSession)

echo "$SESSION_RESPONSE"

# Extract session_id (basic parsing)
SESSION_ID=$(echo "$SESSION_RESPONSE" | grep -o 'session-[0-9]*' | head -1)
echo ""
echo "📝 Saved session_id: $SESSION_ID"
echo ""
echo "======================================"

# Test 3: ListSessions again
echo "3️⃣  ListSessions (should have sessions)"
echo ""

grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \
  -d '{"search_query":""}' \
  $SERVER $SERVICE/ListSessions

echo ""
echo "======================================"

# Test 4: RequestConnection (if session_id was captured)
if [ ! -z "$SESSION_ID" ]; then
  echo "4️⃣  RequestConnection"
  echo "Command:"
  echo "  grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \\"
  echo "    -d '{\"session_id\":\"$SESSION_ID\",\"consumer_id\":\"cli-c1\",\"consumer_name\":\"CLI Consumer\"}' \\"
  echo "    $SERVER $SERVICE/RequestConnection"
  echo ""

  grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \
    -d "{\"session_id\":\"$SESSION_ID\",\"consumer_id\":\"cli-c1\",\"consumer_name\":\"CLI Consumer\"}" \
    $SERVER $SERVICE/RequestConnection

  echo ""
  echo "======================================"

  # Test 5: EndSession
  echo "5️⃣  EndSession"
  echo "Command:"
  echo "  grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \\"
  echo "    -d '{\"session_id\":\"$SESSION_ID\"}' \\"
  echo "    $SERVER $SERVICE/EndSession"
  echo ""

  grpcurl -plaintext -import-path $IMPORT_PATH -proto $PROTO_PATH \
    -d "{\"session_id\":\"$SESSION_ID\"}" \
    $SERVER $SERVICE/EndSession

  echo ""
  echo "======================================"
fi

echo ""
echo "✅ All tests complete!"
echo ""
echo "💡 Tip: Watch backend logs in another terminal:"
echo "   tail -f backend-python/server.log"
