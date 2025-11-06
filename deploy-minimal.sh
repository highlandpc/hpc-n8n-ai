#!/bin/bash
# Minimal deployment script for AWS t3.small
# Deploys: n8n + Flowise + Caddy only

set -e

echo "🚀 HPC n8n AI Stack - Minimal Deployment"
echo "========================================"
echo ""
echo "Services: n8n + Flowise + Caddy"
echo "Expected memory usage: ~600MB"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "Please create .env file with required variables"
    exit 1
fi

# Stop and remove any existing containers
echo "🧹 Cleaning up existing containers..."
docker compose -p hpc-n8n-ai -f docker-compose.minimal.yml down 2>/dev/null || true

# Clean up unused resources
echo "🧹 Cleaning up Docker resources..."
docker system prune -f

# Pull latest images
echo "📥 Pulling latest Docker images..."
docker compose -f docker-compose.minimal.yml pull

# Start services
echo "🚀 Starting services..."
docker compose -p hpc-n8n-ai -f docker-compose.minimal.yml up -d

# Wait for services to be healthy
echo ""
echo "⏳ Waiting for services to start..."
echo ""

# Function to check service health
check_service() {
    local service=$1
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker ps | grep -q "$service.*healthy\|$service.*Up"; then
            echo "✅ $service is ready"
            return 0
        fi
        echo "   Attempt $attempt/$max_attempts: Waiting for $service..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "⚠️  $service health check timeout (may still be starting)"
    return 1
}

# Check each service
check_service "n8n"
check_service "flowise"
check_service "caddy"

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Service URLs:"
echo "   n8n:     https://${N8N_HOSTNAME:-localhost}"
echo "   Flowise: https://${FLOWISE_HOSTNAME:-localhost}"
echo ""
echo "🔍 Check status:"
echo "   docker ps"
echo "   docker stats --no-stream"
echo ""
echo "📋 View logs:"
echo "   docker logs n8n"
echo "   docker logs flowise"
echo "   docker logs caddy"
echo ""
