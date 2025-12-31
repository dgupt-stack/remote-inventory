# gRPC-Gateway Integration

This document explains how to use the gRPC-Gateway for web browser access.

## What is gRPC-Gateway?

gRPC-Gateway creates a REST/JSON API on top of gRPC services, allowing web browsers and clients that don't support gRPC to interact with the backend.

## Architecture

```
Web Browser (HTTP/JSON) → gRPC-Gateway (Port 8081) → gRPC Server (Port 8080)
Mobile App (gRPC)       → gRPC Server (Port 8080)
```

## HTTP Endpoints

### Session Management

**Create Session** (Provider)
```bash
POST /v1/sessions
Content-Type: application/json

{
  "provider_id": "provider-123",
  "provider_name": "John Doe"
}

Response:
{
  "session_id": "uuid-here",
  "token": "token-here",
  "success": true,
  "message": "Session created successfully"
}
```

**Join Session** (Consumer)
```bash
POST /v1/sessions/{session_id}/join
Content-Type: application/json

{
  "consumer_id": "consumer-456",
  "consumer_name": "Jane Smith"
}

Response:
{
  "session_id": "uuid-here",
  "token": "token-here",
  "success": true,
  "message": "Joined session successfully"
}
```

**End Session**
```bash
DELETE /v1/sessions/{session_id}?token=your-token

Response:
{
  "success": true
}
```

**Heartbeat**
```bash
POST /v1/sessions/{session_id}/heartbeat
Content-Type: application/json

{
  "token": "your-token",
  "role": "provider"
}

Response:
{
  "active": true,
  "session_duration_ms": 123456
}
```

## Web Client Example

```javascript
// Create a session (Provider)
async function createSession(providerName) {
  const response = await fetch('http://localhost:8081/v1/sessions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      provider_id: generateUUID(),
      provider_name: providerName,
    }),
  });
  
  return await response.json();
}

// Join a session (Consumer)
async function joinSession(sessionId, consumerName) {
  const response = await fetch(`http://localhost:8081/v1/sessions/${sessionId}/join`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      consumer_id: generateUUID(),
      consumer_name: consumerName,
    }),
  });
  
  return await response.json();
}

// Send heartbeat
async function sendHeartbeat(sessionId, token, role) {
  const response = await fetch(`http://localhost:8081/v1/sessions/${sessionId}/heartbeat`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      token: token,
      role: role,
    }),
  });
  
  return await response.json();
}

// End session
async function endSession(sessionId, token) {
  const response = await fetch(`http://localhost:8081/v1/sessions/${sessionId}?token=${token}`, {
    method: 'DELETE',
  });
  
  return await response.json();
}
```

## CORS Support

The gateway includes CORS middleware to allow web browser access:
- `Access-Control-Allow-Origin: *` (development)
- `Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS`
- `Access-Control-Allow-Headers: Content-Type, Authorization`

**Production**: Update CORS settings in `gateway.go` to restrict origins.

## Running the Gateway

The gateway starts automatically with the backend:

```bash
cd backend
make run
```

You'll see:
```
gRPC server listening on port 8080
HTTP/REST gateway listening on port 8081
```

## Environment Variables

Configure ports via environment variables:

```bash
# gRPC port (default: 8080)
export GRPC_PORT=8080

# HTTP gateway port (default: 8081)
export HTTP_PORT=8081

make run
```

## Testing the Gateway

```bash
# Test session creation
curl -X POST http://localhost:8081/v1/sessions \
  -H "Content-Type: application/json" \
  -d '{"provider_id":"test-123","provider_name":"Test Provider"}'

# Test joining a session
curl -X POST http://localhost:8081/v1/sessions/SESSION_ID/join \
  -H "Content-Type: application/json" \
  -d '{"consumer_id":"consumer-456","consumer_name":"Test Consumer"}'

# Test heartbeat
curl -X POST http://localhost:8081/v1/sessions/SESSION_ID/heartbeat \
  -H "Content-Type: application/json" \
  -d '{"token":"YOUR_TOKEN","role":"provider"}'
```

## Streaming Limitations

**Note**: gRPC bidirectional streaming (`ProviderStream` and `ConsumerStream`) is **not available** via HTTP/REST. These methods require native gRPC clients.

For streaming:
- Use native gRPC on mobile apps (Flutter with grpc package)
- Consider WebSocket fallback for web browsers
- Use Server-Sent Events (SSE) for one-way streaming

## Production Deployment

When deploying to Cloud Run:

1. Update CORS settings in `gateway.go` to your domain
2. Set environment variables in Cloud Run:
   ```bash
   gcloud run deploy --set-env-vars GRPC_PORT=8080,HTTP_PORT=8081
   ```
3. The gateway will be accessible at your Cloud Run URL

## Security Considerations

- Always use HTTPS in production
- Implement proper authentication/authorization
- Restrict CORS origins to your domain
- Use API keys or JWT tokens
- Rate limit the HTTP endpoints

---

**For more information**: See [gRPC-Gateway documentation](https://grpc-ecosystem.github.io/grpc-gateway/)
