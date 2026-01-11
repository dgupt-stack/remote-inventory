# Lovable Integration API

This document provides the complete REST API specification for integrating a Lovable-built web frontend with the Remote Inventory backend.

## Base URL

- **Local Development**: `http://localhost:8081`
- **Production**: `https://your-cloud-run-url.run.app`

All endpoints are prefixed with `/v1`.

---

## Table of Contents

1. [Session Management](#session-management)
2. [Session Discovery](#session-discovery)
3. [Connection Requests](#connection-requests)
4. [WebRTC Signaling](#webrtc-signaling)
5. [Heartbeat](#heartbeat)
6. [Error Handling](#error-handling)
7. [JavaScript Examples](#javascript-examples)

---

## Session Management

### Create Session (Provider)

Create a new session for a provider to start broadcasting.

**Endpoint**: `POST /v1/sessions`

**Request Body**:
```json
{
  "provider_id": "string",
  "provider_name": "string",
  "location": "string (optional)"
}
```

**Response**:
```json
{
  "session_id": "uuid",
  "token": "auth-token",
  "success": true,
  "message": "Session created successfully"
}
```

**Example**:
```bash
curl -X POST http://localhost:8081/v1/sessions \
  -H "Content-Type: application/json" \
  -d '{
    "provider_id": "provider-123",
    "provider_name": "John Doe",
    "location": "San Francisco, CA"
  }'
```

---

### End Session

End an active session.

**Endpoint**: `DELETE /v1/sessions/{session_id}`

**Query Parameters**:
- `token`: Authentication token from session creation

**Response**:
```json
{
  "success": true
}
```

**Example**:
```bash
curl -X DELETE "http://localhost:8081/v1/sessions/SESSION_ID?token=YOUR_TOKEN"
```

---

## Session Discovery

### List Active Sessions

Retrieve all active provider sessions available for connection.

**Endpoint**: `GET /v1/sessions`

**Query Parameters** (optional):
- `search_query`: Filter sessions by provider name or location

**Response**:
```json
{
  "sessions": [
    {
      "session_id": "uuid",
      "provider_name": "John Doe",
      "provider_location": "San Francisco, CA",
      "created_at": 1704567890,
      "accepting_connections": true
    }
  ]
}
```

**Example**:
```bash
curl -X GET "http://localhost:8081/v1/sessions?search_query=San%20Francisco"
```

---

## Connection Requests

### Request Connection (Consumer)

Consumer requests to connect to a provider's session.

**Endpoint**: `POST /v1/sessions/{session_id}/request`

**Request Body**:
```json
{
  "consumer_id": "string",
  "consumer_name": "string"
}
```

**Response**:
```json
{
  "request_id": "uuid",
  "success": true,
  "message": "Connection request sent"
}
```

**Example**:
```bash
curl -X POST http://localhost:8081/v1/sessions/SESSION_ID/request \
  -H "Content-Type: application/json" \
  -d '{
    "consumer_id": "consumer-456",
    "consumer_name": "Jane Smith"
  }'
```

---

### Watch Connection Requests (Provider - SSE)

**Note**: This is a **Server-Sent Events (SSE)** endpoint for real-time notifications.

**Endpoint**: `GET /v1/sessions/{session_id}/requests/watch`

**Response** (streaming):
```
event: connection_request
data: {"request_id":"uuid","consumer_id":"consumer-456","consumer_name":"Jane Smith","requested_at":1704567890}

event: connection_request
data: {"request_id":"uuid2","consumer_id":"consumer-789","consumer_name":"Bob Johnson","requested_at":1704567900}
```

**JavaScript Example**:
```javascript
const eventSource = new EventSource(
  `http://localhost:8081/v1/sessions/${sessionId}/requests/watch`
);

eventSource.addEventListener('connection_request', (event) => {
  const request = JSON.parse(event.data);
  console.log('New connection request:', request);
});
```

---

### Approve Connection Request (Provider)

Approve a consumer's connection request.

**Endpoint**: `POST /v1/sessions/requests/{request_id}/approve`

**Response**:
```json
{
  "success": true,
  "session_id": "uuid",
  "token": "consumer-auth-token"
}
```

**Example**:
```bash
curl -X POST http://localhost:8081/v1/sessions/requests/REQUEST_ID/approve
```

---

### Deny Connection Request (Provider)

Deny a consumer's connection request.

**Endpoint**: `POST /v1/sessions/requests/{request_id}/deny`

**Request Body**:
```json
{
  "reason": "string (optional)"
}
```

**Response**:
```json
{
  "success": true
}
```

---

### Watch Approval Status (Consumer - SSE)

**Note**: This is a **Server-Sent Events (SSE)** endpoint.

**Endpoint**: `GET /v1/sessions/requests/{request_id}/approval/watch`

**Response** (streaming):
```
event: approval_update
data: {"status":"PENDING","message":"Request is pending"}

event: approval_update
data: {"status":"APPROVED","session_id":"uuid","token":"auth-token","message":"Connection approved"}
```

**Status Values**:
- `PENDING`: Request is awaiting provider approval
- `APPROVED`: Request was approved
- `DENIED`: Request was denied

---

## WebRTC Signaling

### Send WebRTC Signal

Send SDP offers, answers, or ICE candidates between peers.

**Endpoint**: `POST /v1/webrtc/signal`

**Request Body**:
```json
{
  "session_id": "uuid",
  "from_device_id": "string",
  "to_device_id": "string",
  "type": "OFFER | ANSWER | ICE_CANDIDATE",
  "payload": "JSON-encoded SDP or ICE candidate"
}
```

**Signal Types**:
- `OFFER` (0): SDP offer from provider
- `ANSWER` (1): SDP answer from consumer
- `ICE_CANDIDATE` (2): ICE candidate from either peer

**Response**:
```json
{
  "success": true,
  "message": "Signal sent"
}
```

**Example - Send Offer**:
```bash
curl -X POST http://localhost:8081/v1/webrtc/signal \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "SESSION_ID",
    "from_device_id": "provider-123",
    "to_device_id": "consumer-456",
    "type": "OFFER",
    "payload": "{\"type\":\"offer\",\"sdp\":\"v=0\\r\\no=...\"}"
  }'
```

---

### Watch WebRTC Signals (SSE)

**Note**: This is a **Server-Sent Events (SSE)** endpoint.

**Endpoint**: `GET /v1/webrtc/signals/watch`

**Query Parameters**:
- `session_id`: Session ID
- `device_id`: The device ID watching for signals

**Response** (streaming):
```
event: webrtc_signal
data: {"session_id":"uuid","from_device_id":"provider-123","to_device_id":"consumer-456","type":"OFFER","payload":"..."}

event: webrtc_signal
data: {"session_id":"uuid","from_device_id":"consumer-456","to_device_id":"provider-123","type":"ANSWER","payload":"..."}
```

**JavaScript Example**:
```javascript
const eventSource = new EventSource(
  `http://localhost:8081/v1/webrtc/signals/watch?session_id=${sessionId}&device_id=${deviceId}`
);

eventSource.addEventListener('webrtc_signal', (event) => {
  const signal = JSON.parse(event.data);
  
  if (signal.type === 'OFFER') {
    // Handle offer
  } else if (signal.type === 'ANSWER') {
    // Handle answer
  } else if (signal.type === 'ICE_CANDIDATE') {
    // Handle ICE candidate
  }
});
```

---

## Heartbeat

Keep sessions alive with periodic heartbeat requests.

**Endpoint**: `POST /v1/sessions/{session_id}/heartbeat`

**Request Body**:
```json
{
  "token": "auth-token",
  "role": "provider | consumer"
}
```

**Response**:
```json
{
  "active": true,
  "session_duration_ms": 123456
}
```

**Example**:
```bash
curl -X POST http://localhost:8081/v1/sessions/SESSION_ID/heartbeat \
  -H "Content-Type: application/json" \
  -d '{
    "token": "YOUR_TOKEN",
    "role": "provider"
  }'
```

**Recommended**: Send heartbeat every 30 seconds to keep session active.

---

## Error Handling

All errors follow this standard format:

```json
{
  "error": {
    "code": "NOT_FOUND | INTERNAL | INVALID_ARGUMENT | PERMISSION_DENIED",
    "message": "Human-readable error message"
  }
}
```

**HTTP Status Codes**:
- `200`: Success
- `400`: Bad Request (invalid parameters)
- `404`: Not Found (session/request doesn't exist)
- `403`: Forbidden (invalid token)
- `500`: Internal Server Error

---

## JavaScript Examples

### Complete Provider Flow

```javascript
class ProviderClient {
  constructor(baseUrl = 'http://localhost:8081') {
    this.baseUrl = baseUrl;
    this.sessionId = null;
    this.token = null;
  }

  async createSession(providerName, location) {
    const response = await fetch(`${this.baseUrl}/v1/sessions`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        provider_id: this.generateId(),
        provider_name: providerName,
        location: location
      })
    });
    
    const data = await response.json();
    this.sessionId = data.session_id;
    this.token = data.token;
    
    return data;
  }

  watchConnectionRequests(onRequest) {
    const eventSource = new EventSource(
      `${this.baseUrl}/v1/sessions/${this.sessionId}/requests/watch`
    );
    
    eventSource.addEventListener('connection_request', (event) => {
      const request = JSON.parse(event.data);
      onRequest(request);
    });
    
    return eventSource;
  }

  async approveRequest(requestId) {
    const response = await fetch(
      `${this.baseUrl}/v1/sessions/requests/${requestId}/approve`,
      { method: 'POST' }
    );
    
    return await response.json();
  }

  async denyRequest(requestId, reason) {
    const response = await fetch(
      `${this.baseUrl}/v1/sessions/requests/${requestId}/deny`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reason })
      }
    );
    
    return await response.json();
  }

  async sendWebRTCSignal(toDeviceId, type, payload) {
    const response = await fetch(`${this.baseUrl}/v1/webrtc/signal`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        session_id: this.sessionId,
        from_device_id: 'provider-' + this.generateId(),
        to_device_id: toDeviceId,
        type: type,
        payload: JSON.stringify(payload)
      })
    });
    
    return await response.json();
  }

  async endSession() {
    const response = await fetch(
      `${this.baseUrl}/v1/sessions/${this.sessionId}?token=${this.token}`,
      { method: 'DELETE' }
    );
    
    return await response.json();
  }

  generateId() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }
}
```

### Complete Consumer Flow

```javascript
class ConsumerClient {
  constructor(baseUrl = 'http://localhost:8081') {
    this.baseUrl = baseUrl;
    this.sessionId = null;
    this.token = null;
    this.requestId = null;
  }

  async listSessions(searchQuery = '') {
    const url = searchQuery 
      ? `${this.baseUrl}/v1/sessions?search_query=${encodeURIComponent(searchQuery)}`
      : `${this.baseUrl}/v1/sessions`;
    
    const response = await fetch(url);
    return await response.json();
  }

  async requestConnection(sessionId, consumerName) {
    const response = await fetch(
      `${this.baseUrl}/v1/sessions/${sessionId}/request`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          consumer_id: this.generateId(),
          consumer_name: consumerName
        })
      }
    );
    
    const data = await response.json();
    this.requestId = data.request_id;
    this.sessionId = sessionId;
    
    return data;
  }

  watchApprovalStatus(onUpdate) {
    const eventSource = new EventSource(
      `${this.baseUrl}/v1/sessions/requests/${this.requestId}/approval/watch`
    );
    
    eventSource.addEventListener('approval_update', (event) => {
      const update = JSON.parse(event.data);
      
      if (update.status === 'APPROVED') {
        this.token = update.token;
      }
      
      onUpdate(update);
    });
    
    return eventSource;
  }

  async sendWebRTCSignal(toDeviceId, type, payload) {
    const response = await fetch(`${this.baseUrl}/v1/webrtc/signal`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        session_id: this.sessionId,
        from_device_id: 'consumer-' + this.generateId(),
        to_device_id: toDeviceId,
        type: type,
        payload: JSON.stringify(payload)
      })
    });
    
    return await response.json();
  }

  generateId() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }
}
```

### Usage Example

```javascript
// Provider side
const provider = new ProviderClient();

// Create session
await provider.createSession('John Doe', 'San Francisco');
console.log('Session created:', provider.sessionId);

// Watch for connection requests
const requestWatcher = provider.watchConnectionRequests((request) => {
  console.log('New connection request from:', request.consumer_name);
  
  // Auto-approve for demo (in real app, show UI prompt)
  provider.approveRequest(request.request_id);
});

// Send WebRTC offer
await provider.sendWebRTCSignal('consumer-123', 'OFFER', {
  type: 'offer',
  sdp: 'v=0...'
});

// Consumer side
const consumer = new ConsumerClient();

// List available sessions
const sessions = await consumer.listSessions();
console.log('Available providers:', sessions.sessions);

// Request connection to first session
await consumer.requestConnection(sessions.sessions[0].session_id, 'Jane Smith');

// Watch for approval
const approvalWatcher = consumer.watchApprovalStatus((update) => {
  console.log('Approval status:', update.status);
  
  if (update.status === 'APPROVED') {
    console.log('Connected! Token:', consumer.token);
    // Start WebRTC flow
  }
});
```

---

## CORS Configuration

The backend includes CORS support for web browsers:

```javascript
// All origins allowed in development
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
```

**Production**: Update CORS settings to restrict to your Lovable app domain.

---

## Important Notes

### Streaming Limitations

- **gRPC Bidirectional Streaming** (like `ProviderStream`, `ConsumerStream`) is **NOT available** via REST/HTTP
- For real-time updates, use **Server-Sent Events (SSE)** as documented above
- For WebRTC video streaming, establish direct peer-to-peer connection after signaling

### Security Best Practices

1. **Always use HTTPS in production**
2. **Store tokens securely** (never in localStorage for sensitive apps)
3. **Validate all user inputs** before sending to API
4. **Implement rate limiting** in your Lovable app
5. **Set proper CORS origins** in production

### Recommended Architecture

```
Lovable Web App
    ↓
REST API (HTTP/JSON)
    ↓
gRPC Gateway (Port 8081)
    ↓
gRPC Backend (Port 8080)
    ↓
Session Cache / Database
```

---

## Testing the API

Use the test script:

```bash
cd backend
./test-session.sh
```

Or use the Makefile:

```bash
make test
```

---

## Support

For issues or questions:
- Check [GRPC_GATEWAY.md](./backend/GRPC_GATEWAY.md) for low-level details
- Review [proto/inventory_service.proto](./proto/inventory_service.proto) for message schemas
- See [TESTING.md](./TESTING.md) for testing guides

---

**Last Updated**: 2026-01-06
