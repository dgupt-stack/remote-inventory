#!/bin/bash

# Quick Deployment Setup Script
# Prepares environment for Cloud Run deployment

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Cloud Run Deployment Setup${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Step 1: Check gcloud authentication
echo -e "${YELLOW}Step 1/4: Checking gcloud authentication...${NC}"
if gcloud auth list 2>&1 | grep -q "ACTIVE"; then
    echo -e "${GREEN}✓ Already authenticated${NC}"
else
    echo -e "${YELLOW}⚠️  Not authenticated${NC}"
    echo "Please run: gcloud auth login"
    echo "This will open a browser for you to sign in."
    echo ""
    read -p "Press Enter after you've authenticated..."
fi
echo ""

# Step 2: Check Docker
echo -e "${YELLOW}Step 2/4: Checking Docker...${NC}"
if docker info > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Docker is running${NC}"
else
    echo -e "${RED}✗ Docker is not running${NC}"
    echo "Please start Docker Desktop and try again."
    exit 1
fi
echo ""

# Step 3: Configure Docker for GCR
echo -e "${YELLOW}Step 3/4: Configuring Docker for Google Container Registry...${NC}"
if gcloud auth configure-docker --quiet; then
    echo -e "${GREEN}✓ Docker configured for GCR${NC}"
else
    echo -e "${RED}✗ Failed to configure Docker${NC}"
    exit 1
fi
echo ""

# Step 4: Enable Required APIs
echo -e "${YELLOW}Step 4/4: Enabling required Google Cloud APIs...${NC}"

PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
echo "Project: $PROJECT_ID"

echo "Enabling Cloud Run API..."
gcloud services enable run.googleapis.com --project=$PROJECT_ID --quiet

echo "Enabling Container Registry API..."
gcloud services enable containerregistry.googleapis.com --project=$PROJECT_ID --quiet

echo "Enabling Artifact Registry API..."
gcloud services enable artifactregistry.googleapis.com --project=$PROJECT_ID --quiet

echo -e "${GREEN}✓ APIs enabled${NC}"
echo ""

echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "Ready to deploy! Run:"
echo "  cd backend && ./deploy.sh"
echo ""
