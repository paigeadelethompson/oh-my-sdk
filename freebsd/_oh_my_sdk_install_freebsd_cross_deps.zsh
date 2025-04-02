#!/usr/bin/env zsh

# Function to install FreeBSD cross-compilation dependencies
function _oh_my_sdk_install_freebsd_cross_deps() {
    _oh_my_sdk_print_status "info" "Installing FreeBSD cross-compilation dependencies..."
    
    # Check package manager and install dependencies
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y build-essential git cmake ninja-build \
            clang lld llvm python3-dev python3-pip python3-venv \
            bison flex libxml2-dev libelf-dev libarchive-dev \
            libbz2-dev liblzma-dev libssl-dev
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y gcc gcc-c++ git cmake ninja-build \
            clang lld llvm python3-devel python3-pip \
            bison flex libxml2-devel elfutils-libelf-devel libarchive-devel \
            bzip2-devel xz-devel openssl-devel
    elif command -v yum &> /dev/null; then
        sudo yum install -y gcc gcc-c++ git cmake ninja-build \
            clang lld llvm python3-devel python3-pip \
            bison flex libxml2-devel elfutils-libelf-devel libarchive-devel \
            bzip2-devel xz-devel openssl-devel
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y gcc gcc-c++ git cmake ninja \
            clang lld llvm python3-devel python3-pip \
            bison flex libxml2-devel libelf-devel libarchive-devel \
            libbz2-devel liblzma-devel libopenssl-devel
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm base-devel git cmake ninja \
            clang lld llvm python python-pip \
            bison flex libxml2 libelf libarchive \
            bzip2 xz openssl
    else
        _oh_my_sdk_print_status "error" "No supported package manager found"
        return 1
    fi
    
    _oh_my_sdk_print_status "success" "FreeBSD cross-compilation dependencies installed"
} 