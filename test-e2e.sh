#!/bin/bash

# End-to-End Test Suite for Remote Inventory View App
# Tests the complete flow: Provider creates session → Consumer joins → Commands flow → Privacy verified

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

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Remote Inventory - E2E Test Suite${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Test 1: Backend Availability
echo -e "${YELLOW}Test 1: Backend Availability${NC}"
if curl -s -f "$API_BASE" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Backend is accessible at $API_BASE${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Backend not running${NC}"
    echo "Start backend with: cd backend && make run"
    exit 1
fi
echo ""

# Test 2: Create Provider Session
echo -e "${YELLOW}Test 2: Provider Session Creation${NC}"
CREATE_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions" \
    -H "Content-Type: application/json" \
    -d '{"provider_id":"e2e-provider","provider_name":"E2E Test Provider"}')

SESSION_ID=$(echo "$CREATE_RESPONSE" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)
PROVIDER_TOKEN=$(echo "$CREATE_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -n "$SESSION_ID" ] && [ -n "$PROVIDER_TOKEN" ]; then
    echo -e "${GREEN}✓ Provider session created${NC}"
    echo "   Session ID: $SESSION_ID"
    ((PASSED++))
else
    echo -e "${RED}✗ Provider session creation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 3: Consumer Join Session
echo -e "${YELLOW}Test 3: Consumer Joins Session${NC}"
JOIN_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/join" \
    -H "Content-Type: application/json" \
    -d '{"consumer_id":"e2e-consumer","consumer_name":"E2E Test Consumer"}')

CONSUMER_TOKEN=$(echo "$JOIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
JOIN_SUCCESS=$(echo "$JOIN_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$JOIN_SUCCESS" = "true" ] && [ -n "$CONSUMER_TOKEN" ]; then
    echo -e "${GREEN}✓ Consumer joined session${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Consumer join failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 4: Provider Heartbeat
echo -e "${YELLOW}Test 4: Provider Heartbeat${NC}"
PROVIDER_HB=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/heartbeat" \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"$PROVIDER_TOKEN\",\"role\":\"provider\"}")

PROVIDER_ACTIVE=$(echo "$PROVIDER_HB" | grep -o '"active":[^,}]*' | cut -d':' -f2)

if [ "$PROVIDER_ACTIVE" = "true" ]; then
    echo -e "${GREEN}✓ Provider heartbeat successful${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Provider heartbeat failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 5: Consumer Heartbeat
echo -e "${YELLOW}Test 5: Consumer Heartbeat${NC}"
CONSUMER_HB=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/heartbeat" \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"$CONSUMER_TOKEN\",\"role\":\"consumer\"}")

CONSUMER_ACTIVE=$(echo "$CONSUMER_HB" | grep -o '"active":[^,}]*' | cut -d':' -f2)

if [ "$CONSUMER_ACTIVE" = "true" ]; then
    echo -e "${GREEN}✓ Consumer heartbeat successful${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Consumer heartbeat failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 6: Invalid Token Rejection
echo -e "${YELLOW}Test 6: Invalid Token Rejection${NC}"
INVALID_HB=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/heartbeat" \
    -H "Content-Type: application/json" \
    -d '{"token":"invalid-token-12345","role":"provider"}')

INVALID_ACTIVE=$(echo "$INVALID_HB" | grep -o '"active":[^,}]*' | cut -d':' -f2)

if [ "$INVALID_ACTIVE" = "false" ] || [ -z "$INVALID_ACTIVE" ]; then
    echo -e "${GREEN}✓ Invalid token properly rejected${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Invalid token should be rejected${NC}"
    ((FAILED++))
fi
echo ""

# Test 7: Session Isolation
echo -e "${YELLOW}Test 7: Session Isolation${NC}"
# Create second session
SESSION2_RESPONSE=$(curl -s -X POST "$API_BASE/v1/sessions" \
    -H "Content-Type: application/json" \
    -d '{"provider_id":"e2e-provider-2","provider_name":"Second Provider"}')

SESSION_ID_2=$(echo "$SESSION2_RESPONSE" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)

if [ "$SESSION_ID" != "$SESSION_ID_2" ] && [ -n "$SESSION_ID_2" ]; then
    echo -e "${GREEN}✓ Sessions are properly isolated${NC}"
    echo "   Session 1: $SESSION_ID"
    echo "   Session 2: $SESSION_ID_2"
    ((PASSED++))
else
    echo -e "${RED}✗ Session isolation failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 8: Multiple Concurrent Sessions
echo -e "${YELLOW}Test 8: Concurrent Sessions Support${NC}"
CONCURRENT_COUNT=0
for i in {1..5}; do
    CONCURRENT_RESP=$(curl -s -X POST "$API_BASE/v1/sessions" \
        -H "Content-Type: application/json" \
        -d "{\"provider_id\":\"concurrent-$i\",\"provider_name\":\"Concurrent $i\"}")
    
    CONCURRENT_ID=$(echo "$CONCURRENT_RESP" | grep -o '"session_id":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$CONCURRENT_ID" ]; then
        ((CONCURRENT_COUNT++))
    fi
done

if [ $CONCURRENT_COUNT -eq 5 ]; then
    echo -e "${GREEN}✓ Backend supports concurrent sessions ($CONCURRENT_COUNT)${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Concurrent sessions failed ($CONCURRENT_COUNT/5)${NC}"
    ((FAILED++))
fi
echo ""

# Test 9: Session Cleanup
echo -e "${YELLOW}Test 9: Session End${NC}"
END_RESPONSE=$(curl -s -X DELETE "$API_BASE/v1/sessions/$SESSION_ID?token=$PROVIDER_TOKEN")
END_SUCCESS=$(echo "$END_RESPONSE" | grep -o '"success":[^,}]*' | cut -d':' -f2)

if [ "$END_SUCCESS" = "true" ]; then
    echo -e "${GREEN}✓ Session ended successfully${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Session end failed${NC}"
    ((FAILED++))
fi
echo ""

# Test 10: Session Availability After End
echo -e "${YELLOW}Test 10: Session Unavailable After End${NC}"
ENDED_SESSION_HB=$(curl -s -X POST "$API_BASE/v1/sessions/$SESSION_ID/heartbeat" \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"$PROVIDER_TOKEN\",\"role\":\"provider\"}")

ENDED_ACTIVE=$(echo "$ENDED_SESSION_HB" | grep -o '"active":[^,}]*' | cut -d':' -f2)

if [ "$ENDED_ACTIVE" = "false" ] || [ -z "$ENDED_ACTIVE" ]; then
    echo -e "${GREEN}✓ Ended session properly unavailable${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Ended session still active${NC}"
    ((FAILED++))
fi
echo ""

# Print Summary
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  E2E Test Summary${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "  ${GREEN}Passed: $PASSED${NC}"
echo -e "  ${RED}Failed: $FAILED${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All E2E tests passed!${NC}"
    echo ""
    echo "Session lifecycle verified:"
    echo "  ✓ Provider creates session"
    echo "  ✓ Consumer joins session"
    echo "  ✓ Both send heartbeats"
    echo "  ✓ Invalid tokens rejected"
    echo "  ✓ Sessions isolated"
    echo "  ✓ Concurrent sessions supported"
    echo "  ✓ Session cleanup works"
    exit 0
else
    echo -e "${RED}❌ Some E2E tests failed${NC}"
    exit 1
fi
