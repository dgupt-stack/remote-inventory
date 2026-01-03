#!/usr/bin/env python3
"""Test Spanner connection and schema"""

import os
from google.cloud import spanner

# Set emulator host
os.environ['SPANNER_EMULATOR_HOST'] = 'localhost:9010'

print("🧪 Testing Spanner Connection...")
print("=" * 60)

try:
    # Create client
    client = spanner.Client(project='test-project')
    instance = client.instance('remote-inventory-local')
    database = instance.database('remote-inventory')
    
    print("✅ Connected to Spanner emulator")
    print(f"   Instance: {instance.instance_id}")
    print(f"   Database: {database.database_id}")
    print()
    
    # Test query: List tables
    print("📋 Tables in database:")
    with database.snapshot() as snapshot:
        results = snapshot.execute_sql(
            "SELECT table_name FROM information_schema.tables "
            "WHERE table_schema = '' "
            "ORDER BY table_name"
        )
        for row in results:
            print(f"   ✓ {row[0]}")
    print()
    
    # Test insert: Create a test user
    print("👤 Creating test user...")
    with database.batch() as batch:
        batch.insert(
            table='users',
            columns=['user_id', 'display_name', 'created_at'],
            values=[('test-user-001', 'Test User', spanner.COMMIT_TIMESTAMP)]
        )
    print("✅ Test user created")
    print()
    
    # Test query: Read users
    print("📖 Reading users:")
    with database.snapshot() as snapshot:
        results = snapshot.execute_sql("SELECT user_id, display_name FROM users")
        for row in results:
            print(f"   → {row[1]} (ID: {row[0]})")
    print()
    
    print("=" * 60)
    print("✅ All tests passed!")
    print("=" * 60)
    
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
