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
	"github.com/djgupt/remote-inventory/backend/server"
)

func main() {
	// Get port from environment or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	
	// Create listener
	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}
	
	// Create gRPC server
	grpcServer := grpc.NewServer(
		grpc.MaxRecvMsgSize(10*1024*1024), // 10MB for video frames
		grpc.MaxSendMsgSize(10*1024*1024),
	)
	
	// Create and register inventory service
	inventoryServer, err := server.NewServer()
	if err != nil {
		log.Fatalf("Failed to create server: %v", err)
	}
	
	pb.RegisterInventoryServiceServer(grpcServer, inventoryServer)
	
	// Enable reflection for debugging
	reflection.Register(grpcServer)
	
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
		os.Exit(0)
	}()
	
	log.Printf("Server listening on port %s", port)
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
