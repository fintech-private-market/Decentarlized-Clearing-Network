#!/bin/bash
# Script to run tests for Canton DCN

set -e

echo "Running Canton Clearing Network tests..."

# Navigate to daml directory
cd "$(dirname "$0")/../daml"

# Run Daml tests
echo "Running Daml tests..."
daml test

echo "All tests passed!"
