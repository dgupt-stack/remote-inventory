#!/bin/bash

# WebRTC Signaling & Complete API Testing Script
# Tests all endpoints including session management, connection requests, and WebRTC signaling

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

API_BASE="${API_BASE:-http://localhost:8081}"
PASSED=0
FAILED=0

echo "🧪 Testing Complete Lovable Integration API"
echo "============================================"
echo "Backend: $API_BASE"
echo ""

# Helper functions
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

print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Test 0: Backend availability
print_section "0️⃣ Backend Availability Check"

echo -n "Checking if backend is accessible... "
if curl -s -f "$API_BASE" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Backend is accessible${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠ REST gateway might not be running${NC}"
    echo "Note: If only gRPC is running, REST endpoints won't be available"
    echo "To enable REST: Ensure gateway.go is active in backend/server/"
fi
echo ""

# Test 1: Session Management
print_section "1️⃣ Session Management Tests"

echo "Creating new provider session..."
CREATE_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions" \
    -H "Content-Type: application/json" \
    -d '{"provider_id":"test-provider-1","provider_name":"Test Provider","location":"San Francisco, CA"}')

# Handle both snake_case and camelCase JSON responses
SESSION_ID=$(echo "$CREATE_RESPONSE" | grep -o '"sessionId":"[^"]*"' | cut -d'"' -f4)
if [ -z "$SESSION_ID" ]; then
    SESSION_ID=$(echo "$CREATE_RESPONSE" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)
fi

TOKEN=$(echo "$CREATE_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
SUCCESS=$(echo "$CREATE_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$SUCCESS" = "true" ] && [ -n "$SESSION_ID" ] && [ -n "$TOKEN" ]; then
    echo -e "${GREEN}✓ Session created successfully${NC}"
    echo "   Session ID: $SESSION_ID"
    echo "   Token: ${TOKEN:0:20}..."
    ((PASSED++))
else
    echo -e "${RED}✗ Session creation failed${NC}"
    echo "Response: $CREATE_RESPONSE"
    ((FAILED++))
    exit 1
fi
echo ""

# Test 2: List Sessions
echo "Listing active sessions..."
LIST_RESPONSE=$(curl -s -X GET "$API_BASE/v1/sessions")
SESSIONS_COUNT=$(echo "$LIST_RESPONSE" | grep -o '"sessionId"' | wc -l)
if [ "$SESSIONS_COUNT" -eq 0 ]; then
    SESSIONS_COUNT=$(echo "$LIST_RESPONSE" | grep -o '"session_id"' | wc -l)
fi

if [ "$SESSIONS_COUNT" -ge 1 ]; then
    echo -e "${GREEN}✓ Found $SESSIONS_COUNT active session(s)${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ No sessions found${NC}"
    ((FAILED++))
fi
echo ""

# Test 3: Connection Request Flow
print_section "2️⃣ Connection Request Tests"

echo "Consumer requesting connection..."
REQUEST_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/request" \
    -H "Content-Type: application/json" \
    -d '{"consumer_id":"test-consumer-1","consumer_name":"Jane Smith"}')

REQUEST_ID=$(echo "$REQUEST_RESPONSE" | grep -o '"requestId":"[^"]*"' | cut -d'"' -f4)
if [ -z "$REQUEST_ID" ]; then
    REQUEST_ID=$(echo "$REQUEST_RESPONSE" | grep -o '"request_id":"[^"]*"' | cut -d'"' -f4)
fi
REQUEST_SUCCESS=$(echo "$REQUEST_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$REQUEST_SUCCESS" = "true" ] && [ -n "$REQUEST_ID" ]; then
    echo -e "${GREEN}✓ Connection request created${NC}"
    echo "   Request ID: $REQUEST_ID"
    ((PASSED++))
else
    echo -e "${RED}✗ Connection request failed${NC}"
    echo "Response: $REQUEST_RESPONSE"
    ((FAILED++))
fi
echo ""

echo "Approving connection request..."
APPROVE_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions/requests/$REQUEST_ID/approve")
APPROVE_SUCCESS=$(echo "$APPROVE_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)
CONSUMER_TOKEN=$(echo "$APPROVE_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ "$APPROVE_SUCCESS" = "true" ] && [ -n "$CONSUMER_TOKEN" ]; then
    echo -e "${GREEN}✓ Connection approved${NC}"
    echo "   Consumer Token: ${CONSUMER_TOKEN:0:20}..."
    ((PASSED++))
else
    echo -e "${RED}✗ Approval failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 4: WebRTC Signaling
print_section "3️⃣ WebRTC Signaling Tests"

PROVIDER_DEVICE_ID="provider-${SESSION_ID:0:8}"
CONSUMER_DEVICE_ID="consumer-${REQUEST_ID:0:8}"

echo "Sending WebRTC OFFER from provider to consumer..."
OFFER_RESPONSE=$(curl -s -X POST "$API_BASE/v1/webrtc/signal" \
    -H "Content-Type: application/json" \
    -d "{
        \"session_id\":\"$SESSION_ID\",
        \"from_device_id\":\"$PROVIDER_DEVICE_ID\",
        \"to_device_id\":\"$CONSUMER_DEVICE_ID\",
        \"type\":\"OFFER\",
        \"payload\":\"{\\\"type\\\":\\\"offer\\\",\\\"sdp\\\":\\\"v=0...\\\"}\"}
    }")

SIGNAL_SUCCESS=$(echo "$OFFER_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$SIGNAL_SUCCESS" = "true" ]; then
    echo -e "${GREEN}✓ WebRTC OFFER sent successfully${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ WebRTC signal failed${NC}"
    echo "Response: $OFFER_RESPONSE"
    ((FAILED++))
fi
echo ""

echo "Sending WebRTC ANSWER from consumer to provider..."
ANSWER_RESPONSE=$(curl -s -X POST "$API_BASE/v1/webrtc/signal" \
    -H "Content-Type: application/json" \
    -d "{
        \"session_id\":\"$SESSION_ID\",
        \"from_device_id\":\"$CONSUMER_DEVICE_ID\",
        \"to_device_id\":\"$PROVIDER_DEVICE_ID\",
        \"type\":\"ANSWER\",
        \"payload\":\"{\\\"type\\\":\\\"answer\\\",\\\"sdp\\\":\\\"v=0...\\\"}\"}
    }")

ANSWER_SUCCESS=$(echo "$ANSWER_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$ANSWER_SUCCESS" = "true" ]; then
    echo -e "${GREEN}✓ WebRTC ANSWER sent successfully${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ WebRTC answer failed${NC}"
    ((FAILED++))
fi
echo ""

echo "Sending ICE candidate..."
ICE_RESPONSE=$(curl -s -X POST "$API_BASE/v1/webrtc/signal" \
    -H "Content-Type: application/json" \
    -d "{
        \"session_id\":\"$SESSION_ID\",
        \"from_device_id\":\"$PROVIDER_DEVICE_ID\",
        \"to_device_id\":\"$CONSUMER_DEVICE_ID\",
        \"type\":\"ICE_CANDIDATE\",
        \"payload\":\"{\\\"candidate\\\":\\\"candidate:1...\\\"}\"}
    }")

ICE_SUCCESS=$(echo "$ICE_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$ICE_SUCCESS" = "true" ]; then
    echo -e "${GREEN}✓ ICE candidate sent successfully${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ ICE candidate failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 5: Heartbeat
print_section "4️⃣ Heartbeat Tests"

echo "Sending provider heartbeat..."
HEARTBEAT_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/heartbeat" \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"$TOKEN\",\"role\":\"provider\"}")

ACTIVE=$(echo "$HEARTBEAT_RESPONSE" | grep -o '"active":[^,}]*' | cut -d':' -f2)
DURATION=$(echo "$HEARTBEAT_RESPONSE" | grep -o '"session_duration_ms":[^,}]*' | cut -d':' -f2)

if [ "$ACTIVE" = "true" ] && [ -n "$DURATION" ]; then
    echo -e "${GREEN}✓ Heartbeat successful${NC}"
    echo "   Session Duration: ${DURATION}ms"
    ((PASSED++))
else
    echo -e "${RED}✗ Heartbeat failed${NC}"
    echo "Response: $HEARTBEAT_RESPONSE"
    ((FAILED++))
fi
echo ""

echo "Sending consumer heartbeat..."
CONSUMER_HEARTBEAT=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/heartbeat" \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"$CONSUMER_TOKEN\",\"role\":\"consumer\"}")

CONSUMER_ACTIVE=$(echo "$CONSUMER_HEARTBEAT" | grep -o '"active":[^,}]*' | cut -d':' -f2)

if [ "$CONSUMER_ACTIVE" = "true" ]; then
    echo -e "${GREEN}✓ Consumer heartbeat successful${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Consumer heartbeat failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 6: Error Handling
print_section "5️⃣ Error Handling Tests"

echo "Testing invalid session heartbeat..."
INVALID_HEARTBEAT=$(curl -s -X POST "$API_BASE/v1/sessions/invalid-session/heartbeat" \
    -H "Content-Type: application/json" \
    -d '{"token":"invalid","role":"provider"}')

INVALID_ACTIVE=$(echo "$INVALID_HEARTBEAT" | grep -o '"active":[^,}]*' | cut -d':' -f2)

if [ "$INVALID_ACTIVE" = "false" ]; then
    echo -e "${GREEN}✓ Invalid session properly handled${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠ Unexpected response for invalid session${NC}"
fi
echo ""

echo "Testing invalid WebRTC signal..."
INVALID_SIGNAL=$(curl -s -X POST "$API_BASE/v1/webrtc/signal" \
    -H "Content-Type: application/json" \
    -d '{"session_id":"invalid","from_device_id":"test","to_device_id":"test","type":"OFFER","payload":"{}"}')

# Should get an error response
if echo "$INVALID_SIGNAL" | grep -q "not found\|error"; then
    echo -e "${GREEN}✓ Invalid signal properly rejected${NC}"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠ Expected error for invalid session${NC}"
fi
echo ""

# Test 7: Cleanup
print_section "6️⃣ Cleanup Tests"

echo "Ending session..."
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

# Verify session is gone
echo "Verifying session is deleted..."
sleep 1
VERIFY_LIST=$(curl -s -X GET "$API_BASE/v1/sessions")
if echo "$VERIFY_LIST" | grep -q "$SESSION_ID"; then
    echo -e "${RED}✗ Session still exists after deletion${NC}"
    ((FAILED++))
else
    echo -e "${GREEN}✓ Session successfully removed${NC}"
    ((PASSED++))
fi
echo ""

# Print summary
print_section "📊 Test Summary"

echo -e "  ${GREEN}Passed: $PASSED${NC}"
echo -e "  ${RED}Failed: $FAILED${NC}"
echo ""

TOTAL=$((PASSED + FAILED))
if [ $TOTAL -gt 0 ]; then
    PERCENTAGE=$((PASSED * 100 / TOTAL))
    echo "  Success Rate: $PERCENTAGE%"
fi

echo ""
echo "=========================================="
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    echo "The Lovable Integration API is working correctly."
    echo "You can now use this backend with your Lovable web app."
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    echo ""
    echo "Please check the errors above and verify:"
    echo "  1. Backend server is running (gRPC on :8080)"
    echo "  2. REST gateway is enabled (HTTP on :8081)"
    echo "  3. All required endpoints are implemented"
    exit 1
fi
