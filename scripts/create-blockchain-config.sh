#!/bin/bash

# Script to create blockchain configuration non-interactively
set -e

BLOCKCHAIN_NAME="$1"
CHAIN_ID="$2"
TOKEN_SYMBOL="$3"
TOKEN_NAME="$4"

if [ -z "$BLOCKCHAIN_NAME" ] || [ -z "$CHAIN_ID" ] || [ -z "$TOKEN_SYMBOL" ] || [ -z "$TOKEN_NAME" ]; then
    echo "Usage: $0 <blockchain_name> <chain_id> <token_symbol> <token_name>"
    exit 1
fi

echo "Creating blockchain configuration: $BLOCKCHAIN_NAME"

# Create a temporary expect script to handle the interactive prompts
cat > /tmp/create_blockchain.exp << EOF
#!/usr/bin/expect -f

set timeout 300
spawn avalanche blockchain create $BLOCKCHAIN_NAME

# Choose VM - Select Subnet-EVM
expect "Which Virtual Machine would you like to use?"
send "Subnet-EVM\r"

# Choose Validator Manager - Select Proof Of Authority
expect "Which validator management type would you like to use in your blockchain?"
send "Proof Of Authority\r"

# Choose address source - Select existing stored key
expect "Which address do you want to enable as controller of ValidatorManager contract?"
send "Get address from an existing stored key (created from avalanche key create or avalanche key import)\r"

# Select key - Use ewoq
expect "Which stored key should be used enable as controller of ValidatorManager contract?"
send "ewoq\r"

# Choose blockchain configuration - Select test environment defaults
expect "Do you want to use default values for the Blockchain configuration?"
send "I want to use defaults for a test environment\r"

# Enter Chain ID
expect "Chain ID:"
send "$CHAIN_ID\r"

# Enter Token Symbol
expect "Token Symbol:"
send "$TOKEN_SYMBOL\r"

expect eof
EOF

# Install expect if not available
if ! command -v expect &> /dev/null; then
    apt-get update && apt-get install -y expect
fi

# Make the expect script executable and run it
chmod +x /tmp/create_blockchain.exp
/tmp/create_blockchain.exp

# Clean up
rm -f /tmp/create_blockchain.exp

echo "✅ Blockchain configuration created successfully!"
