package server

import (
	"context"
	"fmt"
	"time"

	"github.com/djgupt/remote-inventory/backend/cache"
	pb "github.com/djgupt/remote-inventory/proto"
	"github.com/google/uuid"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// InventoryServer implements the RemoteInventoryService
type InventoryServer struct {
	pb.UnimplementedRemoteInventoryServiceServer
	sessionCache    *cache.SessionCache
	requestStreams  map[string]chan *pb.ConnectionRequestNotification
	approvalStreams map[string]chan *pb.ApprovalStatusUpdate
}

// NewInventoryServer creates a new inventory server
func NewInventoryServer() *InventoryServer {
	return &InventoryServer{
		sessionCache:    cache.NewSessionCache(),
		requestStreams:  make(map[string]chan *pb.ConnectionRequestNotification),
		approvalStreams: make(map[string]chan *pb.ApprovalStatusUpdate),
	}
}

// CreateSession creates a new provider session
func (s *InventoryServer) CreateSession(ctx context.Context, req *pb.CreateSessionRequest) (*pb.SessionResponse, error) {
	sessionID := uuid.New().String()
	token := uuid.New().String()

	session := cache.SessionInfo{
		SessionID:            sessionID,
		ProviderName:         req.ProviderName,
		ProviderLocation:     "Unknown", // TODO: Get from request or IP
		CreatedAt:            time.Now(),
		AcceptingConnections: true,
	}

	err := s.sessionCache.CreateSession(session)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create session: %v", err)
	}

	return &pb.SessionResponse{
		SessionId: sessionID,
		Token:     token,
		Success:   true,
		Message:   "Session created successfully",
	}, nil
}

// ListSessions returns all active sessions
func (s *InventoryServer) ListSessions(ctx context.Context, req *pb.ListSessionsRequest) (*pb.ListSessionsResponse, error) {
	sessions := s.sessionCache.ListActiveSessions()

	var pbSessions []*pb.SessionInfo
	for _, session := range sessions {
		pbSessions = append(pbSessions, &pb.SessionInfo{
			SessionId:            session.SessionID,
			ProviderName:         session.ProviderName,
			ProviderLocation:     session.ProviderLocation,
			CreatedAt:            session.CreatedAt.Unix(),
			AcceptingConnections: session.AcceptingConnections,
		})
	}

	return &pb.ListSessionsResponse{
		Sessions: pbSessions,
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
	if stream, ok := s.requestStreams[req.SessionId]; ok {
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
func (s *InventoryServer) WatchConnectionRequests(req *pb.WatchRequestsRequest, stream pb.RemoteInventoryService_WatchConnectionRequestsServer) error {
	// Create channel for this session
	reqChan := make(chan *pb.ConnectionRequestNotification, 10)
	s.requestStreams[req.SessionId] = reqChan
	defer delete(s.requestStreams, req.SessionId)

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
func (s *InventoryServer) WatchApprovalStatus(req *pb.WatchApprovalRequest, stream pb.RemoteInventoryService_WatchApprovalStatusServer) error {
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
	delete(s.requestStreams, req.SessionId)

	return &pb.EndSessionResponse{
		Success: true,
	}, nil
}
