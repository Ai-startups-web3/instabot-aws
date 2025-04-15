#!/bin/bash

# Create swap file if it doesn't exist
if [ ! -f /swapfile ]; then
    echo "Creating 2GB swap file..."
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo "Swap created successfully"
fi

# Define repository URLs
REPO1="https://github.com/Ai-startups-web3/insta-bot"
REPO2="https://github.com/Ai-startups-web3/aws-bucket"

# AWS Video File URL
AWS_VIDEO_URL="https://metakulbucket.s3.us-east-1.amazonaws.com/videoplayback.mp4"

# Function to check if port is available
check_port() {
    local PORT=$1
    nc -z localhost "$PORT" >/dev/null 2>&1
    return $?
}

# Function to clone or update a repo
update_repo() {
    local REPO_URL=$1
    local DIR_NAME=$(basename "$REPO_URL")

    if [ -d "$DIR_NAME" ]; then
        echo "Updating $DIR_NAME..."
        cd "$DIR_NAME" || { echo "Failed to enter $DIR_NAME"; exit 1; }
        git pull origin main || { echo "Failed to pull latest changes for $DIR_NAME"; exit 1; }
        cd ..
    else
        echo "Cloning $DIR_NAME..."
        git clone "$REPO_URL" || { echo "Failed to clone $DIR_NAME"; exit 1; }
    fi
}

# Function to download video file
download_video() {
    local URL=$1
    local OUTPUT_PATH="insta-bot/assets/input/videoToPost.mp4"

    mkdir -p insta-bot/assets/input
    echo "Downloading video from AWS..."

    if command -v wget &> /dev/null; then
        wget -O "$OUTPUT_PATH" "$URL" || { echo "Failed to download video"; exit 1; }
    elif command -v curl &> /dev/null; then
        curl -o "$OUTPUT_PATH" "$URL" || { echo "Failed to download video"; exit 1; }
    else
        echo "Neither wget nor curl found. Please install one of them."
        exit 1
    fi
}

# Function to install dependencies and start a service
start_service() {
    local DIR=$1
    local PORT=${2:-0}  # Default to 0 if not specified
    
    echo "Setting up $DIR..."
    
    if [ -d "$DIR" ]; then
        cd "$DIR" || { echo "Failed to enter $DIR"; return 1; }
        
        # Install dependencies
        echo "Installing dependencies for $DIR..."
        npm install || { echo "Failed to install dependencies for $DIR"; return 1; }
        
        # Check port if specified
        if [ "$PORT" -ne 0 ]; then
            if check_port "$PORT"; then
                echo "Port $PORT is already in use. Skipping $DIR..."
                cd ..
                return 1
            fi
        fi
        
        # Start the service in background with increased memory limit
        echo "Starting $DIR with increased memory limit..."
        NODE_OPTIONS="--max-old-space-size=512" npm start &
        
        cd ..
        return 0
    else
        echo "Directory $DIR not found!"
        return 1
    fi
}


# Main execution
echo "Starting setup..."

# Clone/update repos
update_repo "$REPO1"
update_repo "$REPO2"

# Copy .env files if they exist
[ -f ".env.myBot" ] && cp .env.myBot insta-bot/.env || echo "Warning: .env.myBot not found for insta-bot"
[ -f ".env.myBot" ] && cp .env.myBot aws-bucket/.env || echo "Warning: .env.myBot not found for aws-bucket"

# Download video
download_video "$AWS_VIDEO_URL"

# Start services (assuming default ports)
start_service "insta-bot" 3000
start_service "aws-bucket" 7310

echo "Setup completed successfully!"
echo "Services are running in the background."

# Keep the script running to maintain background processes
wait