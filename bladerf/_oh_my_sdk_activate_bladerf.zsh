#!/usr/bin/env zsh

# Function to activate BladeRF environment
function activate_bladerf() {
    # Skip if already activated
    if [[ -n "${OMSDK_BLADERF_ACTIVATED}" ]]; then
        _oh_my_sdk_print_status "info" "BladeRF environment already activated"
        return 0
    fi

    # Debug output for variable
    _oh_my_sdk_print_status "info" "OH_MY_SDK_DIST value: ${OH_MY_SDK_DIST}"
    
    local bladerf_dir="${OH_MY_SDK_DIST}/bladerf"
    local bladerf_bin="${bladerf_dir}/bin"
    local bladerf_lib="${bladerf_dir}/lib"
    
    # Debug output
    _oh_my_sdk_print_status "info" "Looking for BladeRF directory at: ${bladerf_dir}"
    
    # Check if directories exist
    if [[ ! -d "${bladerf_dir}" ]]; then
        _oh_my_sdk_print_status "error" "BladeRF directory not found at ${bladerf_dir}"
        return 1
    fi
    
    if [[ ! -d "${bladerf_bin}" ]]; then
        _oh_my_sdk_print_status "error" "BladeRF binaries not found at ${bladerf_bin}"
        return 1
    fi
    
    # Change to BladeRF directory
    if ! cd "${bladerf_dir}"; then
        _oh_my_sdk_print_status "error" "Failed to change to BladeRF directory"
        return 1
    fi
    
    # Activate Python virtual environment
    _oh_my_sdk_print_status "info" "Activating Python virtual environment..."
    if ! _oh_my_sdk_activate_venv "bladerf"; then
        _oh_my_sdk_print_status "error" "Failed to activate virtual environment"
        return 1
    fi
    
    # Add BladeRF binaries to PATH
    PATH="${bladerf_bin}:${PATH}"
    export PATH
    
    # Add library path
    LD_LIBRARY_PATH="${bladerf_lib}:${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH
    
    # Mark environment as activated
    export OMSDK_BLADERF_ACTIVATED=1
    
    _oh_my_sdk_print_status "success" "BladeRF environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  • bladeRF-cli               BladeRF command line interface"
    echo "  • bladeRF-fsk              BladeRF FSK utility"
    echo "  • bladeRF-cli -i           Start interactive console"
    echo "  • omsdk deactivate         Deactivate environment"
} 