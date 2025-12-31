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
mkdir -p provider_app/lib/generated
mkdir -p consumer_app/lib/generated

# Generate Dart code
protoc --dart_out=grpc:provider_app/lib/generated \
    -Iproto proto/inventory_service.proto

protoc --dart_out=grpc:consumer_app/lib/generated \
    -Iproto proto/inventory_service.proto

echo "✅ Dart protobuf code generated successfully!"
echo "   Provider: provider_app/lib/generated/"
echo "   Consumer: consumer_app/lib/generated/"
