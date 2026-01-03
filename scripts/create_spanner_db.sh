#!/bin/bash
# Create Spanner instance and database using gcloud CLI
set -e

echo "📚 Creating Spanner database..."

# Configuration
INSTANCE_NAME="remote-inventory-local"
DATABASE_NAME="remote-inventory"
CONFIG="emulator-config"
SCHEMA_FILE="$(dirname "$0")/../backend-python/db/schema.sql"
PROJECT="test-project"

# Set emulator environment
export SPANNER_EMULATOR_HOST="localhost:9010"

# Create instance
echo "📦 Creating instance '$INSTANCE_NAME'..."
gcloud spanner instances create $INSTANCE_NAME \
    --project=$PROJECT \
    --config=$CONFIG \
    --description="Local development instance" \
    --nodes=1 \
    --processing-units=100 2>&1 || echo "⚠️  Instance may already exist"

sleep 2

# Create database with schema
echo "📚 Creating database '$DATABASE_NAME' with schema..."
gcloud spanner databases create $DATABASE_NAME \
    --project=$PROJECT \
    --instance=$INSTANCE_NAME \
    --ddl-file=$SCHEMA_FILE

echo ""
echo "============================================"
echo "✅ Database Created Successfully!"
echo "============================================"
echo "Instance: $INSTANCE_NAME"
echo "Database: $DATABASE_NAME"
echo "Tables: users, devices, sessions, webrtc_signals"
echo ""
echo "Test query:"
echo "  gcloud spanner databases execute-sql $DATABASE_NAME \\"
echo "    --instance=$INSTANCE_NAME \\"
echo "    --project=$PROJECT \\"
echo "    --sql=\"SELECT COUNT(*) as user_count FROM users\""
echo "============================================"
