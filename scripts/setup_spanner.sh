#!/bin/bash
# Setup Cloud Spanner using Docker (simpler than gcloud emulator)
set -e

echo "🚀 Setting up Cloud Spanner with Docker..."

# Configuration
CONTAINER_NAME="spanner-emulator"
PORT=9010
IMAGE="gcr.io/cloud-spanner-emulator/emulator:latest"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Check if container already exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "📦 Container '$CONTAINER_NAME' already exists"
    
    # Check if it's running
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "✅ Spanner emulator already running"
    else
        echo "▶️  Starting existing container..."
        docker start $CONTAINER_NAME
        sleep 3
        echo "✅ Spanner emulator started"
    fi
else
    echo "📥 Pulling Spanner emulator image..."
    docker pull $IMAGE
    
    echo "🚀 Starting Spanner emulator container..."
    docker run -d -p ${PORT}:9010 \
        --name $CONTAINER_NAME \
        $IMAGE
    
    sleep 5
    echo "✅ Spanner emulator started"
fi

# Export environment variable
export SPANNER_EMULATOR_HOST="localhost:${PORT}"

echo ""
echo "============================================"
echo "✅ Spanner Emulator Running!"
echo "============================================"
echo "Container: $CONTAINER_NAME"
echo "Port: $PORT"
echo "Host: localhost:$PORT"
echo ""
echo "Environment variable:"
echo "export SPANNER_EMULATOR_HOST=\"localhost:$PORT\""
echo ""
echo "Commands:"
echo "  Stop:    docker stop $CONTAINER_NAME"
echo "  Start:   docker start $CONTAINER_NAME"
echo "  Logs:    docker logs $CONTAINER_NAME"
echo "  Remove:  docker rm -f $CONTAINER_NAME"
echo "============================================"
echo ""
echo "⏭️  Next step: Run ./scripts/create_spanner_db.sh"
