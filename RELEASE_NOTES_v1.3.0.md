# v1.3.0 - Connection Request Flow (Complete)

**📅 Released**: January 12, 2026  
**🔢 Build**: 1.3.0+4

---

## 🎉 What's New

### Full Connection Request Flow
- **Consumer → Provider Requests**: Tap "Connect" to send requests to providers
- **Real-time Notifications**: Providers instantly see incoming connection requests
- **Approval Dialog**: Beautiful JARVIS-themed approval UI with Accept/Reject
- **Camera Activation**: Camera only activates *after* provider approves
- **Status Watching**: Consumers see live approval/denial status

### Backend Improvements
- Streaming gRPC RPCs for real-time request/approval watching
- Session cache tracks connection requests and statuses
- Request lifecycle: pending → approved/denied
- Proper error handling and logging

### UI Enhancements
- Waiting dialog with spinner during approval
- Success/error notifications with JARVIS theme
- Cancel button for consumers
- Clean navigation flows

---

## 🧪 How to Test

### Device 1 (Provider):
1. Tap "Become Provider"
2. Grant location permission
3. See waiting screen → Wait for requests
4. When request arrives → Tap "Accept"
5. Camera activates → Provider Mode

### Device 2 (Consumer):
1. See provider list with addresses
2. Tap "Connect" on a provider
3. See "Waiting for approval..." dialog
4. Provider approves → Success notification
5. (Video viewer coming in v1.4.0)

---

## 🔧 Technical Details

### New RPCs:
- `RequestConnection`: Consumer initiates request
- `WatchConnectionRequests`: Provider streams incoming requests
- `ApproveConnection`: Provider accepts connection
- `DenyConnection`: Provider rejects connection
- `WatchApprovalStatus`: Consumer watches for  approval/denial

### Session Cache:
- `ConnectionRequest` struct tracks request state
- Methods: `AddConnectionRequest`, `ApproveRequest`, `DenyRequest`
- Pending requests stored per session

### Files Modified:
- `backend/cache/session_cache.go` - Request tracking
- `backend/server/connection_handlers.go` - **NEW** RPC handlers
- `provider_app/lib/services/session_service.dart` - Request methods
- `provider_app/lib/screens/search_landing_screen.dart` - Connect button
- `provider_app/lib/screens/provider_waiting_screen.dart` - Request watching

---

## 🐛 Known Issues

- Camera permission must be granted before becoming provider
- No consumer video viewer yet (v1.4.0)
- Request timeout not implemented (stays pending)
- Multiple simultaneous requests not fully tested

---

## 📋 Next Steps (v1.4.0)

- [ ] Consumer video viewer screen
- [ ] WebRTC integration for live video
- [ ] End call functionality
- [ ] Request timeout (30 seconds)
- [ ] Multiple request handling
- [ ] Provider busy status

---

## 📦 Installation

```bash
# Download APK from Firebase App Distribution
# Or build from source:
cd provider_app && flutter build apk --release
```

**APK Size**: 23.5 MB  
**Minimum SDK**: Android 6.0 (API 23)  
**Target SDK**: Android 13 (API 33)

---

## 🙏 Feedback

Test the connection flow and report issues!  
✉️ dgupt@360world.com
