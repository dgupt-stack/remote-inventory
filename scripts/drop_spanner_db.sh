#!/bin/bash
# Drop and recreate Spanner database (for development/testing)
set -e

INSTANCE_NAME="remote-inventory-local"
DATABASE_NAME="remote-inventory"
SCHEMA_FILE="$(dirname "$0")/../backend-python/db/schema.sql"

export SPANNER_EMULATOR_HOST="localhost:9010"

echo "🗑️  Dropping database '$DATABASE_NAME'..."
gcloud spanner databases delete $DATABASE_NAME \
    --instance=$INSTANCE_NAME \
    --project=test-project \
    --quiet

echo "📚 Recreating database '$DATABASE_NAME'..."
gcloud spanner databases create $DATABASE_NAME \
    --project=test-project \
    --instance=$INSTANCE_NAME \
    --ddl-file=$SCHEMA_FILE

echo "✅ Database recreated successfully!"
