# Multi-stage build for optimized production image

# Stage 1: Build Go binary
FROM golang:1.21-alpine AS builder

RUN apk add --no-cache git make protobuf-dev

WORKDIR /app

# Copy go mod files
COPY backend/go.mod backend/go.sum ./
RUN go mod download

# Copy source code
COPY backend/ ./
COPY proto/ ../proto/

# Build binary
RUN CGO_ENABLED=0 GOOS=linux go build -o /server ./server

# Stage 2: Runtime with OpenCV and dependencies
FROM alpine:latest

# Install OpenCV and runtime dependencies
RUN apk add --no-cache \
    opencv opencv-dev \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Download Haar Cascade for face detection
RUN wget -O /haarcascade_frontalface_default.xml \
    https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_default.xml

WORKDIR /root/

# Copy binary from builder
COPY --from=builder /server .

# Expose port
EXPOSE 8080

# Run server
CMD ["./server"]
