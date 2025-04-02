#!/usr/bin/env zsh

# Function to activate Arduino environment
function activate_arduino() {
    # Skip if already activated
    if [[ -n "${OMSDK_ARDUINO_ACTIVATED}" ]]; then
        _oh_my_sdk_print_status "info" "Arduino environment already activated"
        return 0
    fi

    # Debug output for variable
    _oh_my_sdk_print_status "info" "OH_MY_SDK_DIST value: ${OH_MY_SDK_DIST}"
    
    local arduino_dir="${OH_MY_SDK_DIST}/arduino"
    local arduino_cli_dir="${arduino_dir}/cli"
    
    # Debug output
    _oh_my_sdk_print_status "info" "Looking for Arduino directory at: ${arduino_dir}"
    _oh_my_sdk_print_status "info" "Looking for Arduino CLI at: ${arduino_cli_dir}"
    
    # Check if directories exist
    if [[ ! -d "${arduino_dir}" ]]; then
        _oh_my_sdk_print_status "error" "Arduino directory not found at ${arduino_dir}"
        return 1
    fi
    
    if [[ ! -d "${arduino_cli_dir}" ]]; then
        _oh_my_sdk_print_status "error" "Arduino CLI directory not found at ${arduino_cli_dir}"
        return 1
    fi
    
    # Change to Arduino directory
    if ! cd "${arduino_dir}"; then
        _oh_my_sdk_print_status "error" "Failed to change to Arduino directory"
        return 1
    fi
    
    # Activate Python virtual environment
    _oh_my_sdk_print_status "info" "Activating Python virtual environment..."
    if ! _oh_my_sdk_activate_venv "arduino"; then
        _oh_my_sdk_print_status "error" "Failed to activate virtual environment"
        return 1
    fi
    
    # Add Arduino CLI to PATH
    PATH="${arduino_cli_dir}:${PATH}"
    export PATH
    
    # Mark environment as activated
    export OMSDK_ARDUINO_ACTIVATED=1
    
    _oh_my_sdk_print_status "success" "Arduino environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  • arduino-cli help           Show Arduino CLI help"
    echo "  • arduino-cli compile        Compile Arduino sketch"
    echo "  • arduino-cli upload         Upload Arduino sketch"
    echo "  • arduino-cli board list     List connected boards"
    echo "  • omsdk deactivate          Deactivate environment"
} 