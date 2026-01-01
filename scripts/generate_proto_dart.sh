#!/bin/bash

# Script to generate Dart protobuf code from .proto files

set -e

echo "🔧 Generating Dart protobuf code..."

# Check if protoc is installed
if ! command -v protoc &> /dev/null; then
    echo "❌ protoc not found. Please install Protocol Buffers compiler:"
    echo "   brew install protobuf"
    exit 1
fi

# Check if protoc-gen-dart is installed
if ! command -v protoc-gen-dart &> /dev/null; then
    echo "❌ protoc-gen-dart not found. Installing..."
    dart pub global activate protoc_plugin
    echo "✅ protoc-gen-dart installed"
fi

# Create output directories
mkdir -p provider_app/lib/proto
mkdir -p consumer_app/lib/proto

# Generate for provider app
cd proto && protoc \
  --dart_out=grpc:../provider_app/lib/proto \
  -I. \
  -I../backend/googleapis \
  inventory_service.proto

# Generate for consumer app
protoc \
  --dart_out=grpc:../consumer_app/lib/proto \
  -I. \
  -I../backend/googleapis \
  inventory_service.proto

cd ..

echo "✅ Dart protobuf generation complete!"
echo "📁 Provider: provider_app/lib/proto/"
echo "📁 Consumer: consumer_app/lib/proto/"
