package privacy

// Processor handles privacy operations (stub for deployment)
type Processor struct{}

// Config for privacy processor (stub)
type Config struct{}

// NewProcessor creates a new privacy processor (stub)
func NewProcessor(config Config) (*Processor, error) {
	return &Processor{}, nil
}

// ProcessFrame processes a video frame (stub - returns frame unchanged)
func (p *Processor) ProcessFrame(frameData []byte) ([]byte, bool, error) {
	// For now, just pass through without blurring
	// TODO: Re-enable OpenCV privacy layer after CGO deployment is configured
	return frameData, false, nil
}

// Close cleans up resources (stub)
func (p *Processor) Close() error {
	return nil
}

// DefaultConfig returns default configuration (stub)
func DefaultConfig() Config {
	return Config{}
}
