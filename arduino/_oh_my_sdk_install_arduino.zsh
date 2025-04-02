#!/usr/bin/env zsh

# Function to install Arduino SDK
function install_arduino() {
    _oh_my_sdk_print_status "info" "Starting Arduino SDK installation..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    _oh_my_sdk_install_arduino_deps
    
    local arduino_dir="${OH_MY_SDK_DIST}/arduino"
    local arduino_cli_dir="${arduino_dir}/cli"
    
    if [[ ! -d "${arduino_dir}" ]] || [[ ! -d "${arduino_cli_dir}" ]]; then
        _oh_my_sdk_print_status "info" "Creating Arduino workspace..."
        mkdir -p "${arduino_dir}"
        mkdir -p "${arduino_cli_dir}"
        cd "${arduino_dir}"

        # Create and activate virtual environment
        _oh_my_sdk_print_status "info" "Setting up Python virtual environment..."
        _oh_my_sdk_create_venv "arduino"
        _oh_my_sdk_activate_venv "arduino"

        # Download and install Arduino CLI
        _oh_my_sdk_print_status "info" "Downloading Arduino CLI..."
        curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="${arduino_cli_dir}" sh
        
        # Initialize Arduino CLI config
        "${arduino_cli_dir}/arduino-cli" config init
        
        # Install core platforms
        _oh_my_sdk_print_status "info" "Installing Arduino cores..."
        "${arduino_cli_dir}/arduino-cli" core update-index
        "${arduino_cli_dir}/arduino-cli" core install arduino:avr
        "${arduino_cli_dir}/arduino-cli" core install arduino:samd
        
        # Install common libraries
        _oh_my_sdk_print_status "info" "Installing common libraries..."
        "${arduino_cli_dir}/arduino-cli" lib install "WiFi"
        "${arduino_cli_dir}/arduino-cli" lib install "ArduinoJson"
        "${arduino_cli_dir}/arduino-cli" lib install "PubSubClient"
        
        deactivate
        _oh_my_sdk_print_status "success" "Arduino SDK installation complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'omsdk activate arduino' to activate the environment"
        echo "  2. Run 'omsdk create arduino <name>' to create a new project"
        echo "  3. Run 'omsdk help arduino' for more information"
    else
        _oh_my_sdk_print_status "warning" "Arduino SDK is already installed."
    fi
} 