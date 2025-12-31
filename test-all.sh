#!/bin/bash

# Master Test Runner for Remote Inventory View App

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Remote Inventory - Test Suite${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

TOTAL_PASSED=0
TOTAL_FAILED=0

# Function to run a test section
run_test_section() {
    local section_name="$1"
    local test_command="$2"
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}$section_name${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if eval "$test_command"; then
        echo -e "${GREEN}✅ $section_name passed${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}❌ $section_name failed${NC}"
        echo ""
        return 1
    fi
}

# 1. Backend Build Test
run_test_section "1️⃣  Backend Build" "cd backend && go build -o bin/server ./server" || ((TOTAL_FAILED++))

# 2. Backend HTTP API Tests
if command -v curl &> /dev/null; then
    echo -e "${YELLOW}Starting backend server for API tests...${NC}"
    cd backend && make run > /dev/null 2>&1 &
    BACKEND_PID=$!
    sleep 3  # Give server time to start
    
    if run_test_section "2️⃣  Session Management API" "./backend/test-session.sh"; then
        ((TOTAL_PASSED++))
    else
        ((TOTAL_FAILED++))
    fi
    
    # Kill backend
    kill $BACKEND_PID 2>/dev/null || true
    cd ..
else
    echo -e "${YELLOW}⚠️  curl not found, skipping API tests${NC}"
    echo ""
fi

# 3. Provider App Tests
if command -v flutter &> /dev/null; then
    if run_test_section "3️⃣  Provider App Tests" "cd provider_app && flutter test"; then
        ((TOTAL_PASSED++))
    else
        ((TOTAL_FAILED++))
    fi
    cd ..
else
    echo -e "${YELLOW}⚠️  Flutter not found, skipping Flutter tests${NC}"
    echo ""
fi

# 4. Consumer App Tests
if command -v flutter &> /dev/null; then
    if run_test_section "4️⃣  Consumer App Tests" "cd consumer_app && flutter test"; then
        ((TOTAL_PASSED++))
    else
        ((TOTAL_FAILED++))
    fi
    cd ..
else
    echo -e "${YELLOW}⚠️  Flutter not found, skipping Flutter tests${NC}"
    echo ""
fi

# 5. Code Quality Checks
if command -v gofmt &> /dev/null; then
    if run_test_section "5️⃣  Go Code Formatting" "cd backend && [ -z \"\$(gofmt -l .)\" ]"; then
        ((TOTAL_PASSED++))
    else
        ((TOTAL_FAILED++))
    fi
    cd ..
fi

# Print Final Summary
echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Final Test Summary${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "  ${GREEN}Passed: $TOTAL_PASSED test sections${NC}"
echo -e "  ${RED}Failed: $TOTAL_FAILED test sections${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

if [ $TOTAL_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ ALL TESTS PASSED!${NC}"
    echo ""
    echo "Your application is ready for deployment! 🚀"
    exit 0
else
    echo -e "${RED}❌ SOME TESTS FAILED${NC}"
    echo ""
    echo "Please fix the failing tests before deploying."
    exit 1
fi
