# Manual Firebase Configuration Guide

Since Firebase CLI installation is in progress, here's how to configure manually:

## Option 1: Use Firebase Console (Recommended - 5 minutes)

### Step 1: Enable Authentication Methods
1. Go to https://console.firebase.google.com/project/remote-vision-6f76a
2. Click "Authentication" in left sidebar
3. Click "Get Started" or "Sign-in method" tab
4. Enable these providers:
   - **Phone** (click, toggle Enable, Save)
   - **Google** (click, toggle Enable, Save)
   - **Email/Password** (optional for fallback)

### Step 2: Register Android Apps
1. In Firebase Console, click "Project Settings" (gear icon)
2. Under "Your apps", click "Add app" → Android icon
3. **For Consumer App**:
   - Android package name: `com.example.consumer_app`
   - App nickname: `Consumer App`
   - Click "Register app"
   - Download `google-services.json`
   - Move to: `consumer_app/android/app/google-services.json`

4. **For Provider App**:
   - Repeat above with package: `com.example.provider_app`
   - App nickname: `Provider App`
   - Move to: `provider_app/android/app/google-services.json`

### Step 3: Update Android Build Files

**consumer_app/android/build.gradle** (project level):
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**consumer_app/android/app/build.gradle** (app level):
```gradle
// At the bottom of the file, add:
apply plugin: 'com.google.gms.google-services'
```

Repeat for provider_app.

### Step 4: Create firebase_options.dart Files

**consumer_app/lib/firebase_options.dart**:
```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not supported');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',  // From google-services.json
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'remote-vision-6f76a',
    storageBucket: 'remote-vision-6f76a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'remote-vision-6f76a',
    storageBucket: 'remote-vision-6f76a.appspot.com',
    iosBundleId: 'com.example.consumerApp',
  );
}
```

Copy and modify for provider_app.

### Step 5: Update main.dart

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## Option 2: Wait for Firebase CLI (Automated)

The Firebase CLI is currently installing. Once complete:

```bash
# Login to Firebase
firebase login

# Configure Consumer app
cd consumer_app
flutterfire configure --project=remote-vision-6f76a

# Configure Provider app
cd ../provider_app
flutterfire configure --project=remote-vision-6f76a
```

---

## Testing

After configuration:
1. Enable phone auth in Firebase Console
2. Add test phone number (optional):
   - Authentication → Sign-in method → Phone → Test phone numbers
   - Add: `+1 650-555-1234` with code `123456`
3. Build and test APKs

---

**Recommendation**: Use Option 1 (manual) for now since it's faster. The CLI will be ready for future updates.
