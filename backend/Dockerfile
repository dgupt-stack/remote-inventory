# Multi-stage build for optimized production image

# Stage 1: Build Go binary
FROM golang:1.21-alpine AS builder

RUN apk add --no-cache git make

WORKDIR /app

# Copy all source files
COPY backend/ ./backend/
COPY proto/ ./proto/

# Build from backend directory
WORKDIR /app/backend
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o /server ./server

# Stage 2: Minimal runtime
FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /root/

# Copy binary from builder
COPY --from=builder /server .

# Expose port
EXPOSE 8080

# Run server
CMD ["./server"]
