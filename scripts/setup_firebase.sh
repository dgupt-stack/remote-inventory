#!/bin/bash

# Firebase Setup Script for Remote Inventory Apps
# Run this script to configure Firebase for both Provider and Consumer apps

set -e

echo "🔥 Firebase Setup for Remote Inventory Apps"
echo "============================================"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found. Installing..."
    npm install -g firebase-tools
    echo "✅ Firebase CLI installed"
fi

# Check if FlutterFire CLI is installed
if ! command -v flutterfire &> /dev/null; then
    echo "❌ FlutterFire CLI not found. Installing..."
    dart pub global activate flutterfire_cli
    echo "✅ FlutterFire CLI installed"
fi

echo ""
echo "📋 Manual Steps Required:"
echo ""
echo "1. Create Firebase Project (if not exists):"
echo "   - Go to https://console.firebase.google.com/"
echo "   - Create project 'remote-inventory'"
echo "   - Enable Google Analytics (optional)"
echo ""
echo "2. Enable Authentication Methods:"
echo "   - Go to Authentication > Sign-in method"
echo "   - Enable: Phone, Google, Apple (optional), Email/Password"
echo ""
echo "3. Configure Phone Authentication:"
echo "   - Add test phone numbers (for development)"
echo "   - Set up reCAPTCHA (for web, optional)"
echo ""
echo "4. Run FlutterFire Configure:"
echo "   cd provider_app && flutterfire configure"
echo "   cd consumer_app && flutterfire configure"
echo ""
echo "5. Add SHA-1 fingerprints (for Android):"
echo "   Get debug SHA-1:"
echo "   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android"
echo ""
echo "   Add to Firebase Console > Project Settings > Your apps > Android app"
echo ""

# Check if user wants to continue with auto-config
read -p "Have you completed the manual steps? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please complete the manual steps first, then run this script again."
    exit 1
fi

echo ""
echo "🚀 Configuring apps..."
echo ""

# Configure Provider App
echo "📱 Configuring Provider App..."
cd provider_app
flutterfire configure --project=remote-inventory
echo "✅ Provider app configured"
cd ..

# Configure Consumer App
echo "📱 Configuring Consumer App..."
cd consumer_app
flutterfire configure --project=remote-inventory
echo "✅ Consumer app configured"
cd ..

echo ""
echo "✅ Firebase setup complete!"
echo ""
echo "Next steps:"
echo "1. Add Firebase dependencies to pubspec.yaml"
echo "2. Initialize Firebase in main.dart"
echo "3. Create auth screens"
echo "4. Test authentication flow"
echo ""
