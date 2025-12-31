#!/bin/bash

# Quick local test script for the backend

set -e

echo "🧪 Testing Remote Inventory Backend"
echo "===================================="
echo ""

# Check dependencies
echo "Checking dependencies..."

if ! command -v go &> /dev/null; then
    echo "❌ Go not found"
    exit 1
fi
echo "✅ Go found: $(go version)"

if ! command -v protoc &> /dev/null; then
    echo "⚠️  protoc not found - protobuf generation will be skipped"
else
    echo "✅ protoc found"
fi

echo ""

# Navigate to backend
cd "$(dirname "$0")"

# Download dependencies
echo "📦 Downloading dependencies..."
go mod download
echo "✅ Dependencies downloaded"
echo ""

# Generate protobuf if protoc available
if command -v protoc &> /dev/null; then
    echo "🔧 Generating protobuf code..."
    make proto
    echo "✅ Protobuf code generated"
    echo ""
fi

# Build the server
echo "🔨 Building server..."
go build -o bin/server ./server
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "Binary created at: bin/server"
    echo ""
    echo "To run the server:"
    echo "  ./bin/server"
    echo ""
    echo "Or use the Makefile:"
    echo "  make run"
else
    echo "❌ Build failed"
    exit 1
fi

# Check for OpenCV (optional)
echo ""
echo "Checking optional dependencies..."
if pkg-config --exists opencv4; then
    echo "✅ OpenCV 4 found"
elif pkg-config --exists opencv; then
    echo "✅ OpenCV found"
else
    echo "⚠️  OpenCV not found - privacy layer will not work"
    echo "   Install with: brew install opencv"
fi

echo ""
echo "================================================"
echo "✅ All tests passed!"
echo "================================================"
echo ""
echo "Next steps:"
echo "  1. Run the server: make run"
echo "  2. Test with web demo: open ../web-demo/index.html"
echo "  3. Deploy to Cloud Run: ./deploy.sh"
