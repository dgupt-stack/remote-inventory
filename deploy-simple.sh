#!/bin/bash

# Simple APK Distribution via GCS + Direct Sharing
# Uses existing GCS upload with macOS sharing integration

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
BUCKET_NAME="remote-inventory-apks"
TESTER_EMAILS="dgupt@360world.com,provider@360world.com"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Simple APK Distribution${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Step 1: Build APK
echo -e "${YELLOW}Step 1/3: Building APK...${NC}"
cd provider_app
flutter build apk --release > /dev/null 2>&1
APK_SIZE=$(ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print $5}')
echo -e "${GREEN}✓ APK built (${APK_SIZE})${NC}"
cd ..

# Step 2: Upload to GCS
echo ""
echo -e "${YELLOW}Step 2/3: Uploading to Google Cloud Storage...${NC}"
VERSION=$(date +%Y%m%d-%H%M%S)
APK_NAME="jarvis-remote-inventory-${VERSION}.apk"

gsutil cp provider_app/build/app/outputs/flutter-apk/app-release.apk \
  gs://${BUCKET_NAME}/${APK_NAME} > /dev/null 2>&1

gsutil acl ch -u AllUsers:R gs://${BUCKET_NAME}/${APK_NAME} > /dev/null 2>&1

DOWNLOAD_URL="https://storage.googleapis.com/remote-inventory-apks/${APK_NAME}"
echo -e "${GREEN}✓ Uploaded to GCS${NC}"

# Step 3: Share via macOS Mail
echo ""
echo -e "${YELLOW}Step 3/3: Creating shareable link...${NC}"

# Create simple text file with link
cat > /tmp/apk-share.txt <<EOF
JARVIS Remote Inventory - New Build ${VERSION}

Download APK (${APK_SIZE}):
${DOWNLOAD_URL}

Installation:
1. Download the APK
2. Enable "Unknown Sources" on Android
3. Install and enjoy!

Built: $(date)
EOF

# Copy URL to clipboard
echo -n "${DOWNLOAD_URL}" | pbcopy

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Distribution Ready${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📱 Version: ${VERSION}"
echo "📦 Size: ${APK_SIZE}"
echo "🔗 Download URL (copied to clipboard):"
echo "   ${DOWNLOAD_URL}"
echo ""
echo -e "${YELLOW}Share with testers:${NC}"
echo "  1. URL is in your clipboard - paste to email/Slack/WhatsApp"
echo "  2. Or open Mail.app and paste"
echo "  3. Send to: ${TESTER_EMAILS}"
echo ""
echo "Message template saved to: /tmp/apk-share.txt"
echo ""

# Optional: Open Mail.app with pre-filled content
read -p "Open Mail.app now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Create mailto link
    SUBJECT="JARVIS Remote Inventory - New Build ${VERSION}"
    BODY="Download APK: ${DOWNLOAD_URL}%0A%0ASize: ${APK_SIZE}%0ABuilt: $(date)"
    open "mailto:${TESTER_EMAILS}?subject=${SUBJECT}&body=${BODY}"
    echo "✓ Mail.app opened with pre-filled message"
fi
