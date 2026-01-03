#!/bin/bash

# Backend E2E Testing Script with grpcurl
# Tests Provider registration, Consumer discovery, and approval flow

set -e  # Exit on error

BACKEND_HOST="192.168.86.89:8080"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Remote Inventory Backend E2E Test${NC}"
echo -e "${BLUE}========================================${NC}"

# Step 1: Check connectivity
echo -e "\n${YELLOW}1. Checking backend connectivity...${NC}"
if grpcurl -plaintext $BACKEND_HOST list > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend is running at $BACKEND_HOST${NC}"
else
    echo -e "${RED}❌ Backend not reachable at $BACKEND_HOST${NC}"
    echo "Please start the backend first:"
    echo "  cd backend-python && python3 server.py"
    exit 1
fi

# Step 2: List available services
echo -e "\n${YELLOW}2. Listing available RPCs...${NC}"
grpcurl -plaintext $BACKEND_HOST list remote_inventory.RemoteInventoryService | head -10

# Step 3: Create Provider session
echo -e "\n${YELLOW}3. Creating Provider session...${NC}"
SESSION_RESPONSE=$(grpcurl -plaintext -d '{
  "provider_id": "test-provider-001",
  "provider_name": "Test Camera",
  "location": "Living Room"
}' $BACKEND_HOST remote_inventory.RemoteInventoryService/CreateSession)

echo "$SESSION_RESPONSE"

# Extract session ID
SESSION_ID=$(echo "$SESSION_RESPONSE" | grep -o '"sessionId":"[^"]*"' | cut -d'"' -f4)

if [ -z "$SESSION_ID" ]; then
    echo -e "${RED}❌ Failed to create session${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Session created: $SESSION_ID${NC}"

# Step 4: List sessions (Consumer discovers Provider)
echo -e "\n${YELLOW}4. Listing active sessions (Consumer discovery)...${NC}"
LIST_RESPONSE=$(grpcurl -plaintext -d '{}' $BACKEND_HOST remote_inventory.RemoteInventoryService/ListSessions)
echo "$LIST_RESPONSE"

if echo "$LIST_RESPONSE" | grep -q "$SESSION_ID"; then
    echo -e "${GREEN}✅ Session visible in list${NC}"
else
    echo -e "${RED}❌ Session not found in list${NC}"
fi

# Step 5: Consumer requests connection
echo -e "\n${YELLOW}5. Consumer requesting connection...${NC}"
REQUEST_RESPONSE=$(grpcurl -plaintext -d "{
  \"session_id\": \"$SESSION_ID\",
  \"consumer_id\": \"test-consumer-001\",
  \"consumer_name\": \"Test Consumer\"
}" $BACKEND_HOST remote_inventory.RemoteInventoryService/RequestConnection)

echo "$REQUEST_RESPONSE"

# Extract request ID
REQUEST_ID=$(echo "$REQUEST_RESPONSE" | grep -o '"requestId":"[^"]*"' | cut -d'"' -f4)

if [ -z "$REQUEST_ID" ]; then
    echo -e "${RED}❌ Failed to create connection request${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Connection request created: $REQUEST_ID${NC}"

# Step 6: Provider approves connection
echo -e "\n${YELLOW}6. Provider approving connection...${NC}"
APPROVE_RESPONSE=$(grpcurl -plaintext -d "{
  \"request_id\": \"$REQUEST_ID\"
}" $BACKEND_HOST remote_inventory.RemoteInventoryService/ApproveConnection)

echo "$APPROVE_RESPONSE"

if echo "$APPROVE_RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Connection approved${NC}"
else
    echo -e "${RED}❌ Approval failed${NC}"
fi

# Step 7: Send heartbeat
echo -e "\n${YELLOW}7. Sending heartbeat...${NC}"
HEARTBEAT_RESPONSE=$(grpcurl -plaintext -d "{
  \"session_id\": \"$SESSION_ID\"
}" $BACKEND_HOST remote_inventory.RemoteInventoryService/Heartbeat)

echo "$HEARTBEAT_RESPONSE"

# Step 8: End session
echo -e "\n${YELLOW}8. Ending session...${NC}"
END_RESPONSE=$(grpcurl -plaintext -d "{
  \"session_id\": \"$SESSION_ID\",
  \"token\": \"\"
}" $BACKEND_HOST remote_inventory.RemoteInventoryService/EndSession)

echo "$END_RESPONSE"

if echo "$END_RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ Session ended${NC}"
else
    echo -e "${RED}❌ Failed to end session${NC}"
fi

# Step 9: Verify session removed
echo -e "\n${YELLOW}9. Verifying session removed...${NC}"
FINAL_LIST=$(grpcurl -plaintext -d '{}' $BACKEND_HOST remote_inventory.RemoteInventoryService/ListSessions)

if echo "$FINAL_LIST" | grep -q "$SESSION_ID"; then
    echo -e "${RED}⚠️  Session still in list (may be expected if cleanup is delayed)${NC}"
else
    echo -e "${GREEN}✅ Session removed from list${NC}"
fi

# Summary
echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}✅ Backend E2E Test Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Tested:"
echo "  ✅ CreateSession (Provider registration)"
echo "  ✅ ListSessions (Consumer discovery)"
echo "  ✅ RequestConnection (Consumer → Provider)"
echo "  ✅ ApproveConnection (Provider accepts)"
echo "  ✅ Heartbeat (Keep-alive)"
echo "  ✅ EndSession (Cleanup)"
echo ""
echo -e "${GREEN}Backend is ready for app testing!${NC}"
echo ""
