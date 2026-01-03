# Cloud Run Deployment - Remote Inventory Backend

## ✅ Deployment Complete

**Service URL**: https://remote-inventory-backend-mlwjajxybq-uc.a.run.app  
**gRPC Endpoint**: `remote-inventory-backend-mlwjajxybq-uc.a.run.app:443` (TLS enabled)

**Project**: events-360world  
**Region**: us-central1  
**Revision**: remote-inventory-backend-00002-qx4

---

## 🔧 Issues Fixed During Deployment

1. **Go Version**: Updated Dockerfile from Go 1.21 to Go 1.24
2. **Protobuf Package**: Corrected `go_package` path and regenerated all .pb.go files
3. **Server API**: Fixed function name to `RegisterRemoteInventoryServiceServer`
4. **Gateway**: Disabled gateway.go (missing HTTP annotations in proto)
5. **Platform**: Added `--platform linux/amd64` for Cloud Run compatibility

---

## 📱 Flutter App Configuration

Update your gRPC clients to use the Cloud Run endpoint:

### Provider App
File: `provider_app/lib/services/grpc_client.dart` or config

```dart
final channel = ClientChannel(
  'remote-inventory-backend-mlwjajxybq-uc.a.run.app',
  port: 443,
  options: const ChannelOptions(
    credentials: ChannelCredentials.secure(),
  ),
);
```

### Consumer App  
File: `consumer_app/lib/services/grpc_client.dart` or config

```dart
final channel = ClientChannel(
  'remote-inventory-backend-mlwjajxybq-uc.a.run.app',
  port: 443,
  options: const ChannelOptions(
    credentials: ChannelCredentials.secure(),
  ),
);
```

---

## 🧪 Testing the Deployment

### Test gRPC Service Discovery
```bash
grpcurl remote-inventory-backend-mlwjajxybq-uc.a.run.app:443 list
```

### Test CreateSession RPC
```bash
grpcurl -d '{"provider_id":"test","provider_name":"Test Provider"}' \
  remote-inventory-backend-mlwjajxybq-uc.a.run.app:443 \
  inventory.RemoteInventoryService/CreateSession
```

---

## 📊 Monitoring & Logs

### View Recent Logs
```bash
gcloud run services logs read remote-inventory-backend \
  --region us-central1 \
  --limit 50
```

### View in Console
https://console.cloud.google.com/run/detail/us-central1/remote-inventory-backend

---

## 🚀 Deployment Command

For future updates:
```bash
cd backend
./deploy.sh
```

The script will:
1. Build Docker image for AMD64
2. Push to Google Container Registry
3. Deploy to Cloud Run
4. Display the service URL
