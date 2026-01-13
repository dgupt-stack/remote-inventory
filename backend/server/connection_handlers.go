package main

import (
	"context"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/djgupt/remote-inventory/cache"
	pb "github.com/djgupt/remote-inventory/proto"
	"github.com/google/uuid"
)

// Connection request streams
var (
	requestStreamsMu sync.RWMutex
	requestStreams   = make(map[string][]chan *pb.ConnectionRequestNotification)

	approvalStreamsMu sync.RWMutex
	approvalStreams   = make(map[string][]chan *pb.ApprovalStatusUpdate)
)

// RequestConnection - Consumer requests to connect to a provider
func (s *InventoryServer) RequestConnection(ctx context.Context, req *pb.RequestConnectionRequest) (*pb.RequestConnectionResponse, error) {
	log.Printf("📞 Connection request from %s to session %s", req.ConsumerName, req.SessionId)

	// Generate request ID
	requestID := uuid.New().String()

	// Create request object
	connReq := &cache.ConnectionRequest{
		RequestID:    requestID,
		SessionID:    req.SessionId,
		ConsumerID:   req.ConsumerId,
		ConsumerName: req.ConsumerName,
		Status:       "pending",
		Timestamp:    time.Now().Unix(),
	}

	// Store in cache
	if err := s.sessionCache.AddConnectionRequest(connReq); err != nil {
		return nil, fmt.Errorf("failed to add request: %v", err)
	}

	// Notify provider via stream
	notification := &pb.ConnectionRequestNotification{
		RequestId:    requestID,
		ConsumerId:   req.ConsumerId,
		ConsumerName: req.ConsumerName,
		Timestamp:    connReq.Timestamp,
	}

	// Send to all watchers of this session
	requestStreamsMu.RLock()
	streams := requestStreams[req.SessionId]
	requestStreamsMu.RUnlock()

	for _, stream := range streams {
		select {
		case stream <- notification:
			log.Printf("✅ Notified provider stream for session %s", req.SessionId)
		default:
			log.Printf("⚠️  Stream full or closed for session %s", req.SessionId)
		}
	}

	return &pb.RequestConnectionResponse{
		RequestId: requestID,
	}, nil
}

// WatchConnectionRequests - Provider watches for incoming requests
func (s *InventoryServer) WatchConnectionRequests(req *pb.WatchConnectionRequestsRequest, stream pb.InventoryService_WatchConnectionRequestsServer) error {
	log.Printf("👀 Provider watching requests for session: %s", req.SessionId)

	// Create channel for this stream
	ch := make(chan *pb.ConnectionRequestNotification, 10)

	// Register stream
	requestStreamsMu.Lock()
	requestStreams[req.SessionId] = append(requestStreams[req.SessionId], ch)
	requestStreamsMu.Unlock()

	// Cleanup on exit
	defer func() {
		requestStreamsMu.Lock()
		streams := requestStreams[req.SessionId]
		for i, s := range streams {
			if s == ch {
				requestStreams[req.SessionId] = append(streams[:i], streams[i+1:]...)
				break
			}
		}
		requestStreamsMu.Unlock()
		close(ch)
		log.Printf("🔌 Stopped watching requests for session: %s", req.SessionId)
	}()

	// Send any existing pending requests
	pending := s.sessionCache.GetPendingRequests(req.SessionId)
	for _, p := range pending {
		notification := &pb.ConnectionRequestNotification{
			RequestId:    p.RequestID,
			ConsumerId:   p.ConsumerID,
			ConsumerName: p.ConsumerName,
			Timestamp:    p.Timestamp,
		}
		if err := stream.Send(notification); err != nil {
			return err
		}
	}

	// Wait for new requests
	for {
		select {
		case <-stream.Context().Done():
			return nil
		case notification := <-ch:
			if err := stream.Send(notification); err != nil {
				return err
			}
		}
	}
}

// ApproveConnection - Provider approves a request
func (s *InventoryServer) ApproveConnection(ctx context.Context, req *pb.ApproveConnectionRequest) (*pb.ApproveConnectionResponse, error) {
	log.Printf("✅ Approving connection request: %s", req.RequestId)

	// Get request
	connReq, err := s.sessionCache.GetConnectionRequest(req.RequestId)
	if err != nil {
		return nil, err
	}

	// Approve in cache
	if err := s.sessionCache.ApproveConnection(req.RequestId); err != nil {
		return nil, err
	}

	// Notify consumer via approval stream
	update := &pb.ApprovalStatusUpdate{
		Status:    pb.ApprovalStatus_APPROVED,
		SessionId: connReq.SessionID,
		Token:     fmt.Sprintf("token-%s", req.RequestId),
		Message:   "Connection approved",
	}

	approvalStreamsMu.RLock()
	streams := approvalStreams[req.RequestId]
	approvalStreamsMu.RUnlock()

	for _, stream := range streams {
		select {
		case stream <- update:
			log.Printf("✅ Notified consumer of approval")
		default:
			log.Printf("⚠️  Approval stream full or closed")
		}
	}

	return &pb.ApproveConnectionResponse{
		SessionId: connReq.SessionID,
		Token:     update.Token,
	}, nil
}

// DenyConnection - Provider denies a request
func (s *InventoryServer) DenyConnection(ctx context.Context, req *pb.DenyConnectionRequest) (*pb.DenyConnectionResponse, error) {
	log.Printf("❌ Denying connection request: %s", req.RequestId)

	// Get request
	_, err := s.sessionCache.GetConnectionRequest(req.RequestId)
	if err != nil {
		return nil, err
	}

	// Deny in cache
	if err := s.sessionCache.DenyConnection(req.RequestId); err != nil {
		return nil, err
	}

	// Notify consumer
	update := &pb.ApprovalStatusUpdate{
		Status:  pb.ApprovalStatus_DENIED,
		Message: req.Reason,
	}

	approvalStreamsMu.RLock()
	streams := approvalStreams[req.RequestId]
	approvalStreamsMu.RUnlock()

	for _, stream := range streams {
		select {
		case stream <- update:
			log.Printf("✅ Notified consumer of denial")
		default:
			log.Printf("⚠️  Approval stream full or closed")
		}
	}

	return &pb.DenyConnectionResponse{
		Success: true,
	}, nil
}

// WatchApprovalStatus - Consumer watches for approval/denial
func (s *InventoryServer) WatchApprovalStatus(req *pb.WatchApprovalStatusRequest, stream pb.InventoryService_WatchApprovalStatusServer) error {
	log.Printf("👀 Consumer watching approval for request: %s", req.RequestId)

	// Create channel
	ch := make(chan *pb.ApprovalStatusUpdate, 5)

	// Register stream
	approvalStreamsMu.Lock()
	approvalStreams[req.RequestId] = append(approvalStreams[req.RequestId], ch)
	approvalStreamsMu.Unlock()

	// Cleanup
	defer func() {
		approvalStreamsMu.Lock()
		streams := approvalStreams[req.RequestId]
		for i, s := range streams {
			if s == ch {
				approvalStreams[req.RequestId] = append(streams[:i], streams[i+1:]...)
				break
			}
		}
		approvalStreamsMu.Unlock()
		close(ch)
		log.Printf("🔌 Stopped watching approval for request: %s", req.RequestId)
	}()

	// Check existing status
	connReq, err := s.sessionCache.GetConnectionRequest(req.RequestId)
	if err == nil && connReq.Status != "pending" {
		status := pb.ApprovalStatus_PENDING
		if connReq.Status == "approved" {
			status = pb.ApprovalStatus_APPROVED
		} else if connReq.Status == "denied" {
			status = pb.ApprovalStatus_DENIED
		}

		update := &pb.ApprovalStatusUpdate{
			Status:  status,
			Message: fmt.Sprintf("Request %s", connReq.Status),
		}
		if err := stream.Send(update); err != nil {
			return err
		}
		return nil
	}

	// Wait for updates
	for {
		select {
		case <-stream.Context().Done():
			return nil
		case update := <-ch:
			if err := stream.Send(update); err != nil {
				return err
			}
			// Close after sending approval/denial
			if update.Status != pb.ApprovalStatus_PENDING {
				return nil
			}
		}
	}
}
