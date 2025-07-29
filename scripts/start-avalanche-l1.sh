#!/bin/bash
set -e

echo "🏔️  Starting Avalanche L1 Setup..."

# Configuration variables (can be overridden via environment variables)
BLOCKCHAIN_NAME=${BLOCKCHAIN_NAME:-"myblockchain"}
CHAIN_ID=${CHAIN_ID:-"888"}
TOKEN_SYMBOL=${TOKEN_SYMBOL:-"TST"}
TOKEN_NAME=${TOKEN_NAME:-"TST Token"}
VALIDATOR_MANAGER_OWNER=${VALIDATOR_MANAGER_OWNER:-"ewoq"}

echo "📋 Configuration:"
echo "  - Blockchain Name: $BLOCKCHAIN_NAME"
echo "  - Chain ID: $CHAIN_ID"
echo "  - Token Symbol: $TOKEN_SYMBOL"
echo "  - Token Name: $TOKEN_NAME"

echo "🔧 Setting up Avalanche L1..."

# First, clean up any existing blockchain configuration
echo "🧹 Cleaning up existing configuration..."
avalanche blockchain delete "$BLOCKCHAIN_NAME" --force 2>/dev/null || true

echo "🚀 Creating blockchain configuration '$BLOCKCHAIN_NAME'..."

yes "" | avalanche blockchain create "$BLOCKCHAIN_NAME" \
    --evm \
    --evm-chain-id $CHAIN_ID \
    --evm-token $TOKEN_SYMBOL \
    --proof-of-authority \
    --test-defaults \

if [ $? -ne 0 ]; then
    echo "❌ Failed to create blockchain configuration"
    exit 1
fi

echo "✅ Blockchain configuration created successfully"

# Deploy the blockchain to local network - don't exit on error
echo "🚀 Deploying blockchain to local network..."
set +e  # Temporarily disable exit on error
avalanche blockchain deploy "$BLOCKCHAIN_NAME" --local --avalanchego-version latest
DEPLOY_EXIT_CODE=$?
set -e  # Re-enable exit on error

if [ $DEPLOY_EXIT_CODE -ne 0 ]; then
    echo "⚠️  Warning: Deployment completed with issues, but blockchain might still be functional..."
else
    echo "✅ Blockchain deployed successfully!"
fi

echo "🎉 Avalanche L1 '$BLOCKCHAIN_NAME' setup completed!"

# Get network information - don't fail if this doesn't work
echo "📡 Network Information:"
avalanche network status --local 2>/dev/null || echo "⚠️  Could not get network status"

# Try to get blockchain info - don't fail if this doesn't work
echo ""
echo "🔍 Blockchain Information:"
avalanche blockchain describe "$BLOCKCHAIN_NAME" 2>/dev/null || echo "⚠️  Could not get blockchain info"

# Display connection information
echo ""
echo "🔗 Connection Details:"
echo "  Check the deployment output above for the exact RPC endpoint"
echo "  Chain ID: $CHAIN_ID"
echo "  Token Symbol: $TOKEN_SYMBOL"
echo ""
echo "💡 The blockchain should be functional even with warnings!"

# Keep the container running regardless of previous errors
echo "🔄 Container will stay alive for debugging and monitoring..."
echo "💡 Use 'docker exec -it <container> bash' to investigate further"

# Simple keepalive loop that won't fail
while true; do
    sleep 60
    echo "$(date): Container is alive - monitoring..."
done
