# Remote Inventory View App

A privacy-first remote inventory viewing application with JARVIS-themed aesthetics. Enables a Consumer to remotely view a Provider's camera feed with **100% guaranteed privacy** - all faces and body parts are automatically blurred.

## 🎯 Features

### Privacy-First Architecture
- **100% Face & Body Blurring**: ML-powered detection ensures no identifiable features are ever visible
- **Fallback Protection**: Entire frame blurred if detection confidence is low
- **Real-time Processing**: 100-200ms acceptable latency with smooth frame delivery

### Provider App (Camera Side)
- 📹 Real-time camera streaming with privacy layer
- 🎯 AR-style guidance overlay with directional arrows
- 🔴 Laser pointer visualization
- 📱 Sensor-based navigation (accelerometer, compass)
- ⏹️ Instant stop command response
- 🎨 JARVIS-themed Material Design 3 UI

### Consumer App (Controller Side)
- 🎮 Gaming controller-style interface
- 👆 **Touch Controls**:
  - Swipe: Navigate provider (left/right/up/down)
  - Pinch: Zoom in/out
  - Long Press: Activate laser pointer
  - Double Tap: Emergency stop
- 🗣️ **Voice Commands**: Natural language navigation
- ⌨️ **Text Commands**: Typed instructions
- 📺 Privacy-blurred video feed viewer
- 📝 Command history display

### Backend (Cloud Run)
- 🚀 Go-based gRPC services
- 🔐 Session management with token authentication
- 🎬 Video streaming pipeline with privacy processing
- 📡 Real-time command relay
- ☁️ Cloud Run deployment ready

## 🏗️ Architecture

```
┌──────────────────┐         ┌──────────────────┐
│  Provider App    │         │  Consumer App    │
│   (Flutter)      │         │   (Flutter)      │
│                  │         │                  │
│  • Camera Stream │         │  • Touch Control │
│  • AR Guidance   │         │  • Voice Input   │
│  • Privacy Ind.  │         │  • Video View    │
└────────┬─────────┘         └─────────┬────────┘
         │                             │
         │ gRPC (8080)                │ gRPC (8080)
         │                             │
         └──────────┬──────────────────┘
                    │
         ┌──────────▼──────────┐
         │   Backend Server    │
         │   (Go + gRPC)       │◄─── HTTP/REST (8081)
         │                     │         │
         │  • Session Mgmt     │     ┌───▼────────┐
         │  • Privacy Layer    │     │ Web Demo   │
         │  • Command Relay    │     │ (Browser)  │
         │  • gRPC-Gateway     │     └────────────┘
         └─────────────────────┘
```

## 📁 Project Structure

```
remote-inventory/
├── backend/               # Go gRPC backend
│   ├── server/           # gRPC server implementation
│   ├── session/          # Session management
│   ├── privacy/          # ML privacy processing
│   ├── proto/            # Generated protobuf code
│   └── Dockerfile        # Cloud Run deployment
├── provider_app/         # Flutter App (Merged Provider + Consumer)
│   └── lib/
│       ├── screens/      # All screens (provider & consumer modes)
│       │   ├── camera_screen.dart
│       │   ├── consumer_mode_screen.dart
│       │   ├── provider_mode_screen.dart  
│       │   ├── controller_screen.dart
│       │   ├── search_landing_screen.dart
│       │   └── auth/     # Authentication screens
│       ├── widgets/      # Guidance overlay, touch controller
│       ├── services/     # GRPC, WebRTC, auth services
│       └── main.dart     # Entry point
├── proto/                # Protobuf definitions
│   └── inventory_service.proto
└── shared/               # Shared theme
    └── theme/
        └── jarvis_theme.dart
```

## 🚀 Getting Started

### Prerequisites

- **Flutter**: 3.1.0 or higher
- **Go**: 1.21 or higher
- **Docker**: For backend deployment

### Backend Setup

```bash
cd backend
make run
```

### App Setup (Unified Provider + Consumer)

```bash
cd provider_app

# Install dependencies
flutter pub get

# Run on device
flutter run
```

## 🎨 JARVIS Theme

The app features a futuristic JARVIS-inspired design:
- **Primary Color**: Cyan (#00D9FF) with neon glow effects
- **Background**: Dark navy (#0A0E27) with gradient overlays
- **Effects**: Glassmorphism, neon glow, smooth animations
- **Typography**: Material Design 3 with custom shadows

## 🔒 Privacy Guarantee

The system employs multiple layers of privacy protection:

1. **Face Detection**: Haar Cascade classifier detects all faces
2. **Body Detection**: HSV-based skin tone detection identifies body regions
3. **Region Expansion**: Detected regions expanded by 25% for coverage
4. **Strong Blurring**: Gaussian blur with kernel size 51
5. **Fallback**: Entire frame blurred if confidence < 70%
6. **Filler Frames**: Smooth playback during processing delays

**No face or identifiable body part will ever be transmitted.**

## 📱 Control Methods

### Touch Gestures
- **Swipe Left/Right**: Navigate provider horizontally
- **Swipe Up/Down**: Navigate provider vertically
- **Pinch In/Out**: Zoom camera view
- **Long Press**: Activate laser pointer at touch location
- **Double Tap**: Send emergency stop command

### Voice Commands
Speak naturally:
- "Move left" / "Go right"
- "Look up" / "Look down"
- "Move forward" / "Go back"
- "Stop"

### Text Commands
Type any navigation instruction in the text field.

## ☁️ Cloud Run Deployment

```bash
cd backend

# Set your GCP project ID
export PROJECT_ID=your-project-id

# Deploy to Cloud Run
gcloud builds submit --tag gcr.io/$PROJECT_ID/remote-inventory-backend

gcloud run deploy remote-inventory-backend \
  --image gcr.io/$PROJECT_ID/remote-inventory-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 2Gi \
  --cpu 2
```

## 🧪 Testing

**Backend Tests**:
```bash
cd backend
go test ./...
```

**Flutter Tests**:
```bash
cd provider_app && flutter test
```

**Privacy Layer Test**:
```bash
cd backend
go test -v ./privacy -run TestPrivacyGuarantee
```

## 🎯 Usage Flow

1. **Provider**: Launch Provider app, enter name, start session
2. **Provider**: Share session ID with Consumer
3. **Consumer**: Launch Consumer app, enter session ID, join
4. **Consumer**: Use touch/voice/text to navigate Provider
5. **Provider**: Follow AR guidance overlay
6. **Consumer**: View privacy-blurred feed, control inventory browsing

## 🔧 Configuration

Update backend endpoint in the app:
- File: `provider_app/lib/services/grpc_client.dart`

Default: `localhost:8080` (development)

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

Contributions welcome! Please read CONTRIBUTING.md for guidelines.

## 🐛 Known Limitations

- Privacy processing adds 100-200ms latency (acceptable for use case)
- Requires stable internet connection for real-time streaming
- OpenCV installation required for backend (included in Docker)
- Voice recognition requires microphone permissions

## 📞 Support

For issues or questions, please open a GitHub issue.

---

**Built with ❤️ using Flutter, Go, gRPC, and OpenCV**
