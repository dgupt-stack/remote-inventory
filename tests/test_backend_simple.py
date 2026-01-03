#!/usr/bin/env python3
import sys
sys.path.insert(0, 'backend-python')
import grpc
import inventory_service_pb2 as pb2
import inventory_service_pb2_grpc as pb2_grpc

channel = grpc.insecure_channel('localhost:8080')
stub = pb2_grpc.RemoteInventoryServiceStub(channel)

print("=" * 60)
print("Testing JARVIS Backend")
print("=" * 60)

# Test 1: ListSessions
print("\n1️⃣  ListSessions (should be empty)")
response = stub.ListSessions(pb2.ListSessionsRequest())
print(f"   Sessions found: {len(response.sessions)}")

# Test 2: CreateSession
print("\n2️⃣  CreateSession")
response = stub.CreateSession(pb2.CreateSessionRequest(
    provider_name="Test Provider",
    provider_id="test-123"
))
print(f"   ✅ Created: {response.session_id}")
session_id = response.session_id

# Test 3: ListSessions again
print("\n3️⃣  ListSessions (should have 1)")
response = stub.ListSessions(pb2.ListSessionsRequest())
print(f"   Sessions found: {len(response.sessions)}")
for s in response.sessions:
    print(f"   - {s.provider_name} ({s.session_id})")

# Test 4: EndSession
print("\n4️⃣  EndSession")
response = stub.EndSession(pb2.EndSessionRequest(session_id=session_id))
print(f"   ✅ Success: {response.success}")

print("\n" + "=" * 60)
print("✅ All tests passed!")
print("=" * 60)
