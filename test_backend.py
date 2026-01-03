#!/usr/bin/env python3
"""
Backend Functionality Test Suite
Tests all gRPC endpoints to verify backend is working correctly
"""

import sys
import grpc

# Add backend-python to path
sys.path.insert(0, 'backend-python')

import inventory_service_pb2 as pb2
import inventory_service_pb2_grpc as pb2_grpc


def test_connection(address):
    """Test if we can connect to the server"""
    try:
        channel = grpc.insecure_channel(address, options=[
            ('grpc.keepalive_time_ms', 10000),
            ('grpc.keepalive_timeout_ms', 5000),
        ])
        grpc.channel_ready_future(channel).result(timeout=5)
        return True, channel
    except Exception as e:
        return False, str(e)


def test_list_sessions(stub):
    """Test ListSessions RPC"""
    try:
        request = pb2.ListSessionsRequest(search_query="")
        response = stub.ListSessions(request)
        return True, f"Found {len(response.sessions)} sessions", response.sessions
    except Exception as e:
        return False, str(e), None


def test_create_session(stub):
    """Test CreateSession RPC"""
    try:
        request = pb2.CreateSessionRequest(
            provider_name="Test Provider",
            location="Test Location"
        )
        response = stub.CreateSession(request)
        if response.success:
            return True, f"Created session: {response.session_id}", response.session_id
        else:
            return False, response.message, None
    except Exception as e:
        return False, str(e), None


def test_end_session(stub, session_id):
    """Test EndSession RPC"""
    try:
        request = pb2.EndSessionRequest(session_id=session_id)
        response = stub.EndSession(request)
        return response.success, "Session ended" if response.success else "Failed to end session"
    except Exception as e:
        return False, str(e)


def run_tests():
    """Run all backend tests"""
    
    print("=" * 60)
    print("🧪 JARVIS Backend Functionality Test")
    print("=" * 60)
    print()
    
    # Test both localhost and network IP
    addresses = [
        ("localhost:8080", "Localhost"),
        ("192.168.86.89:8080", "Network IP")
    ]
    
    for address, name in addresses:
        print(f"📡 Testing {name} ({address})")
        print("-" * 60)
        
        # Test 1: Connection
        success, result = test_connection(address)
        if not success:
            print(f"  ❌ Connection failed: {result}")
            print()
            continue
        
        print(f"  ✅ Connection successful")
        channel = result
        stub = pb2_grpc.RemoteInventoryServiceStub(channel)
        
        # Test 2: ListSessions (should be empty initially)
        success, message, sessions = test_list_sessions(stub)
        if success:
            print(f"  ✅ ListSessions: {message}")
        else:
            print(f"  ❌ ListSessions failed: {message}")
            channel.close()
            print()
            continue
        
        # Test 3: CreateSession
        success, message, session_id = test_create_session(stub)
        if success:
            print(f"  ✅ CreateSession: {message}")
        else:
            print(f"  ❌ CreateSession failed: {message}")
            channel.close()
            print()
            continue
        
        # Test 4: ListSessions again (should now have 1 session)
        success, message, sessions = test_list_sessions(stub)
        if success:
            print(f"  ✅ ListSessions (after create): {message}")
            if len(sessions) > 0:
                session = sessions[0]
                print(f"      - Provider: {session.provider_name}")
                print(f"      - Location: {session.provider_location}")
                print(f"      - Session ID: {session.session_id}")
        else:
            print(f"  ❌ ListSessions failed: {message}")
        
        # Test 5: EndSession
        if session_id:
            success, message = test_end_session(stub, session_id)
            if success:
                print(f"  ✅ EndSession: {message}")
            else:
                print(f"  ❌ EndSession failed: {message}")
        
        # Test 6: ListSessions final (should be empty again)
        success, message, sessions = test_list_sessions(stub)
        if success:
            print(f"  ✅ ListSessions (after delete): {message}")
        
        channel.close()
        print()
    
    print("=" * 60)
    print("✅ Backend functionality tests complete!")
    print("=" * 60)


if __name__ == "__main__":
    run_tests()
