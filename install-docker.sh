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

    if command_exists apt-get; then
    sudo apt-get install uidmap dbus-user-session -y
    fi
    
    # Download and execute rootless Docker installation script
    curl -fsSL https://get.docker.com/rootless -o get-docker.sh
    bash get-docker.sh

    ## add post-installation Environment variables
    printf "\nPATH=/home/$USER/bin:\$PATH" >> ~/.bashrc
    printf "\nDOCKER_HOST=unix:///run/user/$(id -u $USER)/docker.sock" >> ~/.bashrc 
    printf "\nexport PATH" >> ~/.bashrc
    printf "\nexport DOCKER_HOST" >> ~/.bashrc
    source ~/.bashrc
    
    # Verify installation
    docker --version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Docker installation completed successfully"
    else
        echo "Error: Docker installation failed"
        exit 1
    fi
fi