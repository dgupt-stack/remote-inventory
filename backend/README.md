# Backend Scripts

This directory contains automation scripts for backend development and deployment.

## Available Scripts

### 🧪 `test.sh` - Local Testing

Tests the backend locally:
- Checks dependencies (Go,  protoc, OpenCV)
- Downloads Go modules
- Generates protobuf code
- Builds the server binary
- Verifies build success

**Usage**:
```bash
./test.sh
```

### 🚀 `deploy.sh` - Cloud Run Deployment

Automated deployment to Google Cloud Run:
- Builds Docker image
- Pushes to Google Container Registry
- Deploys to Cloud Run
- Displays service URL and endpoints

**Usage**:
```bash
./deploy.sh
```

**Prerequisites**:
- Google Cloud SDK installed and authenticated
- Docker running
- GCP project configured

**Environment Variables**:
- `GCP_PROJECT_ID` - Your GCP project ID (optional, uses current project)
- `REGION` - Deployment region (default: us-central1)
- `SERVICE_NAME` - Service name (default: remote-inventory-backend)

### 📦 `setup-googleapis.sh` - Download Google API Protos

Downloads required Google API protobuf definitions for gRPC-Gateway:
- `google/api/annotations.proto`
- `google/api/http.proto`

**Usage**:
```bash
./setup-googleapis.sh
```

This is automatically called by `make proto` if googleapis directory doesn't exist.

## Makefile Commands

### `make proto`
Generates protobuf code (Go and gRPC-Gateway):
```bash
make proto
```

Automatically downloads Google API protos if needed.

### `make build`
Builds the server binary:
```bash
make build
```

Output: `bin/server`

### `make run`
Runs the server locally:
```bash
make run
```

Starts gRPC server on port 8080 and HTTP gateway on port 8081.

### `make test`
Runs tests:
```bash
make test
```

### `make clean`
Cleans generated files:
```bash
make clean
```

### `make docker`
Builds Docker image:
```bash
make docker
```

### `make deploy`
Deploys to Cloud Run (uses deploy.sh):
```bash
make deploy
```

## Quick Start

### Local Development

1. **Setup**:
   ```bash
   ./test.sh
   ```

2. **Run**:
   ```bash
   make run
   ```

3. **Test**:
   Open `../web-demo/index.html` in browser

### Deploy to Production

1. **Configure GCP**:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **Deploy**:
   ```bash
   ./deploy.sh
   ```

3. **Verify**:
   ```bash
   curl <SERVICE_URL>/v1/sessions -X POST \
     -H "Content-Type: application/json" \
     -d '{"provider_id":"test","provider_name":"Test"}'
   ```

## Directory Structure

```
backend/
├── server/          # Server implementation
│   ├── main.go      # Entry point
│   ├── service.go   # gRPC service  
│   └── gateway.go   # HTTP gateway
├── session/         # Session management
├── privacy/         # Privacy layer
├── googleapis/      # Google API protos (generated)
├── Makefile         # Build automation
├── Dockerfile       # Container image
├── test.sh          # Local testing
├── deploy.sh        # Cloud Run deployment
└── setup-googleapis.sh # Download API protos
```

## Troubleshooting

### "protoc command not found"

Install Protocol Buffers compiler:
```bash
brew install protobuf
```

### "OpenCV not found"

Install OpenCV:
```bash
brew install opencv
```

Privacy layer requires OpenCV for face/body detection.

### "googleapis not found"

Run:
```bash
./setup-googleapis.sh
```

Or just run `make proto` - it will download automatically.

### Docker build fails

Check Docker is running:
```bash
docker ps
```

### Deployment fails

Check gcloud auth:
```bash
gcloud auth list
```

Set project:
```bash
gcloud config set project YOUR_PROJECT_ID
```

## See Also

- [../DEPLOYMENT.md](../DEPLOYMENT.md) - Full deployment guide
- [GRPC_GATEWAY.md](GRPC_GATEWAY.md) - HTTP API documentation
- [../README.md](../README.md) - Project overview
