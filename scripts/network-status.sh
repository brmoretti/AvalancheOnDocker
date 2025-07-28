#!/bin/bash

# Script to get network status and connection details
set -e

BLOCKCHAIN_NAME=${BLOCKCHAIN_NAME:-"myblockchain"}

echo "🔍 Avalanche L1 Network Status"
echo "================================"

# Check network status
echo "📊 Network Status:"
avalanche network status || echo "❌ Network not running"

echo ""
echo "📋 Blockchain Details:"
avalanche blockchain describe "$BLOCKCHAIN_NAME" || echo "❌ Blockchain not found"

echo ""
echo "🌐 Connection Information:"
echo "================================"

# Extract connection details
if avalanche blockchain describe "$BLOCKCHAIN_NAME" >/dev/null 2>&1; then
    echo "✅ Blockchain '$BLOCKCHAIN_NAME' is available"

    # Get RPC endpoint information
    echo ""
    echo "🔗 RPC Endpoints:"
    echo "Use these endpoints to connect your wallet or dApp:"

    # Note: The exact port and endpoint will be shown in the deployment output
    echo "  - Check the deployment output above for the exact RPC endpoint"
    echo "  - Typically: http://127.0.0.1:60172/ext/bc/<BLOCKCHAIN_ID>/rpc"
    echo ""
    echo "💰 Test Account Details:"
    echo "  - Address: 0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC"
    echo "  - Private Key: 56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027"
    echo "  - ⚠️  WARNING: This is a well-known test key. Never use in production!"
    echo ""
    echo "🔧 Management Commands:"
    echo "  - Stop network: avalanche network stop"
    echo "  - Start network: avalanche network start"
    echo "  - Clean network: avalanche network clean"
else
    echo "❌ Blockchain '$BLOCKCHAIN_NAME' not found"
    echo "Run the deployment script first: ./scripts/start-avalanche-l1.sh"
fi
