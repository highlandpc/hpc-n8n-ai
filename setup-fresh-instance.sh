#!/bin/bash
# Fresh AWS t3.small Instance Setup & Deployment
# Run this script on your NEW AWS instance

set -e

echo "🚀 HPC n8n AI Stack - Fresh Instance Setup"
echo "=========================================="
echo ""

# Update system
echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
rm get-docker.sh

# Install Docker Compose (if not included)
echo "📦 Installing Docker Compose..."
sudo apt-get install -y docker-compose-plugin

# Install Git
echo "📦 Installing Git..."
sudo apt-get install -y git

# Clone repository
echo "📥 Cloning repository..."
cd ~
git clone https://github.com/highlandpc/hpc-n8n-ai.git
cd hpc-n8n-ai

# Setup environment
echo "⚙️  Setting up environment..."
cp .env.minimal .env

echo ""
echo "✅ Initial setup complete!"
echo ""
echo "⚠️  IMPORTANT: You need to log out and back in for Docker permissions to take effect"
echo ""
echo "After logging back in, run:"
echo "  cd ~/hpc-n8n-ai"
echo "  ./deploy-minimal.sh"
echo ""
echo "🔐 Configure your firewall to allow:"
echo "  - Port 22 (SSH)"
echo "  - Port 80 (HTTP)"
echo "  - Port 443 (HTTPS)"
echo ""
