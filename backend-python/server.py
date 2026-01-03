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
        
        # NEW: Track WebRTC signals for relay
        self.webrtc_signals = {}  # session_id -> [WebRTCSignal, ...]
        
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
        
        return pb2.ConnectionResponse(
            request_id=request_id,
            success=True,
            message='Connection request sent'
        )

    def WatchApprovalStatus(self, request, context):
        """Stream approval status updates to Consumer (PENDING → APPROVED/DENIED)"""
        request_id = request.request_id
        logger.info(f"👀 WatchApprovalStatus for request: {request_id}")
        
        # Wait for approval status to change (max 30 seconds)
        timeout = 30
        start_time = time.time()
        
        while time.time() - start_time < timeout:
            status = self.pending_approvals.get(request_id, 'PENDING')
            
            if status == 'APPROVED':
                # Get session info for approved request
                req_info = self.connection_requests.get(request_id, {})
                session_id = req_info.get('session_id', '')
                
                logger.info(f"✅ Request {request_id} APPROVED")
                yield pb2.ApprovalStatusUpdate(
                    status=pb2.ApprovalStatusUpdate.APPROVED,
                    session_id=session_id,
                    token='consumer-token',  # Generate proper token in production
                    message='Connection approved'
                )
                return
                
            elif status == 'DENIED':
                logger.info(f"❌ Request {request_id} DENIED")
                yield pb2.ApprovalStatusUpdate(
                    status=pb2.ApprovalStatusUpdate.DENIED,
                    session_id='',
                    token='',
                    message='Connection denied'
                )
                return
            
            # Still pending, send update
            yield pb2.ApprovalStatusUpdate(
                status=pb2.ApprovalStatusUpdate.PENDING,
                session_id='',
                token='',
                message='Waiting for provider approval'
            )
            
            time.sleep(1)  # Check every second
        
        # Timeout - send DENIED
        logger.warning(f"⏱️  Request {request_id} timed out")
        yield pb2.ApprovalStatusUpdate(
            status=pb2.ApprovalStatusUpdate.DENIED,
            session_id='',
            token='',
            message='Approval timeout'
        )

        
        logger.info(f"  → Request ID: {request_id}")
        
        # DEBUG: Log response details (disable in production)
        if DEBUG_MODE:
            logger.debug(f"  Response: {response}")
        
        return response
    
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

    # ============================================================
    # WEBRTC SIGNALING RPCS
    # ============================================================
    
    def SendWebRTCSignal(self, request, context):
        """Store and relay WebRTC signal (SDP or ICE) between devices"""
        logger.info(f"📡 SendWebRTCSignal: {request.type} from {request.from_device_id} to {request.to_device_id}")
        
        session_id = request.session_id
        
        # Initialize signals list for session if needed
        if session_id not in self.webrtc_signals:
            self.webrtc_signals[session_id] = []
        
        # Store signal for target device
        self.webrtc_signals[session_id].append({
            'from_device': request.from_device_id,
            'to_device': request.to_device_id,
            'type': request.type,
            'payload': request.payload,
            'timestamp': time.time()
        })
        
        logger.info(f"  ✅ Signal stored ({len(self.webrtc_signals[session_id])} total for session)")
        
        return pb2.SignalResponse(
            success=True,
            message="Signal stored"
        )
    
    def WatchWebRTCSignals(self, request, context):
        """Stream WebRTC signals to a device"""
        logger.info(f"👀 WatchWebRTCSignals for device: {request.device_id} (session: {request.session_id})")
        
        session_id = request.session_id
        device_id = request.device_id
        delivered_count = 0
        
        # Stream signals for up to 60 seconds
        timeout = 60
        start_time = time.time()
        
        while context.is_active() and (time.time() - start_time) < timeout:
            # Check for signals addressed to this device
            if session_id in self.webrtc_signals:
                pending_signals = [
                    sig for sig in self.webrtc_signals[session_id]
                    if sig['to_device'] == device_id
                ]
                
                if pending_signals:
                    for signal in pending_signals:
                        # Send signal to device
                        yield pb2.WebRTCSignal(
                            session_id=session_id,
                            from_device_id=signal['from_device'],
                            to_device_id=signal['to_device'],
                            type=signal['type'],
                            payload=signal['payload']
                        )
                        delivered_count += 1
                    
                    # Remove delivered signals
                    self.webrtc_signals[session_id] = [
                        sig for sig in self.webrtc_signals[session_id]
                        if sig['to_device'] != device_id
                    ]
                    
                    logger.info(f"  ✅ Delivered {delivered_count} signal(s) to {device_id}")
            
            # Check every 100ms for new signals
            time.sleep(0.1)
        
        logger.info(f"  ⏸️  WatchWebRTCSignals ended for {device_id} ({delivered_count} total delivered)")

