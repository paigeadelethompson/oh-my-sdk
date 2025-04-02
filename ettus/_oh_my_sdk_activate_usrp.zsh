#!/usr/bin/env zsh

# Function to activate USRP environment
function activate_usrp() {
    # Skip if already activated
    if [[ -n "${OMSDK_USRP_ACTIVATED}" ]]; then
        _oh_my_sdk_print_status "warning" "USRP environment is already activated."
        return 0
    fi
    
    _oh_my_sdk_print_debug "OH_MY_SDK_DIST=${OH_MY_SDK_DIST}"
    
    local usrp_dir="${OH_MY_SDK_DIST}/usrp"
    local uhd_dir="${usrp_dir}/uhd"
    local gnuradio_dir="${usrp_dir}/gnuradio"
    
    # Check if USRP directory exists
    if [[ ! -d "${usrp_dir}" ]]; then
        _oh_my_sdk_print_status "error" "USRP directory not found at ${usrp_dir}"
        _oh_my_sdk_print_status "info" "Please run 'omsdk install usrp' first"
        return 1
    fi
    
    # Check if UHD is installed
    if [[ ! -d "${uhd_dir}" ]]; then
        _oh_my_sdk_print_status "error" "UHD not found at ${uhd_dir}"
        _oh_my_sdk_print_status "info" "Please run 'omsdk install usrp' first"
        return 1
    fi
    
    # Change to USRP directory
    cd "${usrp_dir}"
    
    # Activate Python virtual environment
    _oh_my_sdk_activate_venv "usrp"
    
    # Update PATH to include USRP tools
    export PATH="${usrp_dir}/bin:${PATH}"
    
    # Update library path
    export LD_LIBRARY_PATH="${usrp_dir}/lib:${LD_LIBRARY_PATH}"
    
    # Set UHD specific environment variables
    export UHD_IMAGES_DIR="${usrp_dir}/share/uhd/images"
    export UHD_PKG_PATH="${usrp_dir}/lib/cmake/uhd"
    
    # Mark as activated
    export OMSDK_USRP_ACTIVATED=1
    
    _oh_my_sdk_print_status "success" "USRP environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  uhd_find_devices     - Detect connected USRP devices"
    echo "  uhd_usrp_probe      - Display detailed USRP device information"
    echo "  gnuradio-companion  - Launch GNU Radio GUI"
    echo "  uhd_config_info     - Display UHD build information"
    echo "  uhd_images_downloader - Download FPGA images"
    echo "  gr_modtool         - GNU Radio module creation tool"
    echo
    _oh_my_sdk_print_status "info" "Type 'omsdk help usrp' for more information"
} 