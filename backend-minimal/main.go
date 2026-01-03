package main

import (
	"context"
	"log"
	"net"
	"sync"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

// Session info
type Session struct {
	ID               string
	ProviderName     string
	ProviderLocation string
	CreatedAt        time.Time
}

// Simple in-memory storage
type server struct {
	UnimplementedRemoteInventoryServiceServer
	mu       sync.RWMutex
	sessions map[string]*Session
}

func newServer() *server {
	return &server{
		sessions: make(map[string]*Session),
	}
}

// ListSessions returns all active sessions
func (s *server) ListSessions(ctx context.Context, req *ListSessionsRequest) (*ListSessionsResponse, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	log.Printf("ListSessions called, found %d sessions", len(s.sessions))

	var sessions []*SessionInfo
	for _, sess := range s.sessions {
		sessions = append(sessions, &SessionInfo{
			SessionId:            sess.ID,
			ProviderName:         sess.ProviderName,
			ProviderLocation:     sess.ProviderLocation,
			CreatedAt:            sess.CreatedAt.Unix(),
			AcceptingConnections: true,
		})
	}

	return &ListSessionsResponse{
		Sessions: sessions,
	}, nil
}

// CreateSession creates a new provider session
func (s *server) CreateSession(ctx context.Context, req *CreateSessionRequest) (*SessionResponse, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	sessionID := generateID()
	token := generateID()

	session := &Session{
		ID:               sessionID,
		ProviderName:     req.ProviderName,
		ProviderLocation: "Unknown",
		CreatedAt:        time.Now(),
	}

	s.sessions[sessionID] = session
	log.Printf("Created session: %s for provider: %s", sessionID, req.ProviderName)

	return &SessionResponse{
		SessionId: sessionID,
		Token:     token,
		Success:   true,
		Message:   "Session created successfully",
	}, nil
}

// Simple ID generator
func generateID() string {
	return time.Now().Format("20060102-150405.000")
}

func main() {
	port := ":8080"

	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer(
		grpc.MaxRecvMsgSize(10*1024*1024),
		grpc.MaxSendMsgSize(10*1024*1024),
	)

	RegisterRemoteInventoryServiceServer(grpcServer, newServer())
	reflection.Register(grpcServer)

	log.Printf("🚀 Backend server listening on %s", port)
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
