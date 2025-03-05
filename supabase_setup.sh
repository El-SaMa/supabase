#!/bin/bash

# Update and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget unzip nano ufw

# Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com | sudo bash
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone Supabase repository
echo "Cloning Supabase repository..."
git clone --depth 1 https://github.com/supabase/supabase
cd supabase/docker

# Copy environment file and prompt user to edit
echo "Copying environment file..."
cp .env.example .env

# Get current system username
CURRENT_USER=$(whoami)

echo "Please edit the .env file and configure POSTGRES_PASSWORD, JWT_SECRET, and API keys."
echo "Suggested PostgreSQL user: $CURRENT_USER (change if needed). Press any key to continue once done."
read -n 1 -s -r
nano .env

# Pull and start Supabase services
echo "Starting Supabase services..."
docker-compose pull
docker-compose up -d

# Get the machine's IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "Supabase setup complete!"
echo "Access Supabase Studio at: http://$IP_ADDRESS:8000"
echo "PostgreSQL access: psql -h localhost -U $CURRENT_USER -d postgres"
