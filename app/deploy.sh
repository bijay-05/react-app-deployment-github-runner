#!/bin/bash

# Set default values
DEPLOY_BACKEND=0
DEPLOY_FRONTEND=0
BACKEND_TAG="latest"  # Default backend image tag
FRONTEND_TAG="latest" # Default frontend image tag
IMAGE_REPOSITORY="bijaydockerhub/react-express-app"

# Load tags from tags.conf if it exists
if [ -f tags.conf ]; then
    source tags.conf
    # If the tags are empty in the conf file, fall back to default
    BACKEND_TAG=${BACKEND_TAG:-latest}
    FRONTEND_TAG=${FRONTEND_TAG:-latest}
else
    echo "Warning: tags.conf file not found, using default tags."
    BACKEND_TAG="latest"
    FRONTEND_TAG="latest"
fi

# DOCKERHUB REGISTRY LOGIN
echo "<DOCKERHUB_PERSONAL_ACCESS_TOKEN>" | docker login --username bijaydockerhub --password-stdin 

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --backend) DEPLOY_BACKEND=1 ;;  # Deploy backend only
        --frontend) DEPLOY_FRONTEND=1 ;; # Deploy frontend only
        --both) DEPLOY_BACKEND=1; DEPLOY_FRONTEND=1 ;; # Deploy both
        --backend-tag) BACKEND_TAG="$2"; shift ;; # Use specific backend image tag
        --frontend-tag) FRONTEND_TAG="$2"; shift ;; # Use specific frontend image tag
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Export tags
export BACKEND_TAG
export FRONTEND_TAG
export DEPLOY_BACKEND
export DEPLOY_FRONTEND

# Validate required services
if [[ "$DEPLOY_BACKEND" -eq 0 && "$DEPLOY_FRONTEND" -eq 0 ]]; then
    echo "Error: No services specified. Use --backend, --frontend, or --both."
    exit 1
fi

# Function to pull docker image
pull_image() {
    local service=$1
    local tag=$2
    local repo=$3

    echo "Pulling $service image: $repo:$service-$tag"
    docker pull $IMAGE_REPOSITORY:$service-$tag
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to pull image for $service"
        exit 1
    fi
}

# Pull the images
if [[ "$DEPLOY_BACKEND" -eq 1 ]]; then
    echo "Using backend tag: $BACKEND_TAG"
    pull_image "backend" $BACKEND_TAG $IMAGE_REPOSITORY
fi

if [[ "$DEPLOY_FRONTEND" -eq 1 ]]; then
    echo "Using frontend tag: $FRONTEND_TAG"
    pull_image "front" $FRONTEND_TAG $IMAGE_REPOSITORY
fi

# Function to deploy services using Docker Compose
docker compose down && docker compose up -d 
 

# Clean up unused images
echo "Cleaning up dangling images..."
docker image prune -f

# Save the current tags to tags.conf for future use
echo "Saving the current tags to tags.conf..."
echo "BACKEND_TAG=$BACKEND_TAG" > tags.conf
echo "FRONTEND_TAG=$FRONTEND_TAG" >> tags.conf

