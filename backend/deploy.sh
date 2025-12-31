#!/bin/bash

# Cloud Run Deployment Script for Remote Inventory Backend

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Remote Inventory - Cloud Run Deployment${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Check for gcloud
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI not found${NC}"
    echo "Please install Google Cloud SDK:"
    echo "  https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Configuration
PROJECT_ID="${GCP_PROJECT_ID:-$(gcloud config get-value project)}"
REGION="${REGION:-us-central1}"
SERVICE_NAME="${SERVICE_NAME:-remote-inventory-backend}"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo -e "${YELLOW}Configuration:${NC}"
echo "  Project ID: ${PROJECT_ID}"
echo "  Region: ${REGION}"
echo "  Service: ${SERVICE_NAME}"
echo "  Image: ${IMAGE_NAME}"
echo ""

# Confirm
read -p "Deploy with these settings? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Deployment cancelled${NC}"
    exit 0
fi

# Step 1: Build Docker image
echo -e "${BLUE}Step 1: Building Docker image...${NC}"
docker build -t ${IMAGE_NAME} .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker image built successfully${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi

# Step 2: Push to Google Container Registry
echo ""
echo -e "${BLUE}Step 2: Pushing image to GCR...${NC}"
docker push ${IMAGE_NAME}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Image pushed to GCR${NC}"
else
    echo -e "${RED}❌ Push to GCR failed${NC}"
    exit 1
fi

# Step 3: Deploy to Cloud Run
echo ""
echo -e "${BLUE}Step 3: Deploying to Cloud Run...${NC}"
gcloud run deploy ${SERVICE_NAME} \
    --image ${IMAGE_NAME} \
    --platform managed \
    --region ${REGION} \
    --allow-unauthenticated \
    --memory 2Gi \
    --cpu 2 \
    --timeout 300 \
    --max-instances 10 \
    --min-instances 0 \
    --set-env-vars="GRPC_PORT=8080,HTTP_PORT=8081" \
    --port 8080

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}✅ Deployment Successful!${NC}"
    echo -e "${GREEN}================================================${NC}"
    
    # Get service URL
    SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} \
        --platform managed \
        --region ${REGION} \
        --format 'value(status.url)')
    
    echo ""
    echo -e "${GREEN}Service URL:${NC} ${SERVICE_URL}"
    echo ""
    echo -e "${YELLOW}API Endpoints:${NC}"
    echo "  gRPC: ${SERVICE_URL}:443"
    echo "  HTTP: ${SERVICE_URL}"
    echo ""
    echo -e "${YELLOW}Test the deployment:${NC}"
    echo "  curl ${SERVICE_URL}/v1/sessions -X POST -H 'Content-Type: application/json' \\"
    echo "    -d '{\"provider_id\":\"test\",\"provider_name\":\"Test\"}'"
    echo ""
    echo -e "${YELLOW}Update your Flutter apps:${NC}"
    echo "  - Provider app: Update BACKEND_HOST to '${SERVICE_URL#https://}'"
    echo "  - Consumer app: Update BACKEND_HOST to '${SERVICE_URL#https://}'"
    echo "  - Web demo: Update API_BASE in index.html"
    echo ""
else
    echo -e "${RED}❌ Cloud Run deployment failed${NC}"
    exit 1
fi
