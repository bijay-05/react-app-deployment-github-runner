#!/bin/bash
command_exists() {
    command -v "$@" > /dev/null 2>&1
}

# Check if Docker is already installed

if command_exists docker; then
    echo "Docker is already installed. Skipping installation...."
    echo "======Skipping Installation======"
    exit 0
else
    echo "Installing Docker..."
    
    # Download and execute rootless Docker installation script
    curl -fsSL https://get.docker.com/rootless -o get-docker.sh
    bash get-docker.sh
    
    # Verify installation
    docker --version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Docker installation completed successfully"
    else
        echo "Error: Docker installation failed"
        exit 1
    fi
fi