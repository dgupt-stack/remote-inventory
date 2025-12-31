package main

import (
	"context"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	pb "github.com/djgupt/remote-inventory/proto"
	"github.com/envoyproxy/go-control-plane/pkg/server/v3"
)

func main() {
	// Get ports from environment or use defaults
	grpcPort := os.Getenv("GRPC_PORT")
	if grpcPort == "" {
		grpcPort = "8080"
	}

	httpPort := os.Getenv("HTTP_PORT")
	if httpPort == "" {
		httpPort = "8081"
	}

	// Create listener for gRPC
	lis, err := net.Listen("tcp", ":"+grpcPort)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	// Create gRPC server
	grpcServer := grpc.NewServer(
		grpc.MaxRecvMsgSize(10*1024*1024), // 10MB for video frames
		grpc.MaxSendMsgSize(10*1024*1024),
	)

	// Create and register inventory service
	inventoryServer, err := NewServer()
	if err != nil {
		log.Fatalf("Failed to create server: %v", err)
	}

	pb.RegisterInventoryServiceServer(grpcServer, inventoryServer)

	// Enable reflection for debugging
	reflection.Register(grpcServer)

	// Start gRPC-Gateway in a separate goroutine
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	go func() {
		log.Printf("Starting gRPC-Gateway on port %s", httpPort)
		if err := StartGateway(ctx, "localhost:"+grpcPort, ":"+httpPort); err != nil {
			log.Fatalf("Failed to start gateway: %v", err)
		}
	}()

	// Start cleanup goroutine for stale sessions
	go cleanupWorker(inventoryServer)

	// Handle graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-sigChan
		log.Println("Shutting down gracefully...")
		inventoryServer.Close()
		grpcServer.GracefulStop()
		cancel()
		os.Exit(0)
	}()

	log.Printf("gRPC server listening on port %s", grpcPort)
	log.Printf("HTTP/REST gateway listening on port %s", httpPort)
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}

// cleanupWorker periodically cleans up stale sessions
func cleanupWorker(srv *server.Server) {
	ticker := time.NewTicker(1 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		log.Println("Running session cleanup...")
		// Access session manager through server (we'll need to expose it)
		// For now, this is a placeholder
	}
}
