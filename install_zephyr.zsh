#!/usr/bin/env zsh

# Function to install Zephyr SDK
function install_zephyr() {
    echo "Installing Zephyr SDK..."
    
    # Install system dependencies first
    _oh_my_sdk_install_system_deps
    
    local zephyr_dir="${OH_MY_SDK_DIST}/zephyr"
    
    if [[ ! -d "${zephyr_dir}" ]]; then
        mkdir -p "${zephyr_dir}"
        cd "${zephyr_dir}"
        
        # Create and activate virtual environment
        _oh_my_sdk_create_venv "zephyr"
        _oh_my_sdk_activate_venv "zephyr"
        
        # Install west
        pip install west
        
        # Initialize west workspace
        west init .
        west update
        
        # Export Zephyr CMake package
        west zephyr-export
        
        # Install Python dependencies
        west packages pip --install
        
        # Install Zephyr SDK
        west sdk install
        
        deactivate
        echo "Zephyr SDK installation complete!"
    else
        echo "Zephyr SDK is already installed."
    fi
} 