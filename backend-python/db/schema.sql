-- Remote Inventory - Cloud Spanner Schema
-- User and device management with WebRTC session support

-- ============================================================
-- USERS TABLE
-- ============================================================
CREATE TABLE users (
  user_id STRING(36) NOT NULL,
  email STRING(255),
  display_name STRING(100) NOT NULL,
  created_at TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
  last_login TIMESTAMP,
) PRIMARY KEY (user_id);

-- ============================================================
-- DEVICES TABLE
-- Maps physical devices to users
-- ============================================================
CREATE TABLE devices (
  device_id STRING(36) NOT NULL,
  user_id STRING(36) NOT NULL,
  device_name STRING(100) NOT NULL,
  device_type STRING(20) NOT NULL,  -- "PROVIDER" or "CONSUMER"
  platform STRING(20),               -- "ANDROID" or "IOS"
  last_seen TIMESTAMP,
  created_at TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
  
  FOREIGN KEY (user_id) REFERENCES users (user_id)
) PRIMARY KEY (device_id);

-- ============================================================
-- SESSIONS TABLE
-- Active provider sessions
-- ============================================================
CREATE TABLE sessions (
  session_id STRING(36) NOT NULL,
  device_id STRING(36) NOT NULL,
  provider_name STRING(100),
  location STRING(255),
  status STRING(20) NOT NULL DEFAULT 'ONLINE',  -- "ONLINE", "OFFLINE", "BUSY"
  accepting_connections BOOL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
  ended_at TIMESTAMP,
  
  FOREIGN KEY (device_id) REFERENCES devices (device_id)
) PRIMARY KEY (session_id);

-- ============================================================
-- WEBRTC_SIGNALS TABLE
-- Temporary storage for WebRTC signaling (SDP/ICE exchange)
-- ============================================================
CREATE TABLE webrtc_signals (
  signal_id STRING(36) NOT NULL,
  session_id STRING(36) NOT NULL,
  from_device STRING(36) NOT NULL,
  to_device STRING(36) NOT NULL,
  signal_type STRING(20) NOT NULL,   -- "OFFER", "ANSWER", "ICE"
  payload JSON NOT NULL,              -- SDP or ICE candidate data
  created_at TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
  consumed BOOL DEFAULT FALSE,
  
  FOREIGN KEY (session_id) REFERENCES sessions (session_id)
) PRIMARY KEY (signal_id);

-- ============================================================
-- INDEXES
-- ============================================================

-- Index to find devices by user
CREATE INDEX idx_devices_user ON devices (user_id);

-- Index to find active sessions
CREATE INDEX idx_sessions_status ON sessions (status, created_at DESC);

-- Index to find pending signals for a device
CREATE INDEX idx_signals_unconsumed ON webrtc_signals (to_device, consumed, created_at);
