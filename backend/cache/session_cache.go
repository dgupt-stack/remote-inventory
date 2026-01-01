package cache

import (
	"fmt"
	"sync"
	"time"
)

// SessionInfo represents an active provider session
type SessionInfo struct {
	SessionID            string
	ProviderName         string
	ProviderLocation     string
	CreatedAt            time.Time
	AcceptingConnections bool
}

// ConnectionRequest represents a consumer's request to join a session
type ConnectionRequest struct {
	RequestID         string
	ConsumerID        string
	ConsumerName      string
	ProviderSessionID string
	RequestedAt       time.Time
	Status            string // "pending", "approved", "denied"
}

// SessionCache manages active sessions and connection requests in memory
type SessionCache struct {
	sessions sync.Map // sessionID -> SessionInfo
	requests sync.Map // requestID -> ConnectionRequest
	mu       sync.RWMutex
}

// NewSessionCache creates a new session cache
func NewSessionCache() *SessionCache {
	return &SessionCache{}
}

// CreateSession stores a new provider session
func (c *SessionCache) CreateSession(info SessionInfo) error {
	info.CreatedAt = time.Now()
	info.AcceptingConnections = true
	c.sessions.Store(info.SessionID, info)
	return nil
}

// ListActiveSessions returns all available provider sessions
func (c *SessionCache) ListActiveSessions() []SessionInfo {
	var sessions []SessionInfo
	c.sessions.Range(func(key, value interface{}) bool {
		if session, ok := value.(SessionInfo); ok {
			if session.AcceptingConnections {
				sessions = append(sessions, session)
			}
		}
		return true
	})
	return sessions
}

// GetSession retrieves a session by ID
func (c *SessionCache) GetSession(sessionID string) (*SessionInfo, error) {
	value, ok := c.sessions.Load(sessionID)
	if !ok {
		return nil, fmt.Errorf("session not found: %s", sessionID)
	}
	session := value.(SessionInfo)
	return &session, nil
}

// RequestConnection creates a new connection request
func (c *SessionCache) RequestConnection(req ConnectionRequest) error {
	// Verify session exists
	_, err := c.GetSession(req.ProviderSessionID)
	if err != nil {
		return err
	}

	req.RequestedAt = time.Now()
	req.Status = "pending"
	c.requests.Store(req.RequestID, req)
	return nil
}

// GetPendingRequests returns all pending connection requests for a provider
func (c *SessionCache) GetPendingRequests(sessionID string) []ConnectionRequest {
	var requests []ConnectionRequest
	c.requests.Range(func(key, value interface{}) bool {
		if req, ok := value.(ConnectionRequest); ok {
			if req.ProviderSessionID == sessionID && req.Status == "pending" {
				requests = append(requests, req)
			}
		}
		return true
	})
	return requests
}

// ApproveConnection marks a connection request as approved
func (c *SessionCache) ApproveConnection(requestID string) error {
	value, ok := c.requests.Load(requestID)
	if !ok {
		return fmt.Errorf("request not found: %s", requestID)
	}

	req := value.(ConnectionRequest)
	req.Status = "approved"
	c.requests.Store(requestID, req)
	return nil
}

// DenyConnection marks a connection request as denied
func (c *SessionCache) DenyConnection(requestID string) error {
	value, ok := c.requests.Load(requestID)
	if !ok {
		return fmt.Errorf("request not found: %s", requestID)
	}

	req := value.(ConnectionRequest)
	req.Status = "denied"
	c.requests.Store(requestID, req)
	return nil
}

// GetConnectionRequest retrieves a specific request
func (c *SessionCache) GetConnectionRequest(requestID string) (*ConnectionRequest, error) {
	value, ok := c.requests.Load(requestID)
	if !ok {
		return nil, fmt.Errorf("request not found: %s", requestID)
	}
	req := value.(ConnectionRequest)
	return &req, nil
}

// DeleteSession removes a session (when provider disconnects)
func (c *SessionCache) DeleteSession(sessionID string) {
	c.sessions.Delete(sessionID)

	// Clean up associated requests
	c.requests.Range(func(key, value interface{}) bool {
		if req, ok := value.(ConnectionRequest); ok {
			if req.ProviderSessionID == sessionID {
				c.requests.Delete(key)
			}
		}
		return true
	})
}

// UpdateSession updates session properties
func (c *SessionCache) UpdateSession(sessionID string, acceptingConnections bool) error {
	value, ok := c.sessions.Load(sessionID)
	if !ok {
		return fmt.Errorf("session not found: %s", sessionID)
	}

	session := value.(SessionInfo)
	session.AcceptingConnections = acceptingConnections
	c.sessions.Store(sessionID, session)
	return nil
}
