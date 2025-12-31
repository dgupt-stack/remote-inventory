package session

import (
	"context"
	"errors"
	"sync"
	"time"

	pb "github.com/djgupt/remote-inventory/proto"
	"github.com/google/uuid"
)

var (
	ErrSessionNotFound = errors.New("session not found")
	ErrUnauthorized    = errors.New("unauthorized")
	ErrSessionFull     = errors.New("session already has a consumer")
)

// Role represents session participant role
type Role string

const (
	RoleProvider Role = "provider"
	RoleConsumer Role = "consumer"
)

// Session represents an active inventory viewing session
type Session struct {
	ID            string
	ProviderID    string
	ProviderName  string
	ConsumerID    string
	ConsumerName  string
	ProviderToken string
	ConsumerToken string
	CreatedAt     time.Time
	LastHeartbeat time.Time

	// Command channels
	ProviderCommands chan *pb.ProviderCommand
	ConsumerFrames   chan *pb.VideoFrame

	mu sync.RWMutex
}

// Manager manages all active sessions
type Manager struct {
	sessions map[string]*Session
	mu       sync.RWMutex
}

// NewManager creates a new session manager
func NewManager() *Manager {
	return &Manager{
		sessions: make(map[string]*Session),
	}
}

// CreateSession creates a new session for a provider
func (m *Manager) CreateSession(ctx context.Context, req *pb.CreateSessionRequest) (*pb.SessionResponse, error) {
	sessionID := uuid.New().String()
	providerToken := uuid.New().String()

	session := &Session{
		ID:               sessionID,
		ProviderID:       req.ProviderId,
		ProviderName:     req.ProviderName,
		ProviderToken:    providerToken,
		CreatedAt:        time.Now(),
		LastHeartbeat:    time.Now(),
		ProviderCommands: make(chan *pb.ProviderCommand, 100),
		ConsumerFrames:   make(chan *pb.VideoFrame, 30),
	}

	m.mu.Lock()
	m.sessions[sessionID] = session
	m.mu.Unlock()

	return &pb.SessionResponse{
		SessionId: sessionID,
		Token:     providerToken,
		Success:   true,
		Message:   "Session created successfully",
	}, nil
}

// JoinSession allows a consumer to join an existing session
func (m *Manager) JoinSession(ctx context.Context, req *pb.JoinSessionRequest) (*pb.SessionResponse, error) {
	m.mu.RLock()
	session, exists := m.sessions[req.SessionId]
	m.mu.RUnlock()

	if !exists {
		return &pb.SessionResponse{
			Success: false,
			Message: "Session not found",
		}, ErrSessionNotFound
	}

	session.mu.Lock()
	defer session.mu.Unlock()

	if session.ConsumerID != "" {
		return &pb.SessionResponse{
			Success: false,
			Message: "Session already has a consumer",
		}, ErrSessionFull
	}

	consumerToken := uuid.New().String()
	session.ConsumerID = req.ConsumerId
	session.ConsumerName = req.ConsumerName
	session.ConsumerToken = consumerToken
	session.LastHeartbeat = time.Now()

	return &pb.SessionResponse{
		SessionId: req.SessionId,
		Token:     consumerToken,
		Success:   true,
		Message:   "Joined session successfully",
	}, nil
}

// GetSession retrieves a session by ID
func (m *Manager) GetSession(sessionID string) (*Session, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	session, exists := m.sessions[sessionID]
	if !exists {
		return nil, ErrSessionNotFound
	}

	return session, nil
}

// ValidateToken validates a session token for a given role
func (m *Manager) ValidateToken(sessionID, token string, role Role) error {
	session, err := m.GetSession(sessionID)
	if err != nil {
		return err
	}

	session.mu.RLock()
	defer session.mu.RUnlock()

	switch role {
	case RoleProvider:
		if session.ProviderToken != token {
			return ErrUnauthorized
		}
	case RoleConsumer:
		if session.ConsumerToken != token {
			return ErrUnauthorized
		}
	default:
		return ErrUnauthorized
	}

	return nil
}

// UpdateHeartbeat updates the last heartbeat time
func (m *Manager) UpdateHeartbeat(sessionID string) error {
	session, err := m.GetSession(sessionID)
	if err != nil {
		return err
	}

	session.mu.Lock()
	session.LastHeartbeat = time.Now()
	session.mu.Unlock()

	return nil
}

// EndSession ends a session and cleans up resources
func (m *Manager) EndSession(sessionID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	session, exists := m.sessions[sessionID]
	if !exists {
		return ErrSessionNotFound
	}

	// Close channels
	close(session.ProviderCommands)
	close(session.ConsumerFrames)

	// Remove from map
	delete(m.sessions, sessionID)

	return nil
}

// CleanupStale removes sessions with no heartbeat in the last 5 minutes
func (m *Manager) CleanupStale() {
	m.mu.Lock()
	defer m.mu.Unlock()

	threshold := time.Now().Add(-5 * time.Minute)

	for id, session := range m.sessions {
		session.mu.RLock()
		lastHeartbeat := session.LastHeartbeat
		session.mu.RUnlock()

		if lastHeartbeat.Before(threshold) {
			close(session.ProviderCommands)
			close(session.ConsumerFrames)
			delete(m.sessions, id)
		}
	}
}

// SendCommand sends a command from consumer to provider
func (s *Session) SendCommand(cmd *pb.ProviderCommand) error {
	select {
	case s.ProviderCommands <- cmd:
		return nil
	default:
		return errors.New("command queue full")
	}
}

// SendFrame sends a blurred frame from privacy layer to consumer
func (s *Session) SendFrame(frame *pb.VideoFrame) error {
	select {
	case s.ConsumerFrames <- frame:
		return nil
	default:
		// Drop frame if queue is full to maintain real-time performance
		return nil
	}
}
