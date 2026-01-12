package main

import (
	"context"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	pb "github.com/djgupt/remote-inventory"
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
	inventoryServer := NewInventoryServer()

	pb.RegisterInventoryServiceServer(grpcServer, inventoryServer)

	// Enable reflection for debugging
	reflection.Register(grpcServer)

	// Start gRPC-Gateway for REST API
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	grpcAddr := "localhost:" + grpcPort
	httpAddr := ":" + httpPort

	go func() {
		log.Printf("HTTP/REST gateway starting on port %s", httpPort)
		if err := StartGateway(ctx, grpcAddr, httpAddr); err != nil {
			log.Printf("Gateway error: %v", err)
		}
	}()

	// Handle graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-sigChan
		log.Println("Shutting down gracefully...")
		cancel()
		grpcServer.GracefulStop()
		os.Exit(0)
	}()

	log.Printf("gRPC server listening on port %s", grpcPort)
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
