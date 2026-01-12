package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// GeocodingService handles reverse geocoding (GPS -> Address)
type GeocodingService struct {
	client *http.Client
	cache  map[string]string // lat,lng -> address cache
}

// GeocodingResult from OpenStreetMap Nominatim
type GeocodingResult struct {
	Address struct {
		City    string `json:"city"`
		Town    string `json:"town"`
		Village string `json:"village"`
		State   string `json:"state"`
		Country string `json:"country"`
	} `json:"address"`
}

// NewGeocodingService creates a new geocoding service
func NewGeocodingService() *GeocodingService {
	return &GeocodingService{
		client: &http.Client{Timeout: 5 * time.Second},
		cache:  make(map[string]string),
	}
}

// ReverseGeocode converts GPS coordinates to a human-readable address
// Uses OpenStreetMap Nominatim API (free, no API key required)
func (g *GeocodingService) ReverseGeocode(ctx context.Context, lat, lng float64) (string, error) {
	// Check cache first
	cacheKey := fmt.Sprintf("%.4f,%.4f", lat, lng)
	if address, ok := g.cache[cacheKey]; ok {
		return address, nil
	}

	// Call Nominatim API
	url := fmt.Sprintf("https://nominatim.openstreetmap.org/reverse?format=json&lat=%.6f&lon=%.6f&zoom=10", lat, lng)

	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return "", fmt.Errorf("failed to create request: %w", err)
	}

	// Nominatim requires a User-Agent
	req.Header.Set("User-Agent", "JARVIS-Remote-Inventory/1.0")

	resp, err := g.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("geocoding request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("geocoding returned status %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read response: %w", err)
	}

	var result GeocodingResult
	if err := json.Unmarshal(body, &result); err != nil {
		return "", fmt.Errorf("failed to parse geocoding response: %w", err)
	}

	// Format address (City, State or Town, State)
	var address string
	location := result.Address.City
	if location == "" {
		location = result.Address.Town
	}
	if location == "" {
		location = result.Address.Village
	}

	if location != "" && result.Address.State != "" {
		address = fmt.Sprintf("%s, %s", location, result.Address.State)
	} else if result.Address.State != "" {
		address = result.Address.State
	} else {
		address = result.Address.Country
	}

	// Cache the result
	g.cache[cacheKey] = address

	return address, nil
}
