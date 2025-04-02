#!/usr/bin/env zsh

# Function to activate NRF Connect environment
function activate_nrf() {
    # Skip if already activated
    if [[ -n "${OMSDK_NRF_ACTIVATED}" ]]; then
        _oh_my_sdk_print_status "info" "NRF environment already activated"
        return 0
    fi

    # Debug output for variable
    _oh_my_sdk_print_status "info" "OH_MY_SDK_DIST value: ${OH_MY_SDK_DIST}"
    
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    local nrf_cli_dir="${OH_MY_SDK_DIST}/nrf-command-line-tools"
    
    # Debug output
    _oh_my_sdk_print_status "info" "Looking for NRF directory at: ${nrf_dir}"
    _oh_my_sdk_print_status "info" "Looking for Command Line Tools at: ${nrf_cli_dir}"
    
    # Check if directories exist
    if [[ ! -d "${nrf_dir}" ]]; then
        _oh_my_sdk_print_status "error" "NRF directory not found at ${nrf_dir}"
        return 1
    fi
    
    if [[ ! -d "${nrf_cli_dir}" ]]; then
        _oh_my_sdk_print_status "error" "Command Line Tools directory not found at ${nrf_cli_dir}"
        return 1
    fi
    
    # Change to NRF directory
    if ! cd "${nrf_dir}"; then
        _oh_my_sdk_print_status "error" "Failed to change to NRF directory"
        return 1
    fi
    
    # Activate Python virtual environment
    _oh_my_sdk_print_status "info" "Activating Python virtual environment..."
    if ! _oh_my_sdk_activate_venv "nrf"; then
        _oh_my_sdk_print_status "error" "Failed to activate virtual environment"
        return 1
    fi
    
    # Export Zephyr CMake package (NRF uses Zephyr)
    _oh_my_sdk_print_status "info" "Exporting Zephyr CMake package..."
    if ! west zephyr-export; then
        _oh_my_sdk_print_status "error" "Failed to export Zephyr CMake package"
        return 1
    fi
    
    # Set Zephyr environment variables
    export ZEPHYR_BASE="${nrf_dir}/zephyr"
    export ZEPHYR_TOOLCHAIN_VARIANT="zephyr"
    
    # Add Nordic tools to PATH
    PATH="${nrf_cli_dir}/bin:${PATH}"
    export PATH
    
    # Add library path
    LD_LIBRARY_PATH="${nrf_cli_dir}/lib:${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH
    
    # Add include path
    C_INCLUDE_PATH="${nrf_cli_dir}/include:${C_INCLUDE_PATH}"
    export C_INCLUDE_PATH
    
    # Mark environment as activated
    export OMSDK_NRF_ACTIVATED=1
    
    # Add west completion
    _oh_my_sdk_print_status "info" "Adding west completion..."
    eval "$(west completion zsh)"
    
    _oh_my_sdk_print_status "success" "NRF Connect environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  • west help                  Show west command help"
    echo "  • nrfutil help              Show nrfutil command help"
    echo "  • omsdk deactivate          Deactivate environment"
} 