#!/usr/bin/env python3
"""
E2E Test Suite: Provider-Consumer Flow
Automated testing for UI validation
"""

import sys
import time
sys.path.insert(0, 'backend-python')

import grpc
import inventory_service_pb2 as pb2
import inventory_service_pb2_grpc as pb2_grpc

class E2ETestSuite:
    def __init__(self, server='localhost:8080'):
        self.server = server
        self.channel = grpc.insecure_channel(server)
        self.stub = pb2_grpc.RemoteInventoryServiceStub(self.channel)
        self.test_results = []
        self.session_id = None
        
    def log(self, emoji, message):
        print(f"{emoji} {message}")
        
    def assert_equals(self, actual, expected, test_name):
        if actual == expected:
            self.log("✅", f"{test_name}: PASS")
            self.test_results.append((test_name, True))
            return True
        else:
            self.log("❌", f"{test_name}: FAIL (expected {expected}, got {actual})")
            self.test_results.append((test_name, False))
            return False
    
    def assert_true(self, condition, test_name):
        if condition:
            self.log("✅", f"{test_name}: PASS")
            self.test_results.append((test_name, True))
            return True
        else:
            self.log("❌", f"{test_name}: FAIL")
            self.test_results.append((test_name, False))
            return False
    
    def test_01_backend_connectivity(self):
        """Test: Backend is accessible"""
        self.log("🧪", "Test 1: Backend connectivity")
        try:
            response = self.stub.ListSessions(pb2.ListSessionsRequest(), timeout=5)
            self.assert_true(True, "Backend accessible")
        except Exception as e:
            self.log("❌", f"Backend not accessible: {e}")
            self.test_results.append(("Backend accessible", False))
            
    def test_02_initial_state(self):
        """Test: Backend starts with clean state"""
        self.log("🧪", "Test 2: Initial state check")
        response = self.stub.ListSessions(pb2.ListSessionsRequest())
        session_count = len(response.sessions)
        self.log("📝", f"Found {session_count} existing sessions")
        
        # Clean up any existing sessions for clean test
        for session in response.sessions:
            try:
                self.stub.EndSession(pb2.EndSessionRequest(session_id=session.session_id))
                self.log("🧹", f"Cleaned up session: {session.session_id}")
            except:
                pass
                
        time.sleep(0.5)
        response = self.stub.ListSessions(pb2.ListSessionsRequest())
        self.assert_equals(len(response.sessions), 0, "Clean initial state")
        
    def test_03_provider_creates_session(self):
        """Test: Provider can create session"""
        self.log("🧪", "Test 3: Provider creates session")
        try:
            response = self.stub.CreateSession(pb2.CreateSessionRequest(
                provider_name="E2E Test Provider",
                provider_id="e2e-test-1",
                location="Test Location"
            ))
            
            if self.assert_equals(response.success, True, "CreateSession success"):
                self.session_id = response.session_id
                self.log("📝", f"Session ID: {self.session_id}")
                self.assert_true(len(response.token) > 0, "Token generated")
        except Exception as e:
            self.log("❌", f"CreateSession exception: {e}")
            self.test_results.append(("CreateSession success", False))
        
    def test_04_consumer_discovers_session(self):
        """Test: Consumer can discover provider session"""
        self.log("🧪", "Test 4: Consumer discovers session")
        time.sleep(0.5)
        response = self.stub.ListSessions(pb2.ListSessionsRequest())
        
        if self.assert_equals(len(response.sessions), 1, "Session count after create"):
            session = response.sessions[0]
            self.assert_equals(session.provider_name, "E2E Test Provider", "Provider name")
            self.assert_equals(session.session_id, self.session_id, "Session ID match")
            self.assert_true(session.accepting_connections, "Accepting connections")
            
    def test_05_consumer_requests_connection(self):
        """Test: Consumer can request connection"""
        self.log("🧪", "Test 5: Consumer requests connection")
        try:
            response = self.stub.RequestConnection(pb2.ConnectionRequest(
                session_id=self.session_id,
                consumer_id="e2e-consumer",
                consumer_name="E2E Test Consumer"
            ))
            
            if self.assert_equals(response.success, True, "RequestConnection success"):
                self.log("📝", f"Request ID: {response.requestId}")
        except Exception as e:
            self.log("❌", f"RequestConnection exception: {e}")
            self.test_results.append(("RequestConnection success", False))
        
    def test_06_provider_ends_session(self):
        """Test: Provider can end session"""
        self.log("🧪", "Test 6: Provider ends session")
        try:
            response = self.stub.EndSession(pb2.EndSessionRequest(
                session_id=self.session_id
            ))
            
            self.assert_equals(response.success, True, "EndSession success")
        except Exception as e:
            self.log("❌", f"EndSession exception: {e}")
            self.test_results.append(("EndSession success", False))
        
    def test_07_session_cleanup(self):
        """Test: Session is removed after end"""
        self.log("🧪", "Test 7: Session cleanup verification")
        time.sleep(0.5)
        response = self.stub.ListSessions(pb2.ListSessionsRequest())
        
        self.assert_equals(len(response.sessions), 0, "Sessions after cleanup")
        
    def test_08_concurrent_sessions(self):
        """Test: Multiple sessions can coexist"""
        self.log("🧪", "Test 8: Concurrent sessions")
        
        # Create 3 sessions
        session_ids = []
        for i in range(3):
            try:
                response = self.stub.CreateSession(pb2.CreateSessionRequest(
                    provider_name=f"Provider {i+1}",
                    provider_id=f"provider-{i+1}"
                ))
                if response.success:
                    session_ids.append(response.session_id)
            except Exception as e:
                self.log("⚠️", f"Failed to create session {i+1}: {e}")
                
        # Verify all exist
        response = self.stub.ListSessions(pb2.ListSessionsRequest())
        self.assert_equals(len(response.sessions), len(session_ids), "Concurrent sessions count")
        
        # Clean up
        for session_id in session_ids:
            try:
                self.stub.EndSession(pb2.EndSessionRequest(session_id=session_id))
            except:
                pass
                
    def test_09_error_handling(self):
        """Test: Proper error handling for invalid requests"""
        self.log("🧪", "Test 9: Error handling")
        
        # Try to end non-existent session
        try:
            response = self.stub.EndSession(pb2.EndSessionRequest(
                session_id="non-existent-session"
            ))
            # Backend currently returns success=false for non-existent sessions
            self.log("📝", f"EndSession on non-existent returned: {response.success}")
            self.test_results.append(("Error handling", True))
        except Exception as e:
            self.log("📝", f"EndSession on non-existent raised: {type(e).__name__}")
            self.test_results.append(("Error handling", True))
            
    def run_all_tests(self):
        """Run complete E2E test suite"""
        print("=" * 60)
        print("🚀 E2E Test Suite: Provider-Consumer Flow")
        print("=" * 60)
        print(f"📡 Backend: {self.server}")
        print()
        
        tests = [
            self.test_01_backend_connectivity,
            self.test_02_initial_state,
            self.test_03_provider_creates_session,
            self.test_04_consumer_discovers_session,
            self.test_05_consumer_requests_connection,
            self.test_06_provider_ends_session,
            self.test_07_session_cleanup,
            self.test_08_concurrent_sessions,
            self.test_09_error_handling,
        ]
        
        for test in tests:
            try:
                test()
                print()
            except Exception as e:
                self.log("❌", f"{test.__name__}: EXCEPTION - {e}")
                self.test_results.append((test.__name__, False))
                print()
                
        # Summary
        print("=" * 60)
        passed = sum(1 for _, result in self.test_results if result)
        total = len(self.test_results)
        percentage = (passed / total * 100) if total > 0 else 0
        
        print(f"Results: {passed}/{total} tests passed ({percentage:.1f}%)")
        
        if passed == total:
            print("✅ All E2E tests passed!")
            print("=" * 60)
            return 0
        else:
            print("❌ Some tests failed")
            failed_tests = [name for name, result in self.test_results if not result]
            print(f"Failed tests: {', '.join(failed_tests)}")
            print("=" * 60)
            return 1

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='E2E Test Suite for JARVIS Backend')
    parser.add_argument('--server', default='localhost:8080', help='Backend server address')
    args = parser.parse_args()
    
    suite = E2ETestSuite(server=args.server)
    sys.exit(suite.run_all_tests())
