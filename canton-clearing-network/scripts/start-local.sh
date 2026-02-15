#!/bin/bash
# Script to start Canton with local configuration

set -e

echo "Starting Canton Clearing Network (Local)..."

# Check if Canton is installed
if ! command -v canton &> /dev/null; then
    echo "Error: Canton is not installed"
    echo "Please install Canton SDK from https://www.canton.io/downloads"
    exit 1
fi

# Navigate to project root
cd "$(dirname "$0")/.."

# Start Canton with local configuration
echo "Starting Canton with local configuration..."
canton -c canton-config/local/local.conf
