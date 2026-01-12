# Manual APK Distribution Guide

## Current Build

- **APK**: `/Users/djgupt/Development/360/remote-inventory/provider_app/build/app/outputs/flutter-apk/app-release.apk`
- **Size**: 23.6 MB
- **Build Date**: January 12, 2026
- **Status**: ✅ Ready for distribution

---

## Option 1: Automated (Requires GCS Re-authentication)

### Step 1: Re-authenticate with Google Cloud

```bash
gcloud auth login
gcloud auth application-default login
```

### Step 2: Run Deployment Script

```bash
cd /Users/djgupt/Development/360/remote-inventory
./deploy-apk.sh
```

This will:
- Create GCS bucket `remote-inventory-apks` if needed
- Upload APK with timestamped name
- Generate public download URL
- Create email template

---

## Option 2: Manual Upload (Quickest)

### Step 1: Upload to GCS

```bash
# Set variables
VERSION=$(date +%Y%m%d-%H%M%S)
APK_NAME="jarvis-remote-inventory-${VERSION}.apk"

# Create bucket (if needed)
gsutil mb -p events-360world gs://remote-inventory-apks

# Upload APK
gsutil cp /Users/djgupt/Development/360/remote-inventory/provider_app/build/app/outputs/flutter-apk/app-release.apk \
  gs://remote-inventory-apks/${APK_NAME}

# Make publicly accessible
gsutil acl ch -u AllUsers:R gs://remote-inventory-apks/${APK_NAME}

# Get URL
echo "https://storage.googleapis.com/remote-inventory-apks/${APK_NAME}"
```

### Step 2: Send Email

**To**: dgupt@360world.com, provider@360world.com  
**Subject**: JARVIS Remote Inventory - New Build Available

**Email Body** (use HTML email):

```html
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
            <p>Hello!</p>
            <p>A new build of the JARVIS Remote Inventory app is ready for testing.</p>
            
            <div class="details">
                <strong>Build Details:</strong><br>
                📱 Version: [INSERT_VERSION]<br>
                📅 Build Date: January 12, 2026<br>
                📦 Size: 23.6 MB<br>
                🔧 Type: Release Build
            </div>

            <center>
                <a href="[INSERT_DOWNLOAD_URL]" class="button">📥 Download APK</a>
            </center>

            <p><strong>Installation Instructions:</strong></p>
            <ol>
                <li>Download the APK from the link above</li>
                <li>Enable "Install from Unknown Sources" on your Android device</li>
                <li>Open the downloaded APK to install</li>
                <li>Launch the app and enjoy!</li>
            </ol>

            <p><strong>Direct Download URL:</strong><br>
            <a href="[INSERT_DOWNLOAD_URL]">[INSERT_DOWNLOAD_URL]</a></p>
        </div>
    </div>
</body>
</html>
```

Replace `[INSERT_VERSION]` and `[INSERT_DOWNLOAD_URL]` with actual values from Step 1.

---

## Option 3: Alternative Storage Options

### Google Drive
```bash
# Upload to Google Drive and share link
# Use Google Drive web interface or gdrive CLI
```

### Dropbox
```bash
# Upload via Dropbox and get sharing link
```

### Firebase App Distribution
```bash
firebase appdistribution:distribute \
  provider_app/build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_FIREBASE_APP_ID \
  --groups testers \
  --release-notes "New unified app build"
```

---

## Future: Fully Automated

To enable full automation in the future:

1. **Setup SendGrid API**:
   ```bash
   export SENDGRID_API_KEY="your-api-key"
   ```

2. **Or use Cloud Functions**:
   - Upload APK triggers Cloud Function
   - Function sends email via SendGrid
   - No manual intervention needed

3. **Or integrate with CI/CD**:
   - GitHub Actions on push to main
   - Automatically builds and distributes
   - Sends notifications

---

## Quick Commands Summary

```bash
# 1. Re-auth
gcloud auth login

# 2. Upload
VERSION=$(date +%Y%m%d-%H%M%S)
gsutil cp /Users/djgupt/Development/360/remote-inventory/provider_app/build/app/outputs/flutter-apk/app-release.apk \
  gs://remote-inventory-apks/jarvis-remote-inventory-${VERSION}.apk

# 3. Make public
gsutil acl ch -u AllUsers:R gs://remote-inventory-apks/jarvis-remote-inventory-${VERSION}.apk

# 4. Get URL
echo "https://storage.googleapis.com/remote-inventory-apks/jarvis-remote-inventory-${VERSION}.apk"

# 5. Send email with URL to:
# - dgupt@360world.com
# - provider@360world.com
```
