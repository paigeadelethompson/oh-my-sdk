#!/usr/bin/env zsh

# Function to install NodeMCU SDK
function install_nodemcu() {
    _oh_my_sdk_print_status "info" "Starting NodeMCU SDK installation..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    _oh_my_sdk_install_nodemcu_deps
    
    local nodemcu_dir="${OH_MY_SDK_DIST}/nodemcu"
    local nodemcu_tools="${nodemcu_dir}/tools"
    local nodemcu_firmware="${nodemcu_dir}/firmware"
    
    if [[ ! -d "${nodemcu_dir}" ]] || [[ ! -d "${nodemcu_tools}" ]]; then
        _oh_my_sdk_print_status "info" "Creating NodeMCU workspace..."
        mkdir -p "${nodemcu_dir}"
        mkdir -p "${nodemcu_tools}"
        mkdir -p "${nodemcu_firmware}"
        cd "${nodemcu_dir}"

        # Create and activate virtual environment
        _oh_my_sdk_print_status "info" "Setting up Python virtual environment..."
        _oh_my_sdk_create_venv "nodemcu"
        _oh_my_sdk_activate_venv "nodemcu"

        # Clone NodeMCU firmware
        _oh_my_sdk_print_status "info" "Cloning NodeMCU firmware..."
        git clone --recursive https://github.com/nodemcu/nodemcu-firmware.git "${nodemcu_firmware}/src"
        
        # Install Python packages
        _oh_my_sdk_print_status "info" "Installing Python requirements..."
        pip install esptool
        pip install nodemcu-uploader
        pip install adafruit-ampy
        pip install rshell
        
        # Download additional tools
        _oh_my_sdk_print_status "info" "Installing NodeMCU tools..."
        cd "${nodemcu_tools}"
        
        # Get ESPlorer
        wget https://github.com/4refr0nt/ESPlorer/releases/download/latest/ESPlorer.zip
        unzip ESPlorer.zip -d esplorer
        rm ESPlorer.zip
        
        deactivate
        _oh_my_sdk_print_status "success" "NodeMCU SDK installation complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'omsdk activate nodemcu' to activate the environment"
        echo "  2. Run 'esptool.py --port /dev/ttyUSB0 flash_id' to test connection"
        echo "  3. Run 'omsdk help nodemcu' for more information"
    else
        _oh_my_sdk_print_status "warning" "NodeMCU SDK is already installed."
    fi
} 