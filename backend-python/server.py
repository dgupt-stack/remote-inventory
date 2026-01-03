#!/usr/bin/env python3
"""
JARVIS Remote Inventory - Python gRPC Backend Server
Simple in-memory session management for Provider/Consumer discovery
"""

import logging
import time
from concurrent import futures
from datetime import datetime
from typing import Dict

import grpc
import inventory_service_pb2 as pb2
import inventory_service_pb2_grpc as pb2_grpc

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# DEBUG MODE: Set to False in production to disable verbose proto logging
DEBUG_MODE = True  # TODO: Disable this before deploying to production


class Session:
    """Simple session data structure"""
    def __init__(self, session_id: str, provider_name: str, provider_location: str = "Unknown"):
        self.session_id = session_id
        self.provider_name = provider_name
        self.provider_location = provider_location
        self.created_at = datetime.now()
        self.accepting_connections = True


class InventoryServicer(pb2_grpc.RemoteInventoryServiceServicer):
    """Implementation of RemoteInventoryService"""
    
    def __init__(self):
        self.sessions: Dict[str, Session] = {}
        
        # NEW: Track connection requests and approvals
        self.connection_requests = {}  # request_id -> {session_id, consumer_id, consumer_name, timestamp}
        self.pending_approvals = {}    # request_id -> approval status
        
        logger.info("✅ Inventory Service initialized")
    
    def ListSessions(self, request, context):
        """List all active sessions"""
        logger.info(f"📋 ListSessions called (query: '{request.search_query}')")
        
        # DEBUG: Log request details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Request: {request}")
        
        sessions = []
        for session in self.sessions.values():
            sessions.append(pb2.SessionInfo(
                session_id=session.session_id,
                provider_name=session.provider_name,
                provider_location=session.provider_location,
                created_at=int(session.created_at.timestamp()),
                accepting_connections=session.accepting_connections
            ))
        
        response = pb2.ListSessionsResponse(sessions=sessions)
        logger.info(f"  → Returning {len(sessions)} sessions")
        
        # DEBUG: Log response details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Response: {response}")
        
        return response
    
    def CreateSession(self, request, context):
        """Create a new provider session"""
        logger.info(f"✨ CreateSession called for provider: {request.provider_name}")
        
        # DEBUG: Log request details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Request: {request}")
        
        session_id = f"session-{int(time.time())}"
        token = f"token-{int(time.time())}"
        
        # Get location if it exists, otherwise use "Unknown"
        location = getattr(request, 'location', None) or "Unknown"
        
        session = Session(
            session_id=session_id,
            provider_name=request.provider_name,
            provider_location=location
        )
        
        self.sessions[session_id] = session
        logger.info(f"  → Session created: {session_id}")
        
        response = pb2.SessionResponse(
            session_id=session_id,
            token=token,
            success=True,
            message="Session created successfully"
        )
        
        # DEBUG: Log response details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Response: {response}")
        
        return response
    
    def RequestConnection(self, request, context):
        """Consumer requests to connect to a provider"""
        logger.info(f"🔗 RequestConnection from {request.consumer_name} to session {request.session_id}")
        
        # DEBUG: Log request details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Request: {request}")
        
        request_id = f"request-{int(time.time())}"
        
        if request.session_id not in self.sessions:
            logger.warning(f"  ❌ Session not found: {request.session_id}")
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details("Session not found")
            return pb2.ConnectionResponse()
        
        # Store the connection request
        self.connection_requests[request_id] = {
            'session_id': request.session_id,
            'consumer_id': request.consumer_id,
            'consumer_name': request.consumer_name,
            'timestamp': time.time()
        }
        
        # Initialize as pending
        self.pending_approvals[request_id] = 'PENDING'
        
        response = pb2.ConnectionResponse(
            request_id=request_id,
            success=True,
            message="Connection request received"
        )
        
        logger.info(f"  → Request ID: {request_id}")
        
        # DEBUG: Log response details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Response: {response}")
        
        return response
    
    def WatchApprovalStatus(self, request, context):
        """Stream approval status updates to consumer"""
        logger.info(f"👀 WatchApprovalStatus for request: {request.request_id}")
        
        request_id = request.request_id
        
        if request_id not in self.connection_requests:
            logger.warning(f"  ❌ Request not found: {request_id}")
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details("Request not found")
            return
        
        # Stream status updates
        max_wait = 30  # 30 seconds timeout
        start_time = time.time()
        
        while context.is_active() and (time.time() - start_time) < max_wait:
            current_status = self.pending_approvals.get(request_id, 'PENDING')
            
            if current_status == 'APPROVED':
                yield pb2.ApprovalStatusUpdate(
                    status=pb2.ApprovalStatusUpdate.APPROVED,
                    session_id=self.connection_requests[request_id]['session_id'],
                    token="session-token-placeholder",
                    message="Connection approved by provider"
                )
                logger.info(f"  ✅ Sent APPROVED status for: {request_id}")
                break
            elif current_status == 'DENIED':
                yield pb2.ApprovalStatusUpdate(
                    status=pb2.ApprovalStatusUpdate.DENIED,
                    session_id="",
                    token="",
                    message="Connection denied by provider"
                )
                logger.info(f"  ❌ Sent DENIED status for: {request_id}")
                break
            else:
                # Still pending, send pending and wait
                yield pb2.ApprovalStatusUpdate(
                    status=pb2.ApprovalStatusUpdate.PENDING,
                    session_id="",
                    token="",
                    message="Waiting for provider approval"
                )
                time.sleep(1)  # Check every second
        
        logger.info(f"⏸️  WatchApprovalStatus stream ended for: {request_id}")
    
    def EndSession(self, request, context):
        """End a provider session"""
        logger.info(f"🛑 EndSession called for: {request.session_id}")
        
        # DEBUG: Log request details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Request: {request}")
        
        if request.session_id in self.sessions:
            del self.sessions[request.session_id]
            response = pb2.EndSessionResponse(success=True)
            logger.info(f"  → Session ended successfully")
        else:
            response = pb2.EndSessionResponse(success=False)
            logger.warning(f"  ❌ Session not found: {request.session_id}")
        
        # DEBUG: Log response details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Response: {response}\"")
        
        return response
    
    def ApproveConnection(self, request, context):
        """Provider approves a connection request"""
        logger.info(f"✅ ApproveConnection: {request.request_id}")
        
        request_id = request.request_id
        
        if request_id not in self.connection_requests:
            logger.warning(f"  ❌ Request not found: {request_id}")
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details("Request not found")
            return pb2.ApprovalResponse(success=False)
        
        # Update approval status
        self.pending_approvals[request_id] = 'APPROVED'
        logger.info(f"  → Request {request_id} approved")
        
        return pb2.ApprovalResponse(success=True)
    
    def DenyConnection(self, request, context):
        """Provider denies a connection request"""
        logger.info(f"❌ DenyConnection: {request.request_id}")
        
        request_id = request.request_id
        
        if request_id not in self.connection_requests:
            logger.warning(f"  ❌ Request not found: {request_id}")
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details("Request not found")
            return pb2.ApprovalResponse(success=False)
        
        # Update approval status
        self.pending_approvals[request_id] = 'DENIED'
        logger.info(f"  → Request {request_id} denied")
        
        return pb2.ApprovalResponse(success=True)


def serve():
    """Start the gRPC server"""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    pb2_grpc.add_RemoteInventoryServiceServicer_to_server(
        InventoryServicer(), server
    )
    
    port = "8080"
    server.add_insecure_port(f"0.0.0.0:{port}")
    server.start()
    
    logger.info("=" * 60)
    logger.info("🚀 JARVIS Backend Server Started!")
    logger.info(f"📡 Listening on 0.0.0.0:{port}")
    logger.info(f"🌐 Local IP: 192.168.86.89:{port}")
    logger.info("=" * 60)
    
    try:
        server.wait_for_termination()
    except KeyboardInterrupt:
        logger.info("\n👋 Shutting down server...")
        server.stop(0)


if __name__ == "__main__":
    serve()
