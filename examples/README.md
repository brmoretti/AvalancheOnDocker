# Avalanche L1 Docker Examples

This directory contains example configurations and use cases for the Avalanche L1 Docker setup.

## 🎯 Examples

### 1. Custom Token Configuration

Create a custom L1 with your own token:

```bash
# Edit docker-compose.yml
environment:
  - BLOCKCHAIN_NAME=mytoken-chain
  - CHAIN_ID=1337
  - TOKEN_SYMBOL=MYT
  - TOKEN_NAME=My Token
```

### 2. Development Environment

Perfect for smart contract development:

```bash
# Start the L1
./start.sh

# Get connection details:
docker-compose exec avalanche-l1 ./scripts/network-status.sh

# Connect MetaMask with details from the output above:
# - RPC URL: http://localhost:<PORT>/ext/bc/<BLOCKCHAIN_ID>/rpc (dynamic port)
# - Chain ID: 888
# - Symbol: TST

# Import test account:
# Private Key: 56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027
```

### 3. Multi-L1 Setup

Run multiple L1s with different configurations:

```yaml
# docker-compose-multi.yml
version: '3.8'
services:
  l1-defi:
    build: .
    ports:
      - "9650-9658:9650-9658"  # Dynamic port range
      - "33325:33325"          # L1 RPC port
    environment:
      - BLOCKCHAIN_NAME=defi-chain
      - CHAIN_ID=1001
      - TOKEN_SYMBOL=DFI

  l1-gaming:
    build: .
    ports:
      - "9670-9678:9650-9658"  # Different port range
      - "33326:33325"          # Different L1 RPC port
    environment:
      - BLOCKCHAIN_NAME=gaming-chain
      - CHAIN_ID=1002
      - TOKEN_SYMBOL=GAME
```

### 4. Production-like Testing

Test production scenarios locally:

```bash
# Use custom chain ID (avoid conflicts)
export CHAIN_ID=31337
export TOKEN_SYMBOL=PROD
./start.sh

# Test with production-like tools
# - Deploy contracts with Hardhat/Foundry
# - Test cross-chain messaging
# - Simulate validator operations
```

## 🔗 Integration Examples

### Smart Contract Deployment

```javascript
// hardhat.config.js
// Get RPC URL from: docker-compose exec avalanche-l1 ./scripts/network-status.sh
module.exports = {
  networks: {
    avalanche_local: {
      url: "http://localhost:<PORT>/ext/bc/<BLOCKCHAIN_ID>/rpc", // Use dynamic values from network-status
      chainId: 888,
      accounts: ["0x56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027"]
    }
  }
};
```

### Web3 Integration

```javascript
// Get RPC URL from: docker-compose exec avalanche-l1 ./scripts/network-status.sh
// Connect to local L1
const web3 = new Web3('http://localhost:<PORT>/ext/bc/<BLOCKCHAIN_ID>/rpc');

// Use test account
const account = web3.eth.accounts.privateKeyToAccount(
  '0x56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027'
);
```

## 📚 Use Cases

1. **DeFi Protocol Development**: Test AMMs, lending protocols, yield farming
2. **NFT Marketplace**: Deploy and test NFT contracts
3. **Gaming Applications**: Fast, low-cost transactions for gaming
4. **Cross-chain Development**: Test ICM (Inter-Chain Messaging)
5. **Educational Purposes**: Learn blockchain development safely
