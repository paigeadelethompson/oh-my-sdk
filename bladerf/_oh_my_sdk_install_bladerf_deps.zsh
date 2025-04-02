#!/usr/bin/env zsh

# Function to install BladeRF dependencies
function _oh_my_sdk_install_bladerf_deps() {
    _oh_my_sdk_print_status "info" "Installing BladeRF dependencies..."
    
    # Check package manager and install dependencies
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y build-essential cmake git libusb-1.0-0-dev \
            pkg-config libtecla1 libtecla-dev libncurses5-dev python3-dev \
            python3-pip qt5-default
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y gcc gcc-c++ make cmake git libusb1-devel \
            pkgconfig libtecla-devel ncurses-devel python3-devel \
            python3-pip qt5-qtbase-devel
    elif command -v yum &> /dev/null; then
        sudo yum install -y gcc gcc-c++ make cmake git libusb1-devel \
            pkgconfig libtecla-devel ncurses-devel python3-devel \
            python3-pip qt5-qtbase-devel
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y gcc gcc-c++ make cmake git libusb-1_0-devel \
            pkg-config libtecla-devel ncurses-devel python3-devel \
            python3-pip libqt5-qtbase-devel
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm base-devel cmake git libusb pkgconf \
            libtecla ncurses python python-pip qt5-base
    else
        _oh_my_sdk_print_status "error" "No supported package manager found"
        return 1
    fi
    
    _oh_my_sdk_print_status "success" "BladeRF dependencies installed"
} 