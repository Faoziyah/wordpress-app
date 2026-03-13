#!/bin/bash

# Update system packages
echo "Updating system..."
sudo apt update -y
sudo apt upgrade -y

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
    echo "Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
else
    echo "Docker already installed"
fi

# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null
then
    echo "Installing Docker Compose..."
    sudo apt install -y docker-compose
else
    echo "Docker Compose already installed"
fi

# Install AWS CLI if not installed
if ! command -v aws &> /dev/null
then
    echo "Installing AWS CLI..."
    sudo apt install -y awscli
else
    echo "AWS CLI already installed"
fi

# Create directory for MySQL data
echo "Creating MySQL data directory..."
sudo mkdir -p /mnt/mysql-data

# Check if EBS volume already mounted
if ! mount | grep "/mnt/mysql-data" > /dev/null
then
    echo "Mounting EBS volume..."
    sudo mount /dev/xvdf /mnt/mysql-data
else
    echo "Volume already mounted"
fi

# Set permissions so Docker can write
sudo chown -R ubuntu:ubuntu /mnt/mysql-data

echo "Provisioning completed!"i
