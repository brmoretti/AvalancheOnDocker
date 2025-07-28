# Use Ubuntu as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/bin:$PATH"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    bash \
    git \
    jq \
    expect \
    && rm -rf /var/lib/apt/lists/*

# Install Avalanche-CLI
RUN curl -sSfL https://raw.githubusercontent.com/ava-labs/avalanche-cli/main/scripts/install.sh | sh

# Add avalanche to PATH permanently
RUN echo 'export PATH=~/bin:$PATH' >> ~/.bashrc

# Create working directory
WORKDIR /app

# Copy scripts
COPY scripts/ ./scripts/
COPY configs/ ./configs/

# Make scripts executable
RUN chmod +x scripts/*.sh

# Expose the typical Avalanche node ports
# 9650 - Primary node API port
# 9651 - Staking port
# 60172 - L1 node port (this can vary)
EXPOSE 9650 9651 9652 9654 9656 9658 60172

# Default command
CMD ["./scripts/start-avalanche-l1.sh"]
