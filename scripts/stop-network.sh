#!/bin/bash

# Script to stop the Avalanche L1 network gracefully
set -e

echo "🛑 Stopping Avalanche L1 Network..."

# Stop the network
if avalanche network stop; then
    echo "✅ Network stopped successfully"
    echo "💾 Network state has been preserved"
    echo "🔄 Use 'avalanche network start' to resume"
else
    echo "❌ Failed to stop network or network was not running"
fi

echo ""
echo "🔧 Other cleanup options:"
echo "  - To completely clean network state: avalanche network clean"
echo "  - To restart fresh: avalanche network clean && ./scripts/start-avalanche-l1.sh"
