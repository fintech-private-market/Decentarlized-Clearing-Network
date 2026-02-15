#!/bin/bash
# Daml SDK Installation Script with Multiple Fallback Methods
# Script de Instalação do Daml SDK com Múltiplos Métodos de Fallback

set -e

echo "========================================="
echo "Daml SDK Installation Script"
echo "Script de Instalação do Daml SDK"
echo "========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo "ℹ️  $1"
}

# Check if daml is already installed
if command -v daml &> /dev/null; then
    INSTALLED_VERSION=$(daml version 2>&1 | head -n 1 || echo "unknown")
    print_success "Daml SDK is already installed: $INSTALLED_VERSION"
    echo ""
    echo "To upgrade or reinstall, run: curl -sSL https://get.daml.com/ | sh"
    exit 0
fi

print_info "Daml SDK not found. Attempting installation..."
echo ""

# Method 1: Standard installation
print_info "Method 1: Attempting standard installation from get.daml.com..."
if curl -sSL https://get.daml.com/ | sh; then
    print_success "Standard installation successful!"
    
    # Add to PATH
    export PATH="$HOME/.daml/bin:$PATH"
    
    # Verify installation
    if daml version; then
        print_success "Daml SDK installed successfully!"
        echo ""
        echo "Please add the following line to your ~/.bashrc or ~/.zshrc:"
        echo 'export PATH="$HOME/.daml/bin:$PATH"'
        exit 0
    fi
else
    print_warning "Standard installation failed (network may be restricted)"
fi

echo ""

# Method 2: Try with wget
print_info "Method 2: Attempting installation with wget..."
if wget -qO- https://get.daml.com/ | sh; then
    print_success "Installation with wget successful!"
    export PATH="$HOME/.daml/bin:$PATH"
    
    if daml version; then
        print_success "Daml SDK installed successfully!"
        echo ""
        echo "Please add the following line to your ~/.bashrc or ~/.zshrc:"
        echo 'export PATH="$HOME/.daml/bin:$PATH"'
        exit 0
    fi
else
    print_warning "Installation with wget failed"
fi

echo ""

# Method 3: Docker-based installation suggestion
print_warning "Direct installation failed. Alternative methods:"
echo ""
echo "========================================="
echo "Alternative Installation Methods"
echo "Métodos Alternativos de Instalação"
echo "========================================="
echo ""

echo "Method 3: Docker-based build"
echo "----------------------------"
echo "If you have Docker installed, create a Dockerfile:"
echo ""
cat << 'EOF'
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl ca-certificates && \
    curl -sSL https://get.daml.com/ | sh
ENV PATH="/root/.daml/bin:${PATH}"
WORKDIR /workspace
EOF
echo ""
echo "Build and use:"
echo "  docker build -t daml-builder -f Dockerfile.daml ."
echo "  docker run -v \$(pwd):/workspace daml-builder daml build"
echo ""

echo "Method 4: Manual download from GitHub"
echo "-------------------------------------"
echo "Visit https://github.com/digital-asset/daml/releases"
echo "Download the appropriate version and follow manual installation steps"
echo ""

echo "Method 5: CI/CD Environment"
echo "---------------------------"
echo "Use GitHub Actions, GitLab CI, or other CI/CD with Daml SDK pre-installed"
echo ""

echo "Method 6: Build on another machine"
echo "-----------------------------------"
echo "Build the project on a machine with Daml SDK installed"
echo "Then copy the .dar file to this environment"
echo ""

print_error "Automatic installation failed. Please use one of the alternative methods above."
echo ""
echo "For more details, see: DAML_SDK_INSTALLATION.md"
exit 1
