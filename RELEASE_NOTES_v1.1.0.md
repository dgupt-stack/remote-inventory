# Release Notes - v1.1.0 (Build 2)

**Release Date**: January 12, 2026  
**Build Number**: 1.1.0+2

---

## 🎯 What's New

### Provider Discovery with Geocoding
- ✅ **Real Provider List**: Consumers now see actual providers from the backend (not mock data)
- ✅ **Readable Addresses**: Provider locations shown as "City, State" instead of GPS coordinates
- ✅ **Live Updates**: Provider list refreshes to show available providers
- ✅ **Active Call Filtering**: Providers currently in calls are hidden from search

### Provider Experience Improvements
- ✅ **Waiting Screen**: Providers now see a waiting screen when going online
- ✅ **GPS Integration**: Provider location automatically geocoded to readable address
- ✅ **No Immediate Camera**: Camera does NOT activate when becoming a provider

---

## 🔧 Technical Improvements

### Backend
- Geocoding service using OpenStreetMap Nominatim API
- Session tracking with active call status
- Protobuf updated with formatted_address, latitude, longitude fields
- ListSessions API now filters providers in active calls

### Frontend
- SessionService updated to send GPS coordinates
- Consumer search displays geocoded addresses
- Provider flow navigates to waiting screen first
- Version bumped to 1.1.0 for clarity

---

## ⚠️ Known Issues

### Camera Activation
- ❌ **Issue**: Camera still does NOT activate when consumer connects
- **Reason**: Connection approval flow not yet implemented
- **Workaround**: None - this is Phase 2.5
- **ETA**: Next release

### Consumer Connection Flow
- ❌ **Issue**: Clicking "Connect" on a provider doesn't do anything yet
- **Reason**: RequestConnection RPC wiring incomplete
- **Workaround**: None
- **ETA**: Next release (Phase 2.5)

### Provider Waiting Screen
- ❌ **Issue**: No way to see incoming connection requests yet
- **Reason**: WatchConnectionRequests streaming not wired up
- **Workaround**: None
- **ETA**: Next release

---

## 🚧 Not Yet Implemented

### Phase 2.5 (Next Release)
- [ ] Provider sees incoming connection requests with consumer name
- [ ] Provider can approve/deny connection requests
- [ ] Camera activates ONLY after provider approves
- [ ] Consumer receives video stream after approval
- [ ] Provider camera stops when consumer disconnects

### Phase 3 (Future)
- [ ] In-app screenshot capture for debugging
- [ ] Multiple consumers per provider
- [ ] Provider can switch between multiple consumer requests
- [ ] Distance calculation (show how far provider is from consumer)
- [ ] Provider rating/reviews

---

## 🧪 Testing Instructions

### As a Consumer
1. **Open app** → See search screen
2. **View providers** → Should see real providers from backend (if any are online)
3. **See addresses** → Locations shown as "City, State" format
4. **Click "Connect"** → ⚠️ Nothing happens yet (known issue)

### As a Provider
1. **Click "Become Provider"** → GPS permission prompt
2. **Grant location** → Session created with GPS coordinates
3. **See waiting screen** → Shows "ONLINE" with your location
4. **Camera** → Does NOT activate yet (as designed)
5. **Click "Go Offline"** → Returns to search screen

---

## 📊 Version History

| Version | Date | Key Changes |
|---------|------|-------------|
| 1.1.0+2 | Jan 12, 2026 | Provider discovery + geocoding, waiting screen |
| 1.0.0+1 | Jan 12, 2026 | Initial merged consumer/provider app |

---

## 🐛 Reporting Issues

**Found a bug?** Since in-app screenshots aren't implemented yet:
1. Take a screenshot manually
2. Describe what you expected vs what happened
3. Include the screen you were on
4. Share via email or messenger

**Next release will have**: In-app screenshot button for easier bug reporting!

---

## 💬 Feedback Welcome

This release focuses on making providers discoverable with readable locations. The connection flow (consumer → provider → camera activation) is coming in the next release.

Questions or feedback? Let me know!
