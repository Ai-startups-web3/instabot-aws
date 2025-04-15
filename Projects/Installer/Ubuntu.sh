#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error: $1" >&2
    exit 1
}

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y || handle_error "Failed to update system packages"

# Install essential build tools
echo "Installing build essentials..."
sudo apt-get install -y build-essential || handle_error "Failed to install build essentials"

# Install Git
echo "Installing Git..."
sudo apt-get install -y git || handle_error "Failed to install Git"

# Verify Git installation
echo "Git version:"
git --version || handle_error "Git not installed properly"

# Install Node.js (using NodeSource for newer versions)
echo "Setting up NodeSource repository..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || handle_error "Failed to setup NodeSource repository"

echo "Installing Node.js and npm..."
sudo apt-get install -y nodejs || handle_error "Failed to install Node.js"

# Verify Node.js and npm installation
echo "Node.js version:"
node -v || handle_error "Node.js not installed properly"
echo "npm version:"
npm -v || handle_error "npm not installed properly"

# Clean up
echo "Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean

echo ""
echo "All installations completed successfully!"
echo "Node.js $(node -v)"
echo "npm $(npm -v)"
echo "Git $(git --version)"