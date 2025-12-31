.PHONY: proto build run test clean docker deploy

# Generate protobuf code
proto:
	@echo "Generating protobuf code with gRPC-Gateway..."
	protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=. --grpc-gateway_opt=paths=source_relative \
		-I../proto -I. \
		../proto/*.proto

# Build the server
build:
	@echo "Building server..."
	go build -o bin/server ./server

# Run the server locally
run:
	@echo "Running server..."
	go run ./server

# Run tests
test:
	@echo "Running tests..."
	go test -v ./...

# Clean build artifacts
clean:
	@echo "Cleaning..."
	rm -rf bin/
	rm -f proto/*.pb.go

# Build Docker image
docker:
	@echo "Building Docker image..."
	docker build -t remote-inventory-backend .

# Deploy to Cloud Run
deploy:
	@echo "Deploying to Cloud Run..."
	@read -p "Enter GCP Project ID: " project_id; \
	gcloud builds submit --tag gcr.io/$$project_id/remote-inventory-backend; \
	gcloud run deploy remote-inventory-backend \
		--image gcr.io/$$project_id/remote-inventory-backend \
		--platform managed \
		--region us-central1 \
		--allow-unauthenticated \
		--memory 2Gi \
		--cpu 2
