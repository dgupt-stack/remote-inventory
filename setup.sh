#!/bin/bash

# Complete setup script for the Remote Inventory View App

set -e

echo "🚀 Remote Inventory View App - Complete Setup"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check dependencies
echo -e "${BLUE}Step 1: Checking dependencies...${NC}"

if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first:"
    echo "   https://docs.flutter.dev/get-started/install"
    exit 1
fi
echo "✅ Flutter found"

if ! command -v go &> /dev/null; then
    echo "⚠️  Go not found. Backend development will be limited."
else
    echo "✅ Go found"
fi

if ! command -v protoc &> /dev/null; then
    echo "⚠️  protoc not found. Protobuf generation will be skipped."
    echo "   Install with: brew install protobuf"
else
    echo "✅ protoc found"
fi

echo ""

# Step 2: Setup Provider App
echo -e "${BLUE}Step 2: Setting up Provider App...${NC}"
cd provider_app

echo "  📦 Installing dependencies..."
flutter pub get > /dev/null 2>&1

echo "  📁 Copying shared theme..."
mkdir -p lib/shared
cp -r ../shared/theme lib/shared/

echo "  ✅ Provider App ready"
cd ..

echo ""

# Step 3: Setup Consumer App
echo -e "${BLUE}Step 3: Setting up Consumer App...${NC}"
cd consumer_app

echo "  📦 Installing dependencies..."
flutter pub get > /dev/null 2>&1

echo "  📁 Copying shared theme..."
mkdir -p lib/shared
cp -r ../shared/theme lib/shared/

echo "  ✅ Consumer App ready"
cd ..

echo ""

# Step 4: Generate protobuf code (if protoc available)
if command -v protoc &> /dev/null; then
    echo -e "${BLUE}Step 4: Generating protobuf code...${NC}"
    
    if command -v protoc-gen-dart &> /dev/null; then
        ./scripts/generate_proto_dart.sh
    else
        echo "  ⚠️  protoc-gen-dart not found. Installing..."
        dart pub global activate protoc_plugin
        ./scripts/generate_proto_dart.sh
    fi
else
    echo -e "${YELLOW}Step 4: Skipping protobuf generation (protoc not found)${NC}"
fi

echo ""

# Step 5: Backend setup (if Go available)
if command -v go &> /dev/null; then
    echo -e "${BLUE}Step 5: Setting up Backend...${NC}"
    cd backend
    
    echo "  📦 Downloading Go dependencies..."
    go mod download > /dev/null 2>&1
    
    echo "  ✅ Backend dependencies ready"
    cd ..
else
    echo -e "${YELLOW}Step 5: Skipping backend setup (Go not found)${NC}"
fi

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1️⃣  Run Provider App:"
echo "   cd provider_app && flutter run"
echo ""
echo "2️⃣  Run Consumer App (in another terminal):"
echo "   cd consumer_app && flutter run"
echo ""
echo "3️⃣  Run Backend (optional, for full integration):"
echo "   cd backend && make run"
echo ""
echo "📚 Documentation:"
echo "   README.md - Full project overview"
echo "   QUICKSTART.md - Quick start guide"
echo ""
echo "🔗 Repository: https://github.com/dgupt-stack/remote-inventory"
echo ""
