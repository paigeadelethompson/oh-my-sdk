#!/usr/bin/env zsh

# Function to install Arduino dependencies
function _oh_my_sdk_install_arduino_deps() {
    _oh_my_sdk_print_status "info" "Installing Arduino dependencies..."
    
    # Check package manager and install dependencies
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3-dev python3-pip python3-venv git curl \
            build-essential cmake
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y python3-devel python3-pip python3-virtualenv git curl \
            gcc gcc-c++ make cmake
    elif command -v yum &> /dev/null; then
        sudo yum install -y python3-devel python3-pip python3-virtualenv git curl \
            gcc gcc-c++ make cmake
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y python3-devel python3-pip python3-virtualenv git curl \
            gcc gcc-c++ make cmake
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm python python-pip python-virtualenv git curl \
            base-devel cmake
    else
        _oh_my_sdk_print_status "error" "No supported package manager found"
        return 1
    fi
    
    _oh_my_sdk_print_status "success" "Arduino dependencies installed"
} 