#!/usr/bin/env zsh

# Function to install Infineon system dependencies
function _oh_my_sdk_install_infineon_deps() {
    _oh_my_sdk_print_status "info" "Installing Infineon system dependencies..."
    
    # Check package manager and install alien
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y alien
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y alien
    elif command -v yum &> /dev/null; then
        sudo yum install -y alien
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y alien
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm alien
    else
        _oh_my_sdk_print_status "error" "No supported package manager found"
        return 1
    fi
    
    _oh_my_sdk_print_status "success" "Infineon system dependencies installed"
} 