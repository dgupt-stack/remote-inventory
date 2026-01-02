# 🎯 Single Dual-Mode App - Simplified Firebase Setup

## Overview

We're now using **ONE app** that can function as both Consumer and Provider!

**Benefits**:
- ✅ Only 1 Firebase configuration needed
- ✅ Simpler deployment
- ✅ Reduced infrastructure costs
- ✅ Better user experience

---

## Firebase Setup (10 minutes)

### Step 1: Register ONE App in Firebase

**URL**: https://console.firebase.google.com/project/remote-vision-6f76a/settings/general

1. Click "Add app" → Android icon
2. **Android package name**: `com.example.consumer_app`
3. **App nickname**: `JARVIS Remote Inventory`
4. Click "Register app"
5. **Download** `google-services.json`

### Step 2: Extract Values

Open `google-services.json` and find:
- `apiKey`: From `client[0].api_key[0].current_key`
- `appId`: From `client[0].client_info.mobilesdk_app_id`
- `messagingSenderId`: From `project_info.project_number`

### Step 3: Update firebase_options.dart

**File**: `consumer_app/lib/firebase_options.dart`

Replace Android section:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_HERE',
  appId: 'YOUR_APP_ID_HERE',
  messagingSenderId: 'YOUR_SENDER_ID_HERE',
  projectId: 'remote-vision-6f76a',
  storageBucket: 'remote-vision-6f76a.appspot.com',
);
```

### Step 4: Add google-services.json

```bash
cp ~/Downloads/google-services.json consumer_app/android/app/
```

### Step 5: Enable Phone Auth

**URL**: https://console.firebase.google.com/project/remote-vision-6f76a/authentication/providers

- Click "Phone" → Toggle Enable → Save

---

## Build Single APK

```bash
cd consumer_app
flutter build apk --release
```

APK location: `consumer_app/build/app/outputs/flutter-apk/app-release.apk`

---

## How It Works

### 1. User Opens App
→ Phone authentication screen

### 2. After Login
→ **Mode Selector Screen** with 2 options:
- **Consumer Mode**: View and control sessions
- **Provider Mode**: Share camera and receive commands

### 3. User Picks Mode
→ Navigates to appropriate screen

### 4. Switch Modes
→ Use FAB button to switch anytime

---

## Testing

1. Install APK on device
2. Sign in with phone
3. See mode selector
4. Test both modes:
   - Consumer: Session list works
   - Provider: Camera works
5. Switch between modes with FAB

---

## Cost Savings

**Before** (2 separate apps):
- 2 Firebase configurations
- 2 APKs to maintain
- Duplicate infrastructure

**After** (1 dual-mode app):
- ✅ 1 Firebase configuration
- ✅ 1 APK
- ✅ Shared infrastructure
- ✅ Easier updates

---

**That's it!** One app, two modes, much simpler! 🎉
