# Deployment Guide

This guide covers deploying the Remote Inventory backend to Google Cloud Run.

## Prerequisites

1. **Google Cloud Account** with billing enabled
2. **Google Cloud SDK** installed: https://cloud.google.com/sdk/docs/install
3. **Docker** installed on your machine
4. **gcloud CLI** authenticated:
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

## Quick Deployment

### One-Command Deploy

```bash
cd backend
./deploy.sh
```

The script will:
1. Build Docker image
2. Push to Google Container Registry
3. Deploy to Cloud Run
4. Display service URL and endpoints

### Manual Deployment

If you prefer to deploy manually:

```bash
# Set your project ID
export PROJECT_ID=your-project-id

# Build Docker image
docker build -t gcr.io/$PROJECT_ID/remote-inventory-backend .

# Push to GCR
docker push gcr.io/$PROJECT_ID/remote-inventory-backend

# Deploy to Cloud Run
gcloud run deploy remote-inventory-backend \
  --image gcr.io/$PROJECT_ID/remote-inventory-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --memory 2Gi \
  --cpu 2 \
  --set-env-vars="GRPC_PORT=8080,HTTP_PORT=8081"
```

## Configuration

### Environment Variables

Configure via Cloud Run environment variables:

- `GRPC_PORT` - gRPC server port (default: 8080)
- `HTTP_PORT` - HTTP gateway port (default: 8081)
- `PORT` - Cloud Run assigns this automatically

### Resource Allocation

Recommended settings:
- **Memory**: 2GB (for OpenCV processing)
- **CPU**: 2 cores (for video processing)
- **Timeout**: 300 seconds
- **Max Instances**: 10 (adjust based on load)
- **Min Instances**: 0 (cold start is acceptable)

### Scaling

Cloud Run auto-scales based on traffic. Configure:

```bash
gcloud run services update remote-inventory-backend \
  --max-instances 20 \
  --min-instances 1 \
  --region us-central1
```

## Updating the Deployment

After making code changes:

```bash
cd backend
./deploy.sh
```

The script will rebuild and redeploy automatically.

## Connecting Flutter Apps

After deployment, update your Flutter apps:

### 1. Get Service URL

```bash
gcloud run services describe remote-inventory-backend \
  --platform managed \
  --region us-central1 \
  --format 'value(status.url)'
```

Example: `https://remote-inventory-backend-abc123-uc.a.run.app`

### 2. Update Provider App

Edit `provider_app/lib/services/grpc_client.dart`:

```dart
GrpcClientService({
  this.host = 'remote-inventory-backend-abc123-uc.a.run.app',
  this.port = 443,  // Use 443 for HTTPS
});
```

### 3. Update Consumer App

Edit `consumer_app/lib/services/grpc_client.dart`:

```dart
GrpcClientService({
  this.host = 'remote-inventory-backend-abc123-uc.a.run.app',
  this.port = 443,  // Use 443 for HTTPS
});
```

### 4. Update Web Demo

Edit `web-demo/index.html`:

```javascript
const API_BASE = 'https://remote-inventory-backend-abc123-uc.a.run.app';
```

## Testing the Deployment

### Test HTTP Endpoints

```bash
# Get service URL
SERVICE_URL=$(gcloud run services describe remote-inventory-backend \
  --platform managed \
  --region us-central1 \
  --format 'value(status.url)')

# Test session creation
curl $SERVICE_URL/v1/sessions \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"provider_id":"test-123","provider_name":"Test Provider"}'
```

Should return:
```json
{
  "session_id": "uuid-here",
  "token": "token-here",
  "success": true,
  "message": "Session created successfully"
}
```

### Test gRPC

Use `grpcurl` (install from https://github.com/fullstorydev/grpcurl):

```bash
grpcurl -plaintext $SERVICE_URL:443 inventory.InventoryService/CreateSession
```

## Monitoring

### View Logs

```bash
gcloud run services logs read remote-inventory-backend \
  --region us-central1 \
  --limit 100
```

### Real-time Logs

```bash
gcloud run services logs tail remote-inventory-backend \
  --region us-central1
```

### Metrics

View in Google Cloud Console:
- CPU utilization
- Memory usage
- Request count
- Request latency
- Error rate

## Cost Optimization

Cloud Run pricing is based on:
- **CPU allocation**: Charged per second
- **Memory allocation**: Charged per second
- **Request count**: Free tier available

**Tips**:
1. Set `min-instances=0` to avoid charges when idle
2. Use appropriate memory/CPU (2GB/2CPU recommended)
3. Implement connection pooling
4. Cache frequently accessed data
5. Use regional deployment (cheaper than multi-region)

**Estimated costs** (light usage):
- ~$10-20/month for occasional testing
- Scale up as needed for production

## Troubleshooting

### Build Fails

Check Docker logs:
```bash
docker build -t test . --progress=plain
```

### Deployment Fails

Check service status:
```bash
gcloud run services describe remote-inventory-backend \
  --region us-central1
```

### 502 Bad Gateway

- Check logs for errors
- Verify OpenCV dependencies in Dockerfile
- Increase memory allocation

### Connection Refused

- Verify ports in environment variables
- Check firewall rules
- Ensure `allow-unauthenticated` is set

### OpenCV Not Found

Make sure Dockerfile includes:
```dockerfile
RUN apt-get install -y libopencv-dev
```

## Security

### Production Checklist

- [ ] Enable authentication (remove `--allow-unauthenticated`)
- [ ] Add API key validation
- [ ] Implement rate limiting
- [ ] Restrict CORS to specific domains
- [ ] Use Cloud Armor for DDoS protection
- [ ] Enable Cloud Logging and Monitoring
- [ ] Set up alerts for errors
- [ ] Use Secret Manager for sensitive data

### Enable Authentication

```bash
gcloud run services update remote-inventory-backend \
  --no-allow-unauthenticated \
  --region us-central1
```

Then use service accounts or Identity Platform.

## Rollback

If deployment has issues:

```bash
# List revisions
gcloud run revisions list \
  --service remote-inventory-backend \
  --region us-central1

# Rollback to previous revision
gcloud run services update-traffic remote-inventory-backend \
  --to-revisions REVISION_NAME=100 \
  --region us-central1
```

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Cloud Run

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - uses: google-github-actions/setup-gcloud@v0
        with:
          service_account_key: ${{ secrets.GCP_SA_KEY }}
          project_id: ${{ secrets.GCP_PROJECT_ID }}
      
      - name: Deploy
        run: |
          cd backend
          ./deploy.sh
```

## Support

For issues:
1. Check logs: `gcloud run services logs read`
2. Review Cloud Run documentation
3. Check GitHub issues
4. Contact support

---

**Next**: After deployment, test with the web demo and Flutter apps!
