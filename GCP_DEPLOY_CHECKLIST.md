# GCP Deployment Checklist

## Current Status

✅ **gcloud SDK**: Installed  
✅ **Docker**: Installed (v28.1.1)  
✅ **Project**: `test-instance`  
❌ **Authentication**: Not logged in

## Next Steps

### 1. Authenticate with Google Cloud

```bash
gcloud auth login
```

This will open a browser window for you to log in with your Google account.

### 2. Configure Docker for GCR

```bash
gcloud auth configure-docker
```

### 3. Verify Project

```bash
gcloud config get-value project
```

Should show: `test-instance`

If you want to use a different project:
```bash
gcloud config set project YOUR_PROJECT_ID
```

### 4. Enable Required APIs

```bash
# Enable Cloud Run API
gcloud services enable run.googleapis.com

# Enable Container Registry API  
gcloud services enable containerregistry.googleapis.com

# Enable Cloud Build API (optional, for faster builds)
gcloud services enable cloudbuild.googleapis.com
```

### 5. Deploy

Once authenticated, run:
```bash
cd backend
./deploy.sh
```

The deployment script will:
- Build Docker image
- Push to Google Container Registry
- Deploy to Cloud Run
- Configure environment (ports 8080 & 8081)
- Display service URL

## Environment Configuration

The backend will be deployed with:
- **Memory**: 2GB
- **CPU**: 2 cores
- **Timeout**: 300 seconds
- **Region**: us-central1
- **Environment Variables**:
  - GRPC_PORT=8080
  - HTTP_PORT=8081

## After Deployment

You'll receive a service URL like:
```
https://remote-inventory-backend-abc123-uc.a.run.app
```

Update your Flutter apps and web demo with this URL.

## Estimated Cost

For light usage (~100 requests/day):
- **Compute**: $5-10/month
- **Container Registry**: $1-2/month
- **Total**: ~$10-15/month

Cold starts are free (min-instances=0).

---

**Ready to deploy?** Run the commands above in order.
