#!/usr/bin/env zsh

# Function to activate NodeMCU environment
function activate_nodemcu() {
    # Skip if already activated
    if [[ -n "${OMSDK_NODEMCU_ACTIVATED}" ]]; then
        _oh_my_sdk_print_status "info" "NodeMCU environment already activated"
        return 0
    fi

    # Debug output for variable
    _oh_my_sdk_print_status "info" "OH_MY_SDK_DIST value: ${OH_MY_SDK_DIST}"
    
    local nodemcu_dir="${OH_MY_SDK_DIST}/nodemcu"
    local nodemcu_tools="${nodemcu_dir}/tools"
    local nodemcu_firmware="${nodemcu_dir}/firmware"
    
    # Debug output
    _oh_my_sdk_print_status "info" "Looking for NodeMCU directory at: ${nodemcu_dir}"
    _oh_my_sdk_print_status "info" "Looking for NodeMCU tools at: ${nodemcu_tools}"
    
    # Check if directories exist
    if [[ ! -d "${nodemcu_dir}" ]]; then
        _oh_my_sdk_print_status "error" "NodeMCU directory not found at ${nodemcu_dir}"
        return 1
    fi
    
    if [[ ! -d "${nodemcu_tools}" ]]; then
        _oh_my_sdk_print_status "error" "NodeMCU tools not found at ${nodemcu_tools}"
        return 1
    fi
    
    # Change to NodeMCU directory
    if ! cd "${nodemcu_dir}"; then
        _oh_my_sdk_print_status "error" "Failed to change to NodeMCU directory"
        return 1
    fi
    
    # Activate Python virtual environment
    _oh_my_sdk_print_status "info" "Activating Python virtual environment..."
    if ! _oh_my_sdk_activate_venv "nodemcu"; then
        _oh_my_sdk_print_status "error" "Failed to activate virtual environment"
        return 1
    fi
    
    # Add NodeMCU tools to PATH
    PATH="${nodemcu_tools}:${PATH}"
    export PATH
    
    # Set NodeMCU environment variables
    export NODEMCU_PATH="${nodemcu_dir}"
    export NODEMCU_FIRMWARE="${nodemcu_firmware}/src"
    
    # Mark environment as activated
    export OMSDK_NODEMCU_ACTIVATED=1
    
    _oh_my_sdk_print_status "success" "NodeMCU environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  • esptool.py               Flash firmware and manage ESP8266"
    echo "  • nodemcu-uploader         Upload Lua files to NodeMCU"
    echo "  • ampy                     Transfer files to/from board"
    echo "  • rshell                   Remote shell for MicroPython"
    echo "  • java -jar esplorer.jar   Launch ESPlorer IDE"
    echo "  • omsdk deactivate         Deactivate environment"
} 