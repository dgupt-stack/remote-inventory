# Release Notes - v1.2.0 (Build 3)

**Release Date**: January 12, 2026  
**Build Number**: 1.2.0+3

---

## 🎯 What's New - REAL Changes This Time!

### ✅ Provider Discovery with Geocoding (WORKING!)
- **Real Backend Integration**: Consumer search now calls actual backend API
- **Geocoded Addresses**: Providers shown with readable "City, State" format
- **GPS Coordinates**: Provider sessions created with lat/lng for backend geocoding
- **Active Call Filtering**: Backend hides providers who are currently in calls

### ✅ Provider Waiting Screen
- **No Immediate Camera**: Camera does NOT activate when "Become Provider" is clicked
- **Waiting Screen First**: Providers see a professional waiting screen  
- **GPS Integration**: Location automatically captured and geocoded
- **Session Display**: Shows provider name and location while waiting

### ✅ Real Backend Calls
- `ListSessions` → Returns actual providers from backend
- `CreateSession` → Sends GPS coordinates (lat/lng)
- Backend geocodes location → Returns formatted address
- Proto files regenerated with new `formatted_address`, `latitude`, `longitude` fields

---

## 🔧 Technical Improvements

### Backend
- Geocoding service operational (OpenStreetMap Nominatim)
- Session tracking with `InActiveCall` status
- ListSessions filters busy providers
- Proto schema updated and synced

### Frontend
- Flutter proto files regenerated successfully
- SessionService uses GPS and geocoded addresses
- Navigation flows to waiting screen instead of camera
- Version properly bumped to 1.2.0

---

## ⚠️ Known Issues

### Connection Flow (Next Release)
- ❌ **Issue**: Clicking "Connect" on a provider doesn't initiate connection yet
- **Reason**: RequestConnection RPC not wired to consumer UI
- **Workaround**: None
- **ETA**: v1.3.0

### Camera Activation on Connection
- ❌ **Issue**: Provider camera doesn't activate when consumer connects
- **Reason**: WatchConnectionRequests streaming not fully implemented
- **Workaround**: None  
- **ETA**: v1.3.0

### Privacy Face Blurring
- ❌ **Issue**: Face detection/blurring temporarily disabled
- **Reason**: ML Kit dependency conflicts
- **Workaround**: None
- **ETA**: Future release

---

## 🧪 Testing Instructions

### As a Provider
1. **Click "Become Provider"** → GPS permission prompt
2. **Grant location** → Session created with coordinates
3. **See waiting screen** → "ONLINE" status with your location
4. **Camera status** → Does NOT activate (as designed) ✅
5. **Location displayed** → Shows geocoded address ✅
6. **Click "Go Offline"** → Returns to search screen

### As a Consumer
1. **Open app** → See search screen
2. **Wait for providers** → Backend call happens automatically
3. **View providers** → Should see any online providers with addresses ✅
4. **Search by location** → Filter works on provider addresses
5. **Click "Connect"** → ⚠️ Nothing happens yet (v1.3.0 feature)

---

## 📊 What Actually Works Now

✅ **Backend Geocoding**: GPS → "San Francisco, CA"  
✅ **Provider List**: Real backend call, not mock data  
✅ **Waiting Screen**: No camera until consumer connects  
✅ **GPS Collection**: Automatic location capture  
✅ **Session Tracking**: Providers marked as busy  
✅ **Proto Sync**: Flutter <→ Backend schemas match  

---

## 🚧 Next Steps (v1.3.0)

1. **Connection Request Flow**:
   - Wire up "Connect" button
   - Provider sees incoming connection request dialog
   - Provider approves/denies

2. **Camera Activation**:
   - Provider camera activates ONLY after approval
   - Consumer receives video stream
   - Provider camera stops when consumer disconnects

3. **Debug Features**:
   - In-app screenshot capture
   - Better error reporting

---

## 💬 Key Differences from v1.1.0

| Feature | v1.1.0 | v1.2.0 |
|---------|--------|--------|
| Backend Geocoding | ✅ Ready | ✅ Ready |
| Proto Files Synced | ❌ No | ✅ Yes |
| Real Backend Calls | ❌ No | ✅ Yes |
| Provider Waiting Screen | ❌ No | ✅ Yes |
| GPS Sent to Backend | ❌ No | ✅ Yes |
| **Visible UI Changes** | ❌ None | ✅ Multiple |

---

## 🐛 Reporting Issues

**Found a bug?**
1. Take a screenshot
2. Note which screen you were on
3. Describe expected vs actual behavior
4. Share via email

**Coming soon**: In-app screenshot button!

---

## 💡 Summary

This release delivers the **first visible improvements** to the provider-consumer flow:
- Providers go to waiting screen (not camera)
- Consumer search calls real backend
- Addresses are geocoded and readable
- GPS coordinates sent and processed

The **connection flow** (consumer → provider → camera) will complete in v1.3.0.

Thank you for testing!
