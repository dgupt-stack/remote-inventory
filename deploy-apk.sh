#!/bin/bash

# APK Distribution Script
# Builds APK, uploads to Google Cloud Storage, and sends email notifications

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
PROJECT_ID="${GCP_PROJECT_ID:-tiger-on-cloud}"
BUCKET_NAME="${GCS_BUCKET:-remote-inventory-apks}"
APP_NAME="JARVIS Remote Inventory"
RECIPIENTS="dgupt@360world.com,provider@360world.com"

# Get version and build info
VERSION=$(date +%Y%m%d-%H%M%S)
APK_PATH="provider_app/build/app/outputs/flutter-apk/app-release.apk"
APK_NAME="jarvis-remote-inventory-${VERSION}.apk"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}APK Distribution Automation${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Step 1: Build APK
echo -e "${YELLOW}Step 1/4: Building APK...${NC}"
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

# Step 2: Upload to Google Cloud Storage
echo ""
echo -e "${YELLOW}Step 2/4: Uploading to Google Cloud Storage...${NC}"

# Create bucket if it doesn't exist
if ! gsutil ls -b gs://${BUCKET_NAME} > /dev/null 2>&1; then
    echo "Creating bucket gs://${BUCKET_NAME}..."
    gsutil mb -p ${PROJECT_ID} gs://${BUCKET_NAME}
    gsutil iam ch allUsers:objectViewer gs://${BUCKET_NAME}
fi

# Upload APK
gsutil -h "Content-Type:application/vnd.android.package-archive" \
       -h "Cache-Control:no-cache" \
       cp ${APK_PATH} gs://${BUCKET_NAME}/${APK_NAME}

# Make file publicly accessible
gsutil acl ch -u AllUsers:R gs://${BUCKET_NAME}/${APK_NAME}

DOWNLOAD_URL="https://storage.googleapis.com/${BUCKET_NAME}/${APK_NAME}"
echo -e "${GREEN}✓ Uploaded to GCS${NC}"
echo "   URL: ${DOWNLOAD_URL}"

# Step 3: Generate metadata file
echo ""
echo -e "${YELLOW}Step 3/4: Generating metadata...${NC}"

cat > /tmp/apk-metadata.json <<EOF
{
  "app_name": "${APP_NAME}",
  "version": "${VERSION}",
  "build_date": "$(date -u +"%Y-%m-%d %H:%M:%S UTC")",
  "size": "${APK_SIZE}",
  "download_url": "${DOWNLOAD_URL}",
  "platform": "Android",
  "build_type": "Release"
}
EOF

gsutil -h "Content-Type:application/json" \
       cp /tmp/apk-metadata.json gs://${BUCKET_NAME}/${APK_NAME}.json

echo -e "${GREEN}✓ Metadata uploaded${NC}"

# Step 4: Send email notification
echo ""
echo -e "${YELLOW}Step 4/4: Sending email notifications...${NC}"

# Call Python email sender
python3 send-email.py "${DOWNLOAD_URL}" "${VERSION}" "${APK_SIZE}"
EMAIL_STATUS=$?

if [ $EMAIL_STATUS -eq 0 ]; then
    echo -e "${GREEN}✓ Email sent to recipients${NC}"
else
    echo -e "${YELLOW}⚠ Automated email failed. Saving to file...${NC}"
    # Save email template for manual sending
    cat > email-notification.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #0A0E27 0%, #1a1f3a 100%); color: #00D9FF; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f4f4f4; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #00D9FF; color: #0A0E27; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .details { background: white; padding: 15px; border-left: 4px solid #00D9FF; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⭐ J.A.R.V.I.S ⭐</h1>
            <h2>Remote Inventory - New Build Available</h2>
        </div>
        <div class="content">
            <p>A new build is ready for testing.</p>
            <div class="details">
                <strong>Build Details:</strong><br>
                📱 Version: ${VERSION}<br>
                📅 Build Date: $(date)<br>
                📦 Size: ${APK_SIZE}<br>
            </div>
            <center>
                <a href="${DOWNLOAD_URL}" class="button">📥 Download APK</a>
            </center>
        </div>
    </div>
</body>
</html>
EOF
    echo "   Email template saved to: email-notification.html"
    echo "   Please send manually to: ${RECIPIENTS}"
fi
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #0A0E27 0%, #1a1f3a 100%); color: #00D9FF; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #f4f4f4; padding: 30px; border-radius: 0 0 10px 10px; }
        .button { display: inline-block; background: #00D9FF; color: #0A0E27; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }
        .button:hover { background: #00b8d4; }
        .details { background: white; padding: 15px; border-left: 4px solid #00D9FF; margin: 20px 0; }
        .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⭐ J.A.R.V.I.S ⭐</h1>
            <h2>Remote Inventory - New Build Available</h2>
        </div>
        <div class="content">
            <p>Hello!</p>
            <p>A new build of the JARVIS Remote Inventory app is ready for testing.</p>
            
            <div class="details">
                <strong>Build Details:</strong><br>
                📱 Version: ${VERSION}<br>
                📅 Build Date: $(date +"%Y-%m-%d %H:%M %Z")<br>
                📦 Size: ${APK_SIZE}<br>
                🔧 Type: Release Build
            </div>

            <center>
                <a href="${DOWNLOAD_URL}" class="button">📥 Download APK</a>
            </center>

            <p><strong>Installation Instructions:</strong></p>
            <ol>
                <li>Download the APK from the link above</li>
                <li>Enable "Install from Unknown Sources" on your Android device</li>
                <li>Open the downloaded APK to install</li>
                <li>Launch the app and enjoy!</li>
            </ol>

            <p><strong>Direct Download URL:</strong><br>
            <a href="${DOWNLOAD_URL}">${DOWNLOAD_URL}</a></p>

            <div class="footer">
                <p>This is an automated build notification from the Remote Inventory CI/CD pipeline.</p>
                <p>Built on $(date +"%Y-%m-%d at %H:%M %Z")</p>
            </div>
        </div>
    </div>
</body>
</html>
EOF
)

# Save email to temp file
echo "$EMAIL_BODY" > /tmp/email-body.html

# Send email using gcloud (requires SendGrid or similar)
# Option 1: Using gcloud with SendGrid API
if command -v sendgrid &> /dev/null; then
    echo "Sending via SendGrid..."
    # SendGrid implementation here
    echo -e "${YELLOW}⚠ SendGrid not configured. Email not sent.${NC}"
    echo "   Please configure SendGrid API key for automated emails."
else
    # Option 2: Display email content for manual sending
    echo -e "${YELLOW}⚠ Email service not configured${NC}"
    echo ""
    echo "Email Details:"
    echo "  To: ${RECIPIENTS}"
    echo "  Subject: ${EMAIL_SUBJECT}"
    echo "  Body saved to: /tmp/email-body.html"
    echo ""
    echo -e "${BLUE}Manual Email Option:${NC}"
    echo "  Open /tmp/email-body.html in a browser, copy, and email to recipients"
fi

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Distribution Complete${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📱 App: ${APP_NAME}"
echo "🏷️  Version: ${VERSION}"
echo "📦 Size: ${APK_SIZE}"
echo "🌐 Download URL:"
echo "   ${DOWNLOAD_URL}"
echo ""
echo "📧 Recipients: ${RECIPIENTS}"
echo "📄 Email template: /tmp/email-body.html"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Send email manually (if automated email failed)"
echo "  2. Test APK installation on Android device"
echo "  3. Verify app functionality"
echo ""
