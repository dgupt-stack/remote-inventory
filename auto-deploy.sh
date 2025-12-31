#!/bin/bash

# Automated Cloud Run Deployment
# Waits for Docker and deploys the backend

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Cloud Run Auto-Deploy${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Wait for Docker
echo -e "${YELLOW}Waiting for Docker to start...${NC}"
while ! docker info > /dev/null 2>&1; do
    echo "Docker not ready yet... (Please start Docker Desktop)"
    sleep 5
done

echo -e "${GREEN}✓ Docker is running!${NC}"
echo ""

# Enable APIs
echo -e "${YELLOW}Enabling Google Cloud APIs...${NC}"
gcloud services enable \
    run.googleapis.com \
    containerregistry.googleapis.com \
    artifactregistry.googleapis.com \
    --project=events-360world

echo -e "${GREEN}✓ APIs enabled${NC}"
echo ""

# Run deployment
echo -e "${YELLOW}Starting deployment...${NC}"
cd backend
./deploy.sh

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
