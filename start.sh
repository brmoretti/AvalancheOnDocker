#!/bin/bash

# Build and run the Avalanche L1 Docker container
set -e

echo "🏔️  Avalanche L1 Docker Setup"
echo "============================="

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
    echo "❌ Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

echo "✅ Docker is running"

# Build and start the containers
echo "🔨 Building Avalanche L1 Docker image..."
docker-compose build

echo "🚀 Starting Avalanche L1 container..."
docker-compose up -d

echo "⏳ Waiting for container to start..."
sleep 5

# Show status
echo "📊 Container status:"
docker-compose ps

echo ""
echo "✅ Avalanche L1 setup complete!"
echo ""
echo "🔧 Useful commands:"
echo "  - View logs:        docker-compose logs -f avalanche-l1"
echo "  - Check status:     docker-compose exec avalanche-l1 ./scripts/network-status.sh"
echo "  - Stop network:     docker-compose exec avalanche-l1 ./scripts/stop-network.sh"
echo "  - Restart:          docker-compose restart avalanche-l1"
echo "  - Clean shutdown:   docker-compose down"
echo "  - Full reset:       docker-compose down -v"
echo ""
echo "🌐 The L1 will be available on:"
echo "  - Primary nodes:    http://localhost:9650, http://localhost:9652"
echo "  - L1 RPC endpoint:  http://localhost:60172/ext/bc/<BLOCKCHAIN_ID>/rpc"
echo ""
echo "⏳ Please wait 2-3 minutes for full network initialization..."
