# Web Demo - gRPC-Gateway HTTP API

This is a simple web interface to test the gRPC-Gateway HTTP/REST endpoints.

## 🚀 Quick Start

1. **Start the Backend**:
   ```bash
   cd ../backend
   make run
   ```
   
   This will start:
   - gRPC server on port 8080
   - HTTP gateway on port 8081

2. **Open the Demo**:
   ```bash
   open index.html
   ```
   
   Or simply double-click `index.html` in your file browser.

## 🎯 What You Can Test

### 1. Create Session (Provider)
- Creates a new session
- Returns session ID and authentication token
- Auto-fills the token in other forms for convenience

### 2. Join Session (Consumer)
- Joins an existing session with session ID
- Returns consumer token
- Requires a valid session ID from step 1

### 3. Send Heartbeat
- Keeps the session alive
- Shows session duration
- Requires session ID and token

### 4. End Session
- Terminates an active session
- Cleans up resources

### 5. Server Status
- Quick check if backend is running
- Tests connectivity to the HTTP gateway

## 🌐 Architecture

```
┌─────────────────┐
│   Web Browser   │
│   (This Demo)   │
└────────┬────────┘
         │ HTTP/JSON
         │ Port 8081
         ▼
┌─────────────────┐
│ gRPC-Gateway    │
│  (HTTP→gRPC)    │
└────────┬────────┘
         │ gRPC
         │ Port 8080
         ▼
┌─────────────────┐
│  gRPC Server    │
│  (Go Backend)   │
└─────────────────┘
```

## 📝 API Endpoints

- `POST /v1/sessions` - Create session
- `POST /v1/sessions/{id}/join` - Join session
- `POST /v1/sessions/{id}/heartbeat` - Send heartbeat
- `DELETE /v1/sessions/{id}` - End session

## ⚠️ Limitations

**Streaming Not Supported via HTTP**:
- Video streaming (`ProviderStream`) requires native gRPC
- Command streaming (`ConsumerStream`) requires native gRPC
- Use Flutter apps for full streaming functionality

This web demo only demonstrates the **session management** endpoints.

## 🎨 Features

- ✨ JARVIS-themed UI matching the mobile apps
- 🔄 Auto-fill convenience for session tokens
- 📊 Pretty-printed JSON responses
- ⚡ Live server status checking
- 🎯 Error handling with helpful messages

## 🔧 Troubleshooting

**"Cannot connect to server" error?**
1. Make sure backend is running: `cd ../backend && make run`
2. Check that port 8081 is not in use
3. Verify CORS is enabled in `backend/server/gateway.go`

**Session not found?**
- Sessions expire after 5 minutes of inactivity
- Send regular heartbeats to keep session alive
- Create a new session if expired

## 💡 Next Steps

For full functionality including video streaming and real-time commands:
1. Use the Provider Flutter app (camera streaming)
2. Use the Consumer Flutter app (controller interface)
3. These apps use native gRPC for bidirectional streaming

This web demo is perfect for:
- Testing the HTTP API
- Session management debugging
- Integration testing
- Quick verification that backend is working
