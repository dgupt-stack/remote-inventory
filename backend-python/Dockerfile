FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY server.py .
COPY inventory_service_pb2.py .
COPY inventory_service_pb2_grpc.py .

# Cloud Run uses PORT environment variable
ENV PORT=8080
EXPOSE 8080

# Run the server
CMD ["python3", "server.py"]
