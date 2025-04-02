#!/usr/bin/env zsh

# Function to activate Infineon AIROC/CYP environment
function activate_infineon() {
    # Skip if already activated
    if [[ -n "${OMSDK_INFINEON_ACTIVATED}" ]]; then
        _oh_my_sdk_print_status "info" "Infineon environment already activated"
        return 0
    fi

    # Debug output for variable
    _oh_my_sdk_print_status "info" "OH_MY_SDK_DIST value: ${OH_MY_SDK_DIST}"
    
    local infineon_dir="${OH_MY_SDK_DIST}/infineon"
    local modustoolbox_dir="${infineon_dir}/modustoolbox"
    
    # Debug output
    _oh_my_sdk_print_status "info" "Looking for Infineon directory at: ${infineon_dir}"
    _oh_my_sdk_print_status "info" "Looking for ModusToolbox at: ${modustoolbox_dir}"
    
    # Check if directories exist
    if [[ ! -d "${infineon_dir}" ]]; then
        _oh_my_sdk_print_status "error" "Infineon directory not found at ${infineon_dir}"
        return 1
    fi
    
    if [[ ! -d "${modustoolbox_dir}" ]]; then
        _oh_my_sdk_print_status "error" "ModusToolbox directory not found at ${modustoolbox_dir}"
        return 1
    fi
    
    # Change to Infineon directory
    if ! cd "${infineon_dir}"; then
        _oh_my_sdk_print_status "error" "Failed to change to Infineon directory"
        return 1
    fi
    
    # Activate Python virtual environment
    _oh_my_sdk_print_status "info" "Activating Python virtual environment..."
    if ! _oh_my_sdk_activate_venv "infineon"; then
        _oh_my_sdk_print_status "error" "Failed to activate virtual environment"
        return 1
    fi
    
    # Add ModusToolbox to PATH
    PATH="${modustoolbox_dir}/tools_3.4/library-manager:${PATH}"
    PATH="${modustoolbox_dir}/tools_3.4/project-creator:${PATH}"
    PATH="${modustoolbox_dir}/tools_3.4/dfuh-tool:${PATH}"
    PATH="${modustoolbox_dir}/tools_3.4/fw-loader:${PATH}"
    PATH="${modustoolbox_dir}/tools_3.4/openocd:${PATH}"
    export PATH
    
    # Add library path
    LD_LIBRARY_PATH="${modustoolbox_dir}/tools_3.4/openocd/lib:${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH
    
    # Set ModusToolbox environment variables
    export CY_TOOLS_PATHS="${modustoolbox_dir}/tools_3.4"
    export CY_PYTHON_PATH="${modustoolbox_dir}/tools_3.4/python"
    
    # Mark environment as activated
    export OMSDK_INFINEON_ACTIVATED=1
    
    _oh_my_sdk_print_status "success" "Infineon AIROC/CYP environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  • library-manager          Launch ModusToolbox Library Manager"
    echo "  • project-creator          Create new ModusToolbox project"
    echo "  • dfuh-tool               Device Firmware Update Host Tool"
    echo "  • fw-loader               Firmware Loader"
    echo "  • openocd                 OpenOCD for programming/debugging"
    echo "  • omsdk deactivate        Deactivate environment"
} 