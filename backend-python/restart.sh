#!/bin/bash

# Backend restart script
# Stops any running backend and starts a fresh one

cd "$(dirname "$0")"

echo "🔄 Restarting JARVIS Backend..."

# Kill any existing backend process
if [ -f server.pid ]; then
    OLD_PID=$(cat server.pid)
    if ps -p $OLD_PID > /dev/null 2>&1; then
        echo "Stopping old backend (PID: $OLD_PID)..."
        kill $OLD_PID
        sleep 2
    fi
    rm server.pid
fi

# Start new backend
echo "🚀 Starting backend..."
python3 server.py &
NEW_PID=$!
echo $NEW_PID > server.pid

echo "✅ Backend started (PID: $NEW_PID)"
echo "📡 Listening on 192.168.86.89:8080"
echo ""
echo "To view logs: tail -f server.log"
echo "To stop: kill \$(cat server.pid)"
