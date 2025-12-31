# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Push to GitHub (IMPORTANT - Backup Your Work!)

```bash
# Create a new repository on GitHub first, then:
cd /Users/djgupt/Development/360/remote-inventory

# Add your GitHub remote (replace with your repo URL)
git remote add origin https://github.com/YOUR_USERNAME/remote-inventory.git

# Push to GitHub
git push -u origin main

# For subsequent commits:
git add .
git commit -m "Your commit message"
git push
```

### Step 2: Test Provider App Locally

```bash
cd provider_app

# Copy shared theme
mkdir -p lib/shared
cp -r ../shared/theme lib/shared/

# Get dependencies
flutter pub get

# Run on connected device or simulator
flutter run
```

**What to expect:**
- JARVIS-themed home screen with animated cyan logo
- Enter your name and tap "START SESSION"
- Grant camera permissions
- See live camera preview with session ID
- Test debug controls at bottom to simulate consumer commands

### Step 3: Test Consumer App Locally

```bash
cd consumer_app

# Copy shared theme
mkdir -p lib/shared
cp -r ../shared/theme lib/shared/

# Get dependencies  
flutter pub get

# Run on connected device or simulator
flutter run
```

**What to expect:**
- JARVIS-themed home screen with gamepad icon
- Enter your name and session ID from Provider
- See gaming controller interface
- Video feed placeholder with privacy indicators
- Test touch gestures on video area
- Try voice and text commands

### Step 4: Run Backend (Optional for Full Integration)

```bash
cd backend

# Install Go dependencies
go mod download

# Note: For now, protobuf generation requires protoc compiler
# Install protoc: https://grpc.io/docs/protoc-installation/

# Generate proto files
make proto

# Run server
make run
```

The server will start on `localhost:8080`.

## 🎮 Testing Touch Controls (Consumer App)

Once Consumer app is running:

1. **Swipe** on the video area:
   - Swipe left → "navigate left" command
   - Swipe right → "navigate right" command
   - Swipe up → "navigate up" command
   - Swipe down → "navigate down" command

2. **Pinch** on video area:
   - Pinch in → Zoom out
   - Pinch out → Zoom in
   - Watch zoom level indicator update

3. **Long Press** on video area:
   - Hold finger on screen → Red laser pointer appears
   - Move finger → Laser moves
   - Release → Laser deactivates

4. **Double Tap** video area:
   - Tap twice quickly → "STOP SENT" overlay appears
   - Emergency stop command sent

5. **Voice Command**:
   - Tap "Voice" button
   - Speak: "move left", "go right", etc.
   - Command appears in history

6. **Text Command**:
   - Type in text field: "left", "right", "up", etc.
   - Tap send or press enter

## 📱 Testing Provider App

Once Provider app is running:

1. Camera preview appears with privacy indicator
2. Session ID shown at top (e.g., "DEMO-SESSION")
3. Status shows "Connected" with green indicator
4. Test debug controls at bottom:
   - Tap ← → ↑ ↓ buttons
   - See animated directional arrows appear
   - Arrows have neon cyan glow effect
5. Tap ⏹ button:
   - See red "STOP" indicator with hand icon

## 🔧 Next Steps

### For Full Integration:

1. **Deploy Backend to Cloud Run** (see README.md)
2. **Update gRPC Endpoints** in both apps
3. **Test Real Consumer-Provider Session**
4. **Enable Actual Privacy Processing** (requires OpenCV setup)

### Current Status:

✅ UI fully functional with JARVIS theme
✅ Touch gestures working
✅ Voice/text input ready
✅ Provider guidance overlay working
✅ Git repository initialized
⏳ gRPC integration (backend endpoints to be connected)
⏳ OpenCV privacy layer (requires Haar Cascade file)

## 🎨 JARVIS Theme Features

Look for these design elements:
- **Cyan neon glow** on all interactive elements
- **Pulsing animations** on status indicators
- **Glassmorphism** effects on cards
- **Smooth transitions** between states
- **Haptic feedback** on all touch interactions
- **Material Design 3** components

## ⚠️ Important Notes

- **Privacy First**: Even with placeholder video, privacy layer architecture is in place
- **Regular Commits**: Run `git add . && git commit -m "message" && git push` often!
- **Mobile Testing**: Best experienced on physical devices for touch/voice
- **Permissions**: Grant camera (Provider) and microphone (Consumer) permissions

## 📞 Troubleshooting

**Flutter build issues?**
```bash
flutter clean
flutter pub get
flutter run
```

**Theme not found?**
```bash
# Ensure shared theme is copied
cp -r ../shared/theme lib/shared/
```

**Git issues?**
```bash
# Check status
git status

# See what's staged
git diff --cached
```

---

**Enjoy building with JARVIS! 🚀**
