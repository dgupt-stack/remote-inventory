#!/bin/bash

# Session Management Testing Script

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

API_BASE="${API_BASE:-http://localhost:8081}"
PASSED=0
FAILED=0

echo "🧪 Testing Session Management API"
echo "=================================="
echo "Backend: $API_BASE"
echo ""

# Helper function for tests
run_test() {
    local test_name="$1"
    shift
    echo -n "Testing: $test_name... "
    
    if "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAILED++))
        return 1
    fi
}

# Test 1: Backend is running
echo "1️⃣ Checking backend availability..."
if curl -s -f "$API_BASE" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Backend is accessible${NC}"
else
    echo -e "${RED}✗ Backend not running at $API_BASE${NC}"
    echo "Start backend with: cd backend && make run"
    exit 1
fi
echo ""

# Test 2: Create session
echo "2️⃣ Creating session..."
CREATE_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions" \
    -H "Content-Type: application/json" \
    -d '{"provider_id":"test-provider-1","provider_name":"Test Provider"}')

SESSION_ID=$(echo "$CREATE_RESPONSE" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)
TOKEN=$(echo "$CREATE_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
SUCCESS=$(echo "$CREATE_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$SUCCESS" = "true" ] && [ -n "$SESSION_ID" ] && [ -n "$TOKEN" ]; then
    echo -e "${GREEN}✓ Session created${NC}"
    echo "   Session ID: $SESSION_ID"
    echo "   Token: ${TOKEN:0:20}..."
    ((PASSED++))
else
    echo -e "${RED}✗ Session creation failed${NC}"
    echo "Response: $CREATE_RESPONSE"
    ((FAILED++))
fi
echo ""

# Test 3: Join session
echo "3️⃣ Joining session..."
JOIN_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/join" \
    -H "Content-Type: application/json" \
    -d '{"consumer_id":"test-consumer-1","consumer_name":"Test Consumer"}')

CONSUMER_TOKEN=$(echo "$JOIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
JOIN_SUCCESS=$(echo "$JOIN_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$JOIN_SUCCESS" = "true" ] && [ -n "$CONSUMER_TOKEN" ]; then
    echo -e "${GREEN}✓ Joined session successfully${NC}"
    echo "   Consumer Token: ${CONSUMER_TOKEN:0:20}..."
    ((PASSED++))
else
    echo -e "${RED}✗ Join session failed${NC}"
    echo "Response: $JOIN_RESPONSE"
    ((FAILED++))
fi
echo ""

# Test 4: Send heartbeat
echo "4️⃣ Sending heartbeat..."
HEARTBEAT_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/heartbeat" \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"$TOKEN\",\"role\":\"provider\"}")

ACTIVE=$(echo "$HEARTBEAT_RESPONSE" | grep -o '"active":[^,}]*' | cut -d':' -f2)

if [ "$ACTIVE" = "true" ]; then
    echo -e "${GREEN}✓ Heartbeat successful${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Heartbeat failed${NC}"
    echo "Response: $HEARTBEAT_RESPONSE"
    ((FAILED++))
fi
echo ""

# Test 5: Try joining invalid session
echo "5️⃣ Testing invalid session join..."
INVALID_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions/invalid-session-id/join" \
    -H "Content-Type: application/json" \
    -d '{"consumer_id":"test","consumer_name":"Test"}')

INVALID_SUCCESS=$(echo "$INVALID_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$INVALID_SUCCESS" = "false" ] || [ -z "$INVALID_SUCCESS" ]; then
    echo -e "${GREEN}✓ Invalid session properly rejected${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Invalid session should be rejected${NC}"
    ((FAILED++))
fi
echo ""

# Test 6: End session
echo "6️⃣ Ending session..."
END_RESPONSE=$(curl -s -X DELETE "$API_BASE/v1/sessions/$SESSION_ID?token=$TOKEN")

END_SUCCESS=$(echo "$END_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$END_SUCCESS" = "true" ]; then
    echo -e "${GREEN}✓ Session ended successfully${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ End session failed${NC}"
    echo "Response: $END_RESPONSE"
    ((FAILED++))
fi
echo ""

# Print summary
echo "========================================"
echo "Test Summary:"
echo -e "  ${GREEN}Passed: $PASSED${NC}"
echo -e "  ${RED}Failed: $FAILED${NC}"
echo "========================================"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
