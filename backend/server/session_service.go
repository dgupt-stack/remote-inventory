package main

import (
	"context"
	"fmt"
	"log"
	"sync"
	"time"

	pb "github.com/djgupt/remote-inventory"
	"github.com/djgupt/remote-inventory/cache"
	"github.com/google/uuid"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// InventoryServer implements the InventoryService gRPC server
type InventoryServer struct {
	pb.UnimplementedInventoryServiceServer
	sessionCache *cache.SessionCache
	// Channels for streaming connection requests to providers
	connectionStreams map[string]chan *pb.ConnectionRequestNotification
	// Channels for streaming approval notifications to consumers
	approvalStreams map[string]chan *pb.ApprovalStatusUpdate
	// Real-time WebRTC signal streams
	signalStreams map[string]chan *pb.WebRTCSignal
	// Cache signals for late joiners
	signalCache sync.Map // Need sync.Map for concurrent access
	// Geocoding service
	geocoder *GeocodingService
	mu       sync.RWMutex
}

// NewInventoryServer creates a new inventory server
func NewInventoryServer() *InventoryServer {
	return &InventoryServer{
		sessionCache:      cache.NewSessionCache(),
		connectionStreams: make(map[string]chan *pb.ConnectionRequestNotification),
		approvalStreams:   make(map[string]chan *pb.ApprovalStatusUpdate),
		signalStreams:     make(map[string]chan *pb.WebRTCSignal),
		geocoder:          NewGeocodingService(),
	}
}

// CreateSession creates a new provider session with geocoding
func (s *InventoryServer) CreateSession(ctx context.Context, req *pb.CreateSessionRequest) (*pb.SessionResponse, error) {
	sessionID := uuid.New().String()
	token := uuid.New().String()

	// Geocode the location if lat/lng provided
	formattedAddress := req.Location // Fallback to provided location
	if req.Latitude != 0 && req.Longitude != 0 {
		addr, err := s.geocoder.ReverseGeocode(ctx, req.Latitude, req.Longitude)
		if err != nil {
			// Log error but don't fail - use provided location as fallback
			log.Printf("Geocoding failed for lat=%.6f,  lng=%.6f: %v", req.Latitude, req.Longitude, err)
		} else {
			formattedAddress = addr
		}
	}

	sessionInfo := cache.SessionInfo{
		SessionID:        sessionID,
		ProviderName:     req.ProviderName,
		ProviderLocation: req.Location, // Keep for backward compatibility
		FormattedAddress: formattedAddress,
		Latitude:         req.Latitude,
		Longitude:        req.Longitude,
	}

	err := s.sessionCache.CreateSession(sessionInfo)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "Failed to create session: %v", err)
	}

	log.Printf("Provider '%s' created session %s (location: %s)", req.ProviderName, sessionID, formattedAddress)

	return &pb.SessionResponse{
		SessionId: sessionID,
		Token:     token,
		Success:   true,
		Message:   "Session created successfully",
	}, nil
}

// ListSessions returns all available provider sessions (not in active calls)
func (s *InventoryServer) ListSessions(ctx context.Context, req *pb.ListSessionsRequest) (*pb.ListSessionsResponse, error) {
	activeSessions := s.sessionCache.ListActiveSessions()

	sessions := make([]*pb.SessionInfo, len(activeSessions))
	for i, session := range activeSessions {
		sessions[i] = &pb.SessionInfo{
			SessionId:            session.SessionID,
			ProviderName:         session.ProviderName,
			Location:             session.ProviderLocation, // Deprecated field
			FormattedAddress:     session.FormattedAddress, // NEW: Geocoded address
			Latitude:             session.Latitude,
			Longitude:            session.Longitude,
			InActiveCall:         session.InActiveCall, // NEW: Call status
			CreatedAt:            session.CreatedAt.Unix(),
			AcceptingConnections: session.AcceptingConnections,
		}
	}

	log.Printf("Listing %d available sessions", len(sessions))

	return &pb.ListSessionsResponse{
		Sessions: sessions,
	}, nil
}

// RequestConnection creates a connection request from consumer to provider
func (s *InventoryServer) RequestConnection(ctx context.Context, req *pb.ConnectionRequest) (*pb.ConnectionResponse, error) {
	requestID := uuid.New().String()

	connReq := cache.ConnectionRequest{
		RequestID:         requestID,
		ConsumerID:        req.ConsumerId,
		ConsumerName:      req.ConsumerName,
		ProviderSessionID: req.SessionId,
		RequestedAt:       time.Now(),
		Status:            "pending",
	}

	err := s.sessionCache.RequestConnection(connReq)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "session not found: %v", err)
	}

	// Notify provider if they're watching
	if stream, ok := s.connectionStreams[req.SessionId]; ok {
		notification := &pb.ConnectionRequestNotification{
			RequestId:    requestID,
			ConsumerId:   req.ConsumerId,
			ConsumerName: req.ConsumerName,
			RequestedAt:  time.Now().Unix(),
		}
		select {
		case stream <- notification:
		default:
			// Stream buffer full, skip
		}
	}

	return &pb.ConnectionResponse{
		RequestId: requestID,
		Success:   true,
		Message:   "Connection request sent",
	}, nil
}

// WatchConnectionRequests streams connection requests to provider
func (s *InventoryServer) WatchConnectionRequests(req *pb.WatchRequestsRequest, stream pb.InventoryService_WatchConnectionRequestsServer) error {
	// Create channel for this session
	reqChan := make(chan *pb.ConnectionRequestNotification, 10)
	s.connectionStreams[req.SessionId] = reqChan
	defer delete(s.connectionStreams, req.SessionId)

	// Send any pending requests first
	pending := s.sessionCache.GetPendingRequests(req.SessionId)
	for _, req := range pending {
		notification := &pb.ConnectionRequestNotification{
			RequestId:    req.RequestID,
			ConsumerId:   req.ConsumerID,
			ConsumerName: req.ConsumerName,
			RequestedAt:  req.RequestedAt.Unix(),
		}
		if err := stream.Send(notification); err != nil {
			return err
		}
	}

	// Stream new requests
	for {
		select {
		case notification := <-reqChan:
			if err := stream.Send(notification); err != nil {
				return err
			}
		case <-stream.Context().Done():
			return nil
		}
	}
}

// ApproveConnection approves a consumer's connection request
func (s *InventoryServer) ApproveConnection(ctx context.Context, req *pb.ApproveRequest) (*pb.ApproveResponse, error) {
	err := s.sessionCache.ApproveConnection(req.RequestId)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "request not found: %v", err)
	}

	// Get the connection request details
	connReq, err := s.sessionCache.GetConnectionRequest(req.RequestId)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get request: %v", err)
	}

	// Generate token for consumer
	token := uuid.New().String()

	// Notify consumer if they're watching
	if stream, ok := s.approvalStreams[req.RequestId]; ok {
		update := &pb.ApprovalStatusUpdate{
			Status:    pb.ApprovalStatusUpdate_APPROVED,
			SessionId: connReq.ProviderSessionID,
			Token:     token,
			Message:   "Connection approved",
		}
		select {
		case stream <- update:
		default:
		}
	}

	return &pb.ApproveResponse{
		Success:   true,
		SessionId: connReq.ProviderSessionID,
		Token:     token,
	}, nil
}

// DenyConnection denies a consumer's connection request
func (s *InventoryServer) DenyConnection(ctx context.Context, req *pb.DenyRequest) (*pb.DenyResponse, error) {
	err := s.sessionCache.DenyConnection(req.RequestId)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "request not found: %v", err)
	}

	// Notify consumer if they're watching
	if stream, ok := s.approvalStreams[req.RequestId]; ok {
		update := &pb.ApprovalStatusUpdate{
			Status:  pb.ApprovalStatusUpdate_DENIED,
			Message: req.Reason,
		}
		select {
		case stream <- update:
		default:
		}
	}

	return &pb.DenyResponse{
		Success: true,
	}, nil
}

// WatchApprovalStatus streams approval status to consumer
func (s *InventoryServer) WatchApprovalStatus(req *pb.WatchApprovalRequest, stream pb.InventoryService_WatchApprovalStatusServer) error {
	// Create channel for this request
	approvalChan := make(chan *pb.ApprovalStatusUpdate, 5)
	s.approvalStreams[req.RequestId] = approvalChan
	defer delete(s.approvalStreams, req.RequestId)

	// Check current status
	connReq, err := s.sessionCache.GetConnectionRequest(req.RequestId)
	if err != nil {
		return status.Errorf(codes.NotFound, "request not found: %v", err)
	}

	// Send initial status
	var initialStatus pb.ApprovalStatusUpdate_Status
	switch connReq.Status {
	case "pending":
		initialStatus = pb.ApprovalStatusUpdate_PENDING
	case "approved":
		initialStatus = pb.ApprovalStatusUpdate_APPROVED
	case "denied":
		initialStatus = pb.ApprovalStatusUpdate_DENIED
	}

	initialUpdate := &pb.ApprovalStatusUpdate{
		Status:  initialStatus,
		Message: fmt.Sprintf("Request is %s", connReq.Status),
	}
	if err := stream.Send(initialUpdate); err != nil {
		return err
	}

	// If already decided, close stream
	if connReq.Status != "pending" {
		return nil
	}

	// Stream status updates
	for {
		select {
		case update := <-approvalChan:
			if err := stream.Send(update); err != nil {
				return err
			}
			// Close stream after sending decision
			if update.Status != pb.ApprovalStatusUpdate_PENDING {
				return nil
			}
		case <-stream.Context().Done():
			return nil
		}
	}
}

// EndSession ends a provider session
func (s *InventoryServer) EndSession(ctx context.Context, req *pb.EndSessionRequest) (*pb.EndSessionResponse, error) {
	s.sessionCache.DeleteSession(req.SessionId)
	delete(s.connectionStreams, req.SessionId)

	return &pb.EndSessionResponse{
		Success: true,
	}, nil
}

// SendWebRTCSignal sends WebRTC signaling data (SDP offer/answer or ICE candidate)
func (s *InventoryServer) SendWebRTCSignal(ctx context.Context, req *pb.WebRTCSignal) (*pb.SignalResponse, error) {
	// Verify session exists
	_, err := s.sessionCache.GetSession(req.SessionId)
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "session not found: %v", err)
	}

	// Build stream key for target device
	streamKey := fmt.Sprintf("%s:%s", req.SessionId, req.ToDeviceId)

	// Try to send to any active watchers
	s.mu.RLock()
	if stream, ok := s.signalStreams[streamKey]; ok {
		select {
		case stream <- req:
		default:
			// Buffer full, cache the signal
			s.cacheSignal(req)
		}
	} else {
		// No active watcher, cache the signal
		s.cacheSignal(req)
	}
	s.mu.RUnlock()

	return &pb.SignalResponse{
		Success: true,
		Message: "Signal sent",
	}, nil
}

// WatchWebRTCSignals watches for WebRTC signals directed to this device
func (s *InventoryServer) WatchWebRTCSignals(req *pb.WatchSignalsRequest, stream pb.InventoryService_WatchWebRTCSignalsServer) error {
	// Create channel for this device
	streamKey := fmt.Sprintf("%s:%s", req.SessionId, req.DeviceId)
	signalChan := make(chan *pb.WebRTCSignal, 10)

	s.mu.Lock()
	s.signalStreams[streamKey] = signalChan
	s.mu.Unlock()

	defer func() {
		s.mu.Lock()
		delete(s.signalStreams, streamKey)
		s.mu.Unlock()
	}()

	// Send any cached signals first
	cachedSignals := s.getCachedSignals(req.SessionId, req.DeviceId)
	for _, signal := range cachedSignals {
		if err := stream.Send(signal); err != nil {
			return err
		}
	}

	// Stream new signals
	for {
		select {
		case signal := <-signalChan:
			if err := stream.Send(signal); err != nil {
				return err
			}
		case <-stream.Context().Done():
			return nil
		}
	}
}

// Heartbeat keeps a session alive and returns session status
func (s *InventoryServer) Heartbeat(ctx context.Context, req *pb.HeartbeatRequest) (*pb.HeartbeatResponse, error) {
	session, err := s.sessionCache.GetSession(req.SessionId)
	if err != nil {
		return &pb.HeartbeatResponse{
			Active: false,
		}, nil
	}

	duration := time.Since(session.CreatedAt).Milliseconds()

	return &pb.HeartbeatResponse{
		Active:            true,
		SessionDurationMs: duration,
	}, nil
}

// Helper methods for signal caching
func (s *InventoryServer) cacheSignal(signal *pb.WebRTCSignal) {
	cacheKey := fmt.Sprintf("%s:%s", signal.SessionId, signal.ToDeviceId)

	// Get or create signal list
	var signals []*pb.WebRTCSignal
	if val, ok := s.signalCache.Load(cacheKey); ok {
		signals = val.([]*pb.WebRTCSignal)
	}

	// Add new signal (keep last 10)
	signals = append(signals, signal)
	if len(signals) > 10 {
		signals = signals[len(signals)-10:]
	}

	s.signalCache.Store(cacheKey, signals)
}

func (s *InventoryServer) getCachedSignals(sessionID, deviceID string) []*pb.WebRTCSignal {
	cacheKey := fmt.Sprintf("%s:%s", sessionID, deviceID)

	if val, ok := s.signalCache.Load(cacheKey); ok {
		signals := val.([]*pb.WebRTCSignal)
		// Clear cache after retrieval
		s.signalCache.Delete(cacheKey)
		return signals
	}

	return nil
}
