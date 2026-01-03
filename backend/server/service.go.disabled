package main

import (
	"context"
	"io"
	"log"
	"time"

	pb "github.com/djgupt/remote-inventory"
	"github.com/djgupt/remote-inventory/privacy"
	"github.com/djgupt/remote-inventory/session"
)

// Server implements the gRPC InventoryService
type Server struct {
	pb.UnimplementedInventoryServiceServer
	sessionMgr       *session.Manager
	privacyProcessor *privacy.Processor
}

// NewServer creates a new gRPC server
func NewServer() (*Server, error) {
	privacyProcessor, err := privacy.NewProcessor(privacy.DefaultConfig())
	if err != nil {
		return nil, err
	}

	return &Server{
		sessionMgr:       session.NewManager(),
		privacyProcessor: privacyProcessor,
	}, nil
}

// CreateSession creates a new session for a provider
func (s *Server) CreateSession(ctx context.Context, req *pb.CreateSessionRequest) (*pb.SessionResponse, error) {
	log.Printf("Creating session for provider: %s", req.ProviderName)
	return s.sessionMgr.CreateSession(ctx, req)
}

// JoinSession allows a consumer to join an existing session
func (s *Server) JoinSession(ctx context.Context, req *pb.JoinSessionRequest) (*pb.SessionResponse, error) {
	log.Printf("Consumer joining session: %s", req.SessionId)
	return s.sessionMgr.JoinSession(ctx, req)
}

// EndSession ends a session
func (s *Server) EndSession(ctx context.Context, req *pb.EndSessionRequest) (*pb.EndSessionResponse, error) {
	log.Printf("Ending session: %s", req.SessionId)

	// Validate token
	err := s.sessionMgr.ValidateToken(req.SessionId, req.Token, session.RoleProvider)
	if err != nil {
		// Try consumer token
		err = s.sessionMgr.ValidateToken(req.SessionId, req.Token, session.RoleConsumer)
		if err != nil {
			return &pb.EndSessionResponse{Success: false}, err
		}
	}

	err = s.sessionMgr.EndSession(req.SessionId)
	return &pb.EndSessionResponse{Success: err == nil}, err
}

// ProviderStream handles bidirectional streaming from provider
func (s *Server) ProviderStream(stream pb.InventoryService_ProviderStreamServer) error {
	var sess *session.Session
	var sessionID string

	// Goroutine to send commands to provider
	go func() {
		if sess == nil {
			return
		}

		for cmd := range sess.ProviderCommands {
			if err := stream.Send(cmd); err != nil {
				log.Printf("Error sending command to provider: %v", err)
				return
			}
		}
	}()

	// Receive video frames and sensor data from provider
	for {
		msg, err := stream.Recv()
		if err == io.EOF {
			log.Printf("Provider stream ended: %s", sessionID)
			return nil
		}
		if err != nil {
			log.Printf("Error receiving from provider: %v", err)
			return err
		}

		// First message should establish session
		if sess == nil {
			sessionID = msg.SessionId
			if err := s.sessionMgr.ValidateToken(msg.SessionId, msg.Token, session.RoleProvider); err != nil {
				log.Printf("Invalid provider token: %v", err)
				return err
			}

			sess, err = s.sessionMgr.GetSession(msg.SessionId)
			if err != nil {
				return err
			}

			log.Printf("Provider stream established for session: %s", sessionID)
		}

		// Update heartbeat
		s.sessionMgr.UpdateHeartbeat(msg.SessionId)

		// Handle different message types
		switch payload := msg.Payload.(type) {
		case *pb.ProviderMessage_VideoFrame:
			// Process frame through privacy layer
			go s.processAndSendFrame(sess, payload.VideoFrame)

		case *pb.ProviderMessage_SensorData:
			// Store sensor data for laser guidance (TODO: implement)
			log.Printf("Received sensor data from provider")

		case *pb.ProviderMessage_Status:
			log.Printf("Provider status update: camera=%v, battery=%d%%",
				payload.Status.CameraActive, payload.Status.BatteryLevel)
		}
	}
}

// ConsumerStream handles bidirectional streaming from consumer
func (s *Server) ConsumerStream(stream pb.InventoryService_ConsumerStreamServer) error {
	var sess *session.Session
	var sessionID string

	// Goroutine to send blurred frames to consumer
	go func() {
		if sess == nil {
			return
		}

		for frame := range sess.ConsumerFrames {
			if err := stream.Send(frame); err != nil {
				log.Printf("Error sending frame to consumer: %v", err)
				return
			}
		}
	}()

	// Receive commands from consumer
	for {
		cmd, err := stream.Recv()
		if err == io.EOF {
			log.Printf("Consumer stream ended: %s", sessionID)
			return nil
		}
		if err != nil {
			log.Printf("Error receiving from consumer: %v", err)
			return err
		}

		// First message should establish session
		if sess == nil {
			sessionID = cmd.SessionId
			if err := s.sessionMgr.ValidateToken(cmd.SessionId, cmd.Token, session.RoleConsumer); err != nil {
				log.Printf("Invalid consumer token: %v", err)
				return err
			}

			sess, err = s.sessionMgr.GetSession(cmd.SessionId)
			if err != nil {
				return err
			}

			log.Printf("Consumer stream established for session: %s", sessionID)
		}

		// Update heartbeat
		s.sessionMgr.UpdateHeartbeat(cmd.SessionId)

		// Route command to provider
		providerCmd := s.convertToProviderCommand(cmd)
		if providerCmd != nil {
			if err := sess.SendCommand(providerCmd); err != nil {
				log.Printf("Error sending command to provider: %v", err)
			}
		}
	}
}

// Heartbeat keeps sessions alive
func (s *Server) Heartbeat(ctx context.Context, req *pb.HeartbeatRequest) (*pb.HeartbeatResponse, error) {
	sess, err := s.sessionMgr.GetSession(req.SessionId)
	if err != nil {
		return &pb.HeartbeatResponse{Active: false}, err
	}

	s.sessionMgr.UpdateHeartbeat(req.SessionId)

	duration := time.Since(sess.CreatedAt).Milliseconds()

	return &pb.HeartbeatResponse{
		Active:            true,
		SessionDurationMs: duration,
	}, nil
}

// processAndSendFrame processes a frame through privacy layer and sends to consumer
func (s *Server) processAndSendFrame(sess *session.Session, frame *pb.VideoFrame) {
	startTime := time.Now()

	// Apply privacy processing
	blurredData, fullBlur, err := s.privacyProcessor.ProcessFrame(frame.FrameData)
	if err != nil {
		log.Printf("Error processing frame: %v", err)
		// Send filler frame or previous frame
		return
	}

	processingTime := time.Since(startTime).Milliseconds()
	log.Printf("Frame processed in %dms (full blur: %v)", processingTime, fullBlur)

	// Create new frame with blurred data
	blurredFrame := &pb.VideoFrame{
		FrameData:   blurredData,
		TimestampMs: frame.TimestampMs,
		Width:       frame.Width,
		Height:      frame.Height,
		IsBlurred:   true,
	}

	// Send to consumer
	sess.SendFrame(blurredFrame)
}

// convertToProviderCommand converts consumer command to provider command
func (s *Server) convertToProviderCommand(cmd *pb.ConsumerCommand) *pb.ProviderCommand {
	switch c := cmd.Command.(type) {
	case *pb.ConsumerCommand_Navigation:
		return &pb.ProviderCommand{
			Command: &pb.ProviderCommand_Navigation{Navigation: c.Navigation},
		}
	case *pb.ConsumerCommand_Laser:
		return &pb.ProviderCommand{
			Command: &pb.ProviderCommand_Laser{Laser: c.Laser},
		}
	case *pb.ConsumerCommand_Stop:
		return &pb.ProviderCommand{
			Command: &pb.ProviderCommand_Stop{Stop: c.Stop},
		}
	case *pb.ConsumerCommand_Zoom:
		return &pb.ProviderCommand{
			Command: &pb.ProviderCommand_Zoom{Zoom: c.Zoom},
		}
	case *pb.ConsumerCommand_Voice:
		// Parse voice command and convert to navigation
		log.Printf("Voice command: %s", c.Voice.TranscribedText)
		return s.parseVoiceCommand(c.Voice.TranscribedText)
	case *pb.ConsumerCommand_Text:
		// Parse text command and convert to navigation
		log.Printf("Text command: %s", c.Text.Text)
		return s.parseTextCommand(c.Text.Text)
	}
	return nil
}

// parseVoiceCommand parses voice commands into navigation commands
func (s *Server) parseVoiceCommand(text string) *pb.ProviderCommand {
	// Simple keyword-based parsing
	// TODO: Use NLP for better parsing

	var dir pb.NavigationCommand_Direction

	switch {
	case contains(text, "left"):
		dir = pb.NavigationCommand_LEFT
	case contains(text, "right"):
		dir = pb.NavigationCommand_RIGHT
	case contains(text, "up"):
		dir = pb.NavigationCommand_UP
	case contains(text, "down"):
		dir = pb.NavigationCommand_DOWN
	case contains(text, "forward"), contains(text, "ahead"):
		dir = pb.NavigationCommand_FORWARD
	case contains(text, "back"), contains(text, "backward"):
		dir = pb.NavigationCommand_BACKWARD
	default:
		return nil
	}

	return &pb.ProviderCommand{
		Command: &pb.ProviderCommand_Navigation{
			Navigation: &pb.NavigationCommand{
				Direction: dir,
				Intensity: 0.5,
			},
		},
	}
}

// parseTextCommand parses text commands
func (s *Server) parseTextCommand(text string) *pb.ProviderCommand {
	return s.parseVoiceCommand(text)
}

func contains(s, substr string) bool {
	return len(s) >= len(substr) && s[:len(substr)] == substr
}

// Close releases server resources
func (s *Server) Close() {
	s.privacyProcessor.Close()
}
