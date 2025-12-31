module github.com/djgupt/remote-inventory

go 1.21

require (
	google.golang.org/grpc v1.60.1
	google.golang.org/protobuf v1.32.0
	github.com/google/uuid v1.5.0
	gocv.io/x/gocv v0.35.0
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.19.0
	google.golang.org/genproto/googleapis/api v0.0.0-20240116215550-a9fa1716bcac
)

require (
	github.com/golang/protobuf v1.5.3 // indirect
	golang.org/x/net v0.20.0 // indirect
	golang.org/x/sys v0.16.0 // indirect
	golang.org/x/text v0.14.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20240116215550-a9fa1716bcac // indirect
)

replace github.com/djgupt/remote-inventory/proto => ../proto
