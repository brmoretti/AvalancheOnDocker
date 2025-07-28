#!/bin/bash

# Avalanche L1 Startup Script
set -e

echo "🏔️  Starting Avalanche L1 Setup..."

# Configuration variables (can be overridden via environment variables)
BLOCKCHAIN_NAME=${BLOCKCHAIN_NAME:-"myblockchain"}
CHAIN_ID=${CHAIN_ID:-"888"}
TOKEN_SYMBOL=${TOKEN_SYMBOL:-"TST"}
TOKEN_NAME=${TOKEN_NAME:-"TST Token"}

echo "📋 Configuration:"
echo "  - Blockchain Name: $BLOCKCHAIN_NAME"
echo "  - Chain ID: $CHAIN_ID"
echo "  - Token Symbol: $TOKEN_SYMBOL"
echo "  - Token Name: $TOKEN_NAME"

echo "🔧 Setting up Avalanche L1..."

# Check if blockchain already exists
if avalanche blockchain describe "$BLOCKCHAIN_NAME" >/dev/null 2>&1; then
    echo "✅ Blockchain configuration '$BLOCKCHAIN_NAME' already exists"
else
    echo "🔨 Creating blockchain configuration '$BLOCKCHAIN_NAME'..."

    # Create blockchain with non-interactive flags (no ICM to avoid prompts)
    avalanche blockchain create "$BLOCKCHAIN_NAME" \
        --evm \
        --evm-chain-id "$CHAIN_ID" \
        --evm-token "$TOKEN_SYMBOL" \
        --test-defaults \
        --proof-of-authority \
        --force

    if [ $? -eq 0 ]; then
        echo "✅ Blockchain configuration created successfully"
    else
        echo "❌ Failed to create blockchain configuration"
        exit 1
    fi
fi

echo "🚀 Deploying Avalanche L1 to local network..."

# Deploy the blockchain with ewoq key (non-interactive for local deployment)
avalanche blockchain deploy "$BLOCKCHAIN_NAME" --local --ewoq

deploy_result=$?

if [ $deploy_result -eq 0 ]; then
    echo "✅ Deployment completed successfully"
else
    echo "❌ Deployment failed with exit code $deploy_result"
    # Try starting the network manually
    echo "🔄 Attempting to start network..."
    avalanche network start || echo "⚠️ Failed to start network"
fi

echo "✅ Avalanche L1 deployment completed!"

# Get deployment information
echo "📊 Deployment Information:"
avalanche blockchain describe "$BLOCKCHAIN_NAME" || echo "⚠️ Could not retrieve blockchain info"

# Keep the container running and show logs
echo "🔍 Monitoring network... (Press Ctrl+C to stop)"
echo "📝 You can check logs in the background"

# Function to cleanup on exit
cleanup() {
    echo "🛑 Stopping Avalanche network..."
    avalanche network stop || true
    exit 0
}

# Set trap for cleanup
trap cleanup SIGTERM SIGINT

# Keep container running
while true; do
    sleep 30
    # Check if network is still healthy
    if ! avalanche network status >/dev/null 2>&1; then
        echo "❌ Network appears to be down. Attempting restart..."
        avalanche network start || echo "⚠️  Failed to restart network"
    fi
done
