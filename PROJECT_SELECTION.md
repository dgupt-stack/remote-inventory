# Cloud Run Deployment - Project Selection

## Available GCP Projects

You have 10 projects available:

1. **atlantean-tide-482812-d5** - My First Project
2. **events-360world** - Events-360world  
3. **gen-lang-client-0092869167** - Default Gemini Project
4. **gen-lang-client-0101781834** - Default Gemini Project
5. **gen-lang-client-0231004048** - Default Gemini Project
6. **gen-lang-client-0940104668** - Default Gemini Project
7. **neat-planet-476010-n9** - My First Project
8. **sonorous-study-480906-h2** - My First Project
9. **sunlit-theory-482704-g4** - My First Project
10. **vast-math-481201-e1** - My First Project

## Recommended Project

**events-360world** - This seems most appropriate for the Remote Inventory app.

## To Deploy

```bash
# Set the project
gcloud config set project events-360world

# Enable required APIs
gcloud services enable \
  run.googleapis.com \
  containerregistry.googleapis.com \
  artifactregistry.googleapis.com

# Deploy backend
cd backend && ./deploy.sh
```

## Required Before Deployment

- ✅ gcloud authenticated
- ✅ Docker configured for GCR
- ❓ Docker running? (Check Docker Desktop)
- [ ] Project selected
- [ ] APIs enabled
