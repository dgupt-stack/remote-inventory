package cache

import "fmt"

// ConnectionRequest represents a consumer's connection request
type ConnectionRequest struct {
	RequestID    string
	SessionID    string
	ConsumerID   string
	ConsumerName string
	Status       string // "pending", "approved", "denied"
	Timestamp    int64
}

// AddConnectionRequest adds a new connection request
func (c *SessionCache) AddConnectionRequest(req *ConnectionRequest) error {
	c.mu.Lock()
	defer c.mu.Unlock()

	// Check if session exists
	_, exists := c.sessions.Load(req.SessionID)
	if !exists {
		return fmt.Errorf("session not found: %s", req.SessionID)
	}

	// Store request
	c.requests.Store(req.RequestID, req)

	return nil
}

// GetConnectionRequest retrieves a connection request
func (c *SessionCache) GetConnectionRequest(requestID string) (*ConnectionRequest, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	val, exists := c.requests.Load(requestID)
	if !exists {
		return nil, fmt.Errorf("request not found: %s", requestID)
	}

	req, ok := val.(*ConnectionRequest)
	if !ok {
		return nil, fmt.Errorf("invalid request type")
	}

	return req, nil
}

// ApproveRequest marks a request as approved
func (c *SessionCache) ApproveRequest(requestID string) error {
	c.mu.Lock()
	defer c.mu.Unlock()

	val, exists := c.requests.Load(requestID)
	if !exists {
		return fmt.Errorf("request not found: %s", requestID)
	}

	req, ok := val.(*ConnectionRequest)
	if !ok {
		return fmt.Errorf("invalid request type")
	}

	req.Status = "approved"
	c.requests.Store(requestID, req)

	// Mark session as in active call
	if sessVal, exists := c.sessions.Load(req.SessionID); exists {
		if sess, ok := sessVal.(SessionInfo); ok {
			sess.InActiveCall = true
			c.sessions.Store(req.SessionID, sess)
		}
	}

	return nil
}

// DenyRequest marks a request as denied
func (c *SessionCache) DenyRequest(requestID string) error {
	c.mu.Lock()
	defer c.mu.Unlock()

	val, exists := c.requests.Load(requestID)
	if !exists {
		return fmt.Errorf("request not found: %s", requestID)
	}

	req, ok := val.(*ConnectionRequest)
	if !ok {
		return fmt.Errorf("invalid request type")
	}

	req.Status = "denied"
	c.requests.Store(requestID, req)

	return nil
}

// GetPendingRequestsForSession gets pending requests for a session
func (c *SessionCache) GetPendingRequestsForSession(sessionID string) []*ConnectionRequest {
	c.mu.RLock()
	defer c.mu.RUnlock()

	var pending []*ConnectionRequest

	c.requests.Range(func(key, value interface{}) bool {
		if req, ok := value.(*ConnectionRequest); ok {
			if req.SessionID == sessionID && req.Status == "pending" {
				pending = append(pending, req)
			}
		}
		return true
	})

	return pending
}
