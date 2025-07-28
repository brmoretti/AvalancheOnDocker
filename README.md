# Avalanche L1 on Docker

This project provides a Docker setup to easily launch an Avalanche L1 (Layer 1) blockchain on a local network using the Avalanche CLI.

## ⚡ Quick Setup (TL;DR)

```bash
git clone <repository-url>
cd AvalancheOnDocker
./start.sh
# Wait 2-3 minutes for deployment
docker-compose exec avalanche-l1 ./scripts/network-status.sh
```

**RPC Endpoint**: Check the output above for the connection URL
**Test Account**: `0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC` (Private Key: `56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027`)

## 🏔️ Features

- **One-command setup**: Launch a complete Avalanche L1 with Docker
- **Fully automated deployment**: No manual intervention required
- **Pre-configured environment**: Uses Subnet-EVM with Proof of Authority consensus
- **Test environment ready**: Includes pre-funded test accounts
- **Dynamic port allocation**: Automatically assigns available ports
- **Persistent data**: Blockchain state persists between container restarts
- **ICM enabled**: Inter-Chain Messaging pre-deployed for cross-chain functionality

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB of available RAM
- Available ports: 9650, 9651, 9652, 9654, 9656, 9658, 33325 (L1 RPC port may vary)

### Launch the Avalanche L1

1. **Clone and start:**
   ```bash
   git clone <repository-url>
   cd AvalancheOnDocker
   ./start.sh
   # OR use docker-compose directly:
   # docker-compose up -d
   ```

2. **Monitor the deployment:**
   ```bash
   docker-compose logs -f avalanche-l1
   ```

3. **Check network status:**
   ```bash
   docker-compose exec avalanche-l1 ./scripts/network-status.sh
   ```

## ⚡ What Happens During Deployment

The automated deployment process includes:

1. **🔧 Environment Setup**: Installing Avalanche CLI and dependencies
2. **🏗️ Blockchain Creation**: Creating a Subnet-EVM blockchain configuration
3. **🚀 Network Bootstrap**: Starting a 3-node local Avalanche network
4. **⛓️ L1 Conversion**: Converting the subnet to a sovereign L1
5. **🔗 Contract Deployment**: Setting up Proof of Authority validator management
6. **🌐 ICM Setup**: Deploying Inter-Chain Messaging contracts
7. **✅ Ready**: Network is ready for connections and transactions

**Total deployment time**: ~2-3 minutes

## 🔧 Configuration

### Environment Variables

You can customize the L1 configuration by modifying the `docker-compose.yml` file:

```yaml
environment:
  - BLOCKCHAIN_NAME=myblockchain    # Name of your L1
  - CHAIN_ID=888                    # EVM Chain ID
  - TOKEN_SYMBOL=TST                # Native token symbol
  - TOKEN_NAME=TST Token            # Native token name
```

### Custom Configuration

Create a custom environment file:

```bash
cp configs/default.env configs/custom.env
# Edit configs/custom.env with your values
```

## 🌐 Connecting to Your L1

Once deployed, you can connect to your Avalanche L1 using:

### RPC Endpoint
The RPC endpoint will be displayed in the deployment logs. It follows this format:
```
http://localhost:<PORT>/ext/bc/<BLOCKCHAIN_ID>/rpc
```

**Example from a successful deployment:**
```
http://localhost:33325/ext/bc/c6mfoe9a8wkAzrvu2CrS8mnCpasSzoWnK1FDRofyj2XzZPEHj/rpc
```

> **Note**: The port number (e.g., 33325) is dynamically assigned and may vary between deployments.

### Test Account (⚠️ Development Only)
- **Address**: `0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC`
- **Private Key**: `56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027`
- **Balance**: 1,000,000 tokens

**⚠️ WARNING**: This is a well-known test key. Never use it in production!

### Wallet Configuration

Add to MetaMask/Core:
- **Network Name**: myblockchain (or your custom name)
- **RPC URL**: Use the URL from the deployment logs (format: `http://localhost:<PORT>/ext/bc/<BLOCKCHAIN_ID>/rpc`)
- **Chain ID**: 888 (or your custom chain ID)
- **Currency Symbol**: TST (or your custom symbol)

> **💡 Tip**: Run `docker-compose exec avalanche-l1 ./scripts/network-status.sh` to get the exact RPC URL for your deployment.

## 📋 Management Commands

### Get Connection Details
```bash
docker-compose exec avalanche-l1 ./scripts/network-status.sh
```

### Check Status
```bash
docker-compose exec avalanche-l1 ./scripts/network-status.sh
```

### Stop Network (Preserve State)
```bash
docker-compose exec avalanche-l1 ./scripts/stop-network.sh
```

### Restart Network
```bash
docker-compose restart avalanche-l1
```

### Clean Restart (Delete All Data)
```bash
docker-compose down -v
docker-compose up -d
```

### View Logs
```bash
docker-compose logs -f avalanche-l1
```

## 🏗️ Architecture

The Docker setup includes:

1. **Avalanche CLI**: Latest version installed automatically
2. **Three-node network**:
   - 2 primary validators (P-Chain and C-Chain)
   - 1 L1 validator for your custom blockchain
3. **Subnet-EVM**: Ethereum Virtual Machine compatibility
4. **Proof of Authority**: Simplified consensus for development
5. **ICM (Inter-Chain Messaging)**: Pre-deployed for cross-chain functionality

## 📁 Directory Structure

```
AvalancheOnDocker/
├── Dockerfile                 # Main container definition
├── docker-compose.yml        # Container orchestration
├── start.sh                  # Quick start script
├── scripts/
│   ├── start-avalanche-l1.sh # Main startup script
│   ├── create-blockchain-config.sh # Blockchain configuration
│   ├── network-status.sh     # Status checking script
│   └── stop-network.sh       # Graceful shutdown script
├── configs/
│   └── default.env           # Default configuration
├── examples/
│   └── README.md             # Usage examples
└── README.md                 # This file
```

## 🔍 Troubleshooting

### Container Won't Start
- Check if required ports are available
- Ensure Docker has enough memory allocated (4GB+)
- Check logs: `docker-compose logs avalanche-l1`

### Network Not Responding
- Wait 2-3 minutes for full initialization (L1 conversion takes time)
- Check status: `docker-compose exec avalanche-l1 ./scripts/network-status.sh`
- Restart if needed: `docker-compose restart avalanche-l1`
- Monitor deployment: `docker-compose logs -f avalanche-l1`

### Port Conflicts
- Modify port mappings in `docker-compose.yml`
- Ensure no other Avalanche nodes are running

### Reset Everything
```bash
docker-compose down -v
docker system prune -f
docker-compose up -d
```

## 📚 Next Steps

1. **Deploy Smart Contracts**: Use Remix, Hardhat, or Foundry
2. **Custom Precompiles**: Add custom functionality to your L1
3. **Cross-chain Messaging**: Utilize the pre-deployed ICM
4. **Production Deployment**: Move to Fuji Testnet or Mainnet

## 🔗 Useful Links

- [Avalanche Documentation](https://docs.avax.network/)
- [Avalanche CLI](https://github.com/ava-labs/avalanche-cli)
- [Subnet-EVM](https://github.com/ava-labs/subnet-evm)
- [Core Wallet](https://core.app/)

## ⚠️ Security Notice

This setup is intended for **development and testing only**. The included test keys and configuration should never be used in production environments. Always use proper key management and security practices for production deployments.

## 📄 License

This project is provided as-is for educational and development purposes.
