#!/usr/bin/env zsh

# Function to check and install system dependencies
function _oh_my_sdk_install_system_deps() {
    local deps=(
        "git"
        "cmake"
        "ninja-build"
        "gperf"
        "ccache"
        "dfu-util"
        "device-tree-compiler"
        "wget"
        "python3"
        "python3-pip"
        "python3-venv"
        "make"
        "gcc"
        "gcc-multilib"
        "g++-multilib"
        "libsdl2-dev"
        "libmagic1"
    )
    
    # Check which packages are missing
    local missing_deps=()
    for dep in "${deps[@]}"; do
        if ! _oh_my_sdk_command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done
    
    # Install missing packages in one go
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        _oh_my_sdk_print_status "info" "Installing system dependencies..."
        sudo apt-get install -y "${missing_deps[@]}"
    fi
} 