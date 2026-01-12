#!/bin/bash

# Firebase App Distribution Deployment
# Purpose-built for mobile app testing - won't get blocked

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Firebase App Distribution${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Configuration
FIREBASE_APP_ID="${FIREBASE_APP_ID:-}"
TESTER_EMAILS="dgupt@360world.com,provider@360world.com"
RELEASE_NOTES="
🎯 Unified Provider + Consumer App
✅ Merged apps (removed 134 redundant files)
✅ Complete Lovable REST API
✅ WebRTC signaling
✅ JARVIS-themed UI

Build: $(date +%Y%m%d-%H%M%S)
"

# Step 1: Check Firebase CLI
echo -e "${YELLOW}Step 1/4: Checking Firebase CLI...${NC}"
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}✗ Firebase CLI not installed${NC}"
    echo ""
    echo "Install with:"
    echo "  npm install -g firebase-tools"
    echo ""
    exit 1
fi

# Check if logged in
if ! firebase projects:list &> /dev/null; then
    echo "Firebase login required..."
    firebase login
fi

echo -e "${GREEN}✓ Firebase CLI ready${NC}"

# Step 2: Build APK
echo ""
echo -e "${YELLOW}Step 2/4: Building APK...${NC}"
cd provider_app
flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1
flutter build apk --release

if [ ! -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo -e "${RED}✗ APK build failed${NC}"
    exit 1
fi

APK_SIZE=$(ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print $5}')
echo -e "${GREEN}✓ APK built successfully (${APK_SIZE})${NC}"
cd ..

# Step 3: Get Firebase App ID if not set
if [ -z "$FIREBASE_APP_ID" ]; then
    echo ""
    echo -e "${YELLOW}Step 3/4: Getting Firebase App ID...${NC}"
    
    # Try to get from google-services.json
    if [ -f "provider_app/android/app/google-services.json" ]; then
        FIREBASE_APP_ID=$(grep -o '"mobilesdk_app_id": "[^"]*"' provider_app/android/app/google-services.json | head -1 | cut -d'"' -f4)
    fi
    
    if [ -z "$FIREBASE_APP_ID" ]; then
        echo -e "${RED}✗ Firebase App ID not found${NC}"
        echo ""
        echo "Set it with:"
        echo "  export FIREBASE_APP_ID='1:xxxxx:android:xxxxx'"
        echo ""
        echo "Or add google-services.json to provider_app/android/app/"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Firebase App ID: ${FIREBASE_APP_ID}${NC}"

# Step 4: Upload to Firebase App Distribution
echo ""
echo -e "${YELLOW}Step 4/4: Uploading to Firebase App Distribution...${NC}"

firebase appdistribution:distribute \
    provider_app/build/app/outputs/flutter-apk/app-release.apk \
    --app "${FIREBASE_APP_ID}" \
    --groups "testers" \
    --testers "${TESTER_EMAILS}" \
    --release-notes "${RELEASE_NOTES}"

UPLOAD_STATUS=$?

if [ $UPLOAD_STATUS -eq 0 ]; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ Distribution Complete${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "📱 App: JARVIS Remote Inventory"
    echo "📦 Size: ${APK_SIZE}"
    echo "📧 Testers notified: ${TESTER_EMAILS}"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "  1. Testers will receive email from Firebase"
    echo "  2. They can download via Firebase App Distribution app"
    echo "  3. Or download directly from email link"
    echo ""
    echo "View distribution:"
    echo "  https://console.firebase.google.com/project/_/appdistribution"
    echo ""
else
    echo -e "${RED}✗ Upload failed${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check Firebase project permissions"
    echo "  2. Verify FIREBASE_APP_ID is correct"
    echo "  3. Ensure testers are added in Firebase Console"
    echo ""
    exit 1
fi
