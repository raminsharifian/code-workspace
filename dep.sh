#!/usr/bin/env bash

set -euo pipefail  # Exit on error, undefined variables, pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if package is installed (Debian/Ubuntu)
package_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q '^ii'
}

# Function to install package if not present
install_package() {
    local package=$1
    local description=${2:-$package}
    
    if package_installed "$package"; then
        log_info "$description is already installed"
        return 0
    fi
    
    log_info "Installing $description..."
    if sudo apt install -y "$package"; then
        log_success "Successfully installed $description"
    else
        log_error "Failed to install $description"
        return 1
    fi
}

# Function to install Starship if not present
install_starship() {
    if command_exists starship; then
        log_info "Starship is already installed"
        return 0
    fi
    
    log_info "Installing Starship..."
    
    # Create temporary file for the install script
    local temp_script
    temp_script=$(mktemp)
    
    # Download the install script
    if ! curl -sS https://starship.rs/install.sh -o "$temp_script"; then
        log_error "Failed to download Starship install script"
        rm -f "$temp_script"
        return 1
    fi
    
    # Make it executable and run
    chmod +x "$temp_script"
    
    # Run with yes flag for non-interactive installation
    if "$temp_script" -y; then
        log_success "Successfully installed Starship"
    else
        log_error "Failed to install Starship"
        rm -f "$temp_script"
        return 1
    fi
    
    # Clean up
    rm -f "$temp_script"
}

# Main installation function
main() {
    log_info "Starting package installation..."
    
    # Update package list first
    log_info "Updating package list..."
    if ! sudo apt update; then
        log_error "Failed to update package list"
        exit 1
    fi
    
    # Install packages
    install_package "python3" "Python 3"
    install_package "python3-venv" "Python 3 virtual environment"
    install_package "python-is-python3" "Python symlink"
    install_package "git" "Git"
    install_package "jq" "jq JSON processor"
    install_package "curl" "cURL"
    
    # Install Starship
    install_starship
    
    log_success "All installations completed successfully!"
    
    # Show versions of installed software
    log_info "Installation verification:"
    if command_exists python3; then
        echo "  Python: $(python3 --version 2>/dev/null || echo "Not found")"
    fi
    if command_exists git; then
        echo "  Git: $(git --version 2>/dev/null || echo "Not found")"
    fi
    if command_exists jq; then
        echo "  jq: $(jq --version 2>/dev/null || echo "Not found")"
    fi
    if command_exists starship; then
        echo "  Starship: $(starship --version 2>/dev/null || echo "Not found")"
    fi
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log_warning "This script is running as root. It's better to run as regular user and use sudo when needed."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Run main function
main "$@"