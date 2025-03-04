#!/bin/bash
set -e

# Install supergateway globally if not already installed
if ! command -v supergateway &> /dev/null; then
    echo "Installing supergateway..."
    npm install -g supergateway
fi

# Setup linear-mcp if not already present
if [ ! -d "/app/linear-mcp" ]; then
    echo "Cloning linear-mcp repository..."
    cd /app
    #git clone https://github.com/cline/linear-mcp.git
    git clone https://github.com/odgrim/linear-mcp.git
    cd linear-mcp
    git checkout add-api-key-auth
fi

# Install and build linear-mcp
cd /app/linear-mcp
echo "Installing dependencies..."
npm install

echo "Building linear-mcp..."
npm run build

# Check if build was successful
if [ ! -f "./build/index.js" ]; then
    echo "Error: Build failed - build/index.js not found"
    exit 1
fi

echo "Starting supergateway with linear-mcp..."
exec supergateway --port 8000 --baseUrl /linear --stdio "node ./build/index.js"
 
