# Firebase App Distribution Setup

## Why Firebase App Distribution?

✅ **Purpose-built** for mobile app testing  
✅ **Won't get blocked** - Google's official distribution service  
✅ **Automatic notifications** - Testers get emails automatically  
✅ **Easy installation** - One-click install from email  
✅ **Version tracking** - See all builds in Firebase Console  
✅ **Tester management** - Add/remove testers easily  

---

## Quick Setup (5 minutes)

### 1. Install Firebase CLI

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Get Firebase App ID

**Option A: From Firebase Console**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project (events-360world)
3. Click ⚙️ Settings → Project settings
4. Under "Your apps" → Android app
5. Copy the App ID (format: `1:xxxx:android:xxxx`)

**Option B: From google-services.json**
```bash
# If you have google-services.json in provider_app/android/app/
grep mobilesdk_app_id provider_app/android/app/google-services.json
```

### 4. Set App ID

```bash
export FIREBASE_APP_ID='1:xxxxx:android:xxxxx'

# Or add to ~/.zshrc for persistence
echo 'export FIREBASE_APP_ID="your-app-id"' >> ~/.zshrc
```

### 5. Deploy

```bash
./deploy-firebase.sh
```

Done! Testers will get email from Firebase with download link.

---

## How It Works

1. **Script builds** APK
2. **Uploads to Firebase** App Distribution
3. **Firebase sends** email to testers automatically
4. **Testers download** via:
   - Direct link in email
   - Firebase App Distribution app (recommended)
   - Web browser

---

## Adding/Removing Testers

### Via Script
Edit `deploy-firebase.sh`:
```bash
TESTER_EMAILS="dgupt@360world.com,provider@360world.com,new@email.com"
```

### Via Firebase Console
1. Go to [App Distribution](https://console.firebase.google.com/project/_/appdistribution)
2. Click "Testers & Groups"
3. Add email addresses
4. Create groups (e.g., "testers", "beta", "internal")

---

## Testers: How to Install

### First Time Setup

1. **Receive email** from Firebase App Distribution
2. **Click link** in email
3. **Install Firebase App Distribution app** (if prompted)
4. **Download and install** the APK

### Future Updates

1. **Get notification** in Firebase app when new build available
2. **One-click update** to latest version

---

## View All Builds

```bash
# Open Firebase Console
open https://console.firebase.google.com/project/_/appdistribution
```

Or via CLI:
```bash
firebase appdistribution:releases:list --app ${FIREBASE_APP_ID}
```

---

## Troubleshooting

### "App ID not found"

Check your Firebase App ID:
```bash
echo $FIREBASE_APP_ID
```

Get it from Console or google-services.json.

### "Permission denied"

```bash
# Re-login
firebase login --reauth
```

### "Testers not receiving emails"

1. Check spam folder
2. Verify email addresses in Firebase Console
3. Ensure testers are in "testers" group

---

## Comparison to Previous Method

| Feature | GCS + Email | Firebase App Distribution |
|---------|-------------|---------------------------|
| Email delivery | ⚠️ Often blocked | ✅ Reliable |
| Installation | Manual APK install | ✅ One-click |
| Version tracking | Manual | ✅ Automatic |
| Tester management | Manual | ✅ Built-in |
| Notifications | Manual | ✅ Automatic |
| Download blocks | ⚠️ Possible | ✅ Never blocked |

---

## Going Forward

Use this as your standard deployment:

```bash
./deploy-firebase.sh
```

Testers get automatic emails and one-click updates. No more blocked downloads!
