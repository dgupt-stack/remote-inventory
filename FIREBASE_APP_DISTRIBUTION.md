# Firebase App Distribution - Complete Setup Guide

## Current Status
✅ Firebase CLI installed and authenticated as dgupt@360world.com  
⏳ Need to create Android app in Firebase  
⏳ Then upload APK via CLI  

---

## Step-by-Step Setup (5 minutes)

### Step 1: Create Android App in Firebase Console

1. **Open this link** (will auto-select correct project):
   ```
   https://console.firebase.google.com/project/remote-vision-6f76a/settings/general
   ```

2. **Add Android App**:
   - Scroll to "Your apps" section
   - Click "Add app" → Select Android icon (🤖)
   
3. **Register App**:
   - Package name: `com.example.provider_app`
   - App nickname (optional): `JARVIS Remote Inventory`
   - Click "Register app"

4. **Download google-services.json**:
   - Download the file
   - Place it here:
     ```bash
     cp ~/Downloads/google-services.json provider_app/android/app/
     ```

5. **Copy App ID**:
   - From the Firebase Console, copy the "App ID"
   - It looks like: `1:344355586136:android:xxxxxxxxxxxxx`
   - Or extract from google-services.json:
     ```bash
     grep mobilesdk_app_id provider_app/android/app/google-services.json
     ```

### Step 2: Deploy to Firebase App Distribution

Once you have the App ID:

```bash
# Set the App ID
export FIREBASE_APP_ID='1:344355586136:android:xxxxxxxxxxxxx'

# Run deployment
./deploy-firebase.sh
```

Done! Testers will get an email from Firebase with a download link.

---

## Alternative: Manual Upload (If CLI fails)

1. **Build APK** (if not already built):
   ```bash
   cd provider_app
   flutter build apk --release
   cd ..
   ```

2. **Go to App Distribution Console**:
   ```
   https://console.firebase.google.com/project/remote-vision-6f76a/appdistribution
   ```

3. **Upload APK**:
   - Click "Get started" (if first time)
   - Click "New release"
   - Upload: `provider_app/build/app/outputs/flutter-apk/app-release.apk`
   - Add testers: `dgupt@360world.com, provider@360world.com`
   - Release notes: "Unified Provider + Consumer App"
   - Click "Distribute"

---

## After Setup: Future Deployments

Once set up, future deployments are one command:

```bash
./deploy-firebase.sh
```

This will:
1. Build the APK
2. Upload to Firebase
3. Notify all testers automatically

---

## Why Firebase App Distribution?

✅ **Testers get automatic emails** from Firebase  
✅ **One-click installation** via Firebase App Distribution app  
✅ **Version tracking** - see all builds in console  
✅ **Never gets blocked** - it's Google's official service  
✅ **Tester management** - add/remove easily  
✅ **Release notes** - include what's new  

---

## Quick Commands Reference

```bash
# Check if logged in
firebase projects:list

# List apps
firebase apps:list --project remote-vision-6f76a

# Deploy (after setup)
./deploy-firebase.sh

# Or manually
firebase appdistribution:distribute \
  provider_app/build/app/outputs/flutter-apk/app-release.apk \
  --app $FIREBASE_APP_ID \
  --testers "dgupt@360world.com,provider@360world.com" \
  --release-notes "New build"
```

---

## Current Workaround

Until Firebase App Distribution is set up, use the simple GCS script:

```bash
./deploy-simple.sh
```

This uploads to GCS and copies the download link to your clipboard for easy sharing.
