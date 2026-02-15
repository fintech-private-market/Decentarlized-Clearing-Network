#!/bin/bash
# Script to build the Canton DCN project

set -e

echo "Building Canton Clearing Network..."

# Navigate to daml directory
cd "$(dirname "$0")/../daml"

# Build the Daml project
echo "Building Daml templates..."
daml build

echo "Build complete! DAR file created at: .daml/dist/canton-clearing-network-0.1.0.dar"
