#!/bin/bash

# Setup script to download Google API protos for gRPC-Gateway

echo "📦 Downloading Google API protobuf definitions..."

# Create googleapis directory if it doesn't exist
mkdir -p googleapis/google/api

# Download required proto files
curl -sL https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/annotations.proto \
  -o googleapis/google/api/annotations.proto

curl -sL https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/http.proto \
  -o googleapis/google/api/http.proto

echo "✅ Google API protos downloaded successfully"
echo ""
echo "You can now run: make proto"
