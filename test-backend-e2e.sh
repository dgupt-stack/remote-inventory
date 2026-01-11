#!/bin/bash

# Backend E2E Test Script
# Tests the Cloud Run gRPC backend end-to-end

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKEND_HOST="${BACKEND_HOST:-remote-inventory-backend-mlwjajxybq-uc.a.run.app:443}"
SERVICE_NAME="inventory.InventoryService"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Remote Inventory Backend E2E Tests${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "${YELLOW}Backend:${NC} $BACKEND_HOST"
echo -e "${YELLOW}Service:${NC} $SERVICE_NAME"
echo ""

# Check if grpcurl is installed
if ! command -v grpcurl &> /dev/null; then
    echo -e "${RED}❌ grpcurl is not installed${NC}"
    echo "Install with: brew install grpcurl"
    exit 1
fi

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper function to run test
run_test() {
    local test_name="$1"
    local command="$2"
    
    echo -e "${YELLOW}Testing:${NC} $test_name"
    
    if output=$(eval "$command" 2>&1); then
        echo -e "${GREEN}✅ PASS${NC}"
        echo "$output" | head -n 10
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}"
        echo "$output"
        ((TESTS_FAILED++))
    fi
    echo ""
}

# Test 1: List available services
echo -e "${BLUE}━━━ Test 1: Service Discovery ━━━${NC}"
run_test "List gRPC services" \
    "grpcurl $BACKEND_HOST list"

# Test 2: List service methods
echo -e "${BLUE}━━━ Test 2: List Service Methods ━━━${NC}"
run_test "List InventoryService methods" \
    "grpcurl $BACKEND_HOST list $SERVICE_NAME"

# Test 3: Create Session (Provider)
echo -e "${BLUE}━━━ Test 3: Create Session ━━━${NC}"
SESSION_RESPONSE=$(grpcurl -d '{
  "provider_id": "test-provider-e2e",
  "provider_name": "E2E Test Provider"
}' $BACKEND_HOST $SERVICE_NAME/CreateSession 2>&1)

if echo "$SESSION_RESPONSE" | grep -q "sessionId"; then
    SESSION_ID=$(echo "$SESSION_RESPONSE" | grep -o '"sessionId": "[^"]*"' | cut -d'"' -f4)
    TOKEN=$(echo "$SESSION_RESPONSE" | grep -o '"token": "[^"]*"' | cut -d'"' -f4)
    echo -e "${GREEN}✅ PASS - Session Created${NC}"
    echo "Session ID: $SESSION_ID"
    echo "Token: $TOKEN"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ FAIL - Could not create session${NC}"
    echo "$SESSION_RESPONSE"
    ((TESTS_FAILED++))
fi
echo ""

# Test 4: List Sessions
echo -e "${BLUE}━━━ Test 4: List Sessions ━━━${NC}"
run_test "List all active sessions" \
    "grpcurl -d '{\"search_query\": \"\"}' $BACKEND_HOST $SERVICE_NAME/ListSessions"

# Test 5: Request Connection (Consumer)
echo -e "${BLUE}━━━ Test 5: Request Connection ━━━${NC}"
if [ -n "$SESSION_ID" ]; then
    CONNECTION_RESPONSE=$(grpcurl -d "{
      \"session_id\": \"$SESSION_ID\",
      \"consumer_id\": \"test-consumer-e2e\",
      \"consumer_name\": \"E2E Test Consumer\"
    }" $BACKEND_HOST $SERVICE_NAME/RequestConnection 2>&1)
    
    if echo "$CONNECTION_RESPONSE" | grep -q "requestId"; then
        REQUEST_ID=$(echo "$CONNECTION_RESPONSE" | grep -o '"requestId": "[^"]*"' | cut -d'"' -f4)
        echo -e "${GREEN}✅ PASS - Connection Requested${NC}"
        echo "Request ID: $REQUEST_ID"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL - Could not request connection${NC}"
        echo "$CONNECTION_RESPONSE"
        ((TESTS_FAILED++))
    fi
else
    echo -e "${YELLOW}⏭  SKIP - No session ID available${NC}"
fi
echo ""

# Test 6: Approve Connection
echo -e "${BLUE}━━━ Test 6: Approve Connection ━━━${NC}"
if [ -n "$REQUEST_ID" ]; then
    run_test "Approve connection request" \
        "grpcurl -d '{
          \"request_id\": \"$REQUEST_ID\"
        }' $BACKEND_HOST $SERVICE_NAME/ApproveConnection"
else
    echo -e "${YELLOW}⏭  SKIP - No request ID available${NC}"
    echo ""
fi

# Test 7: Deny Connection (create a new request first)
echo -e "${BLUE}━━━ Test 7: Deny Connection ━━━${NC}"
if [ -n "$SESSION_ID" ]; then
    # Create another connection request
    DENY_RESPONSE=$(grpcurl -d "{
      \"session_id\": \"$SESSION_ID\",
      \"consumer_id\": \"test-consumer-deny\",
      \"consumer_name\": \"E2E Test Consumer (Deny)\"
    }" $BACKEND_HOST $SERVICE_NAME/RequestConnection 2>&1)
    
    if echo "$DENY_RESPONSE" | grep -q "requestId"; then
        DENY_REQUEST_ID=$(echo "$DENY_RESPONSE" | grep -o '"requestId": "[^"]*"' | cut -d'"' -f4)
        
        run_test "Deny connection request" \
            "grpcurl -d '{
              \"request_id\": \"$DENY_REQUEST_ID\",
              \"reason\": \"E2E test denial\"
            }' $BACKEND_HOST $SERVICE_NAME/DenyConnection"
    fi
else
    echo -e "${YELLOW}⏭  SKIP - No session ID available${NC}"
    echo ""
fi

# Test 8: Heartbeat
echo -e "${BLUE}━━━ Test 8: Heartbeat ━━━${NC}"
if [ -n "$SESSION_ID" ] && [ -n "$TOKEN" ]; then
    run_test "Send heartbeat" \
        "grpcurl -d '{
          \"session_id\": \"$SESSION_ID\",
          \"token\": \"$TOKEN\"
        }' $BACKEND_HOST $SERVICE_NAME/Heartbeat"
else
    echo -e "${YELLOW}⏭  SKIP - No session/token available${NC}"
    echo ""
fi

# Test 9: End Session
echo -e "${BLUE}━━━ Test 9: End Session ━━━${NC}"
if [ -n "$SESSION_ID" ] && [ -n "$TOKEN" ]; then
    run_test "End session" \
        "grpcurl -d '{
          \"session_id\": \"$SESSION_ID\",
          \"token\": \"$TOKEN\"
        }' $BACKEND_HOST $SERVICE_NAME/EndSession"
else
    echo -e "${YELLOW}⏭  SKIP - No session/token available${NC}"
    echo ""
fi

# Summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Test Summary${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "${GREEN}✅ Passed: $TESTS_PASSED${NC}"
echo -e "${RED}❌ Failed: $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed${NC}"
    exit 1
fi
