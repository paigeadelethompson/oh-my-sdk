#!/usr/bin/env zsh

# Function to activate FreeBSD cross-compilation environment
function activate_freebsd_cross() {
    # Skip if already activated
    if [[ -n "${OMSDK_FREEBSD_CROSS_ACTIVATED}" ]]; then
        _oh_my_sdk_print_status "warning" "FreeBSD cross-compilation environment is already activated."
        return 0
    fi
    
    _oh_my_sdk_print_debug "OH_MY_SDK_DIST=${OH_MY_SDK_DIST}"
    
    local freebsd_dir="${OH_MY_SDK_DIST}/freebsd"
    local src_dir="${freebsd_dir}/src"
    local tools_dir="${freebsd_dir}/tools"
    
    # Check if FreeBSD directory exists
    if [[ ! -d "${freebsd_dir}" ]]; then
        _oh_my_sdk_print_status "error" "FreeBSD directory not found at ${freebsd_dir}"
        _oh_my_sdk_print_status "info" "Please run 'omsdk install freebsd-cross' first"
        return 1
    fi
    
    # Check if source is cloned
    if [[ ! -d "${src_dir}" ]]; then
        _oh_my_sdk_print_status "error" "FreeBSD source not found at ${src_dir}"
        _oh_my_sdk_print_status "info" "Please run 'omsdk install freebsd-cross' first"
        return 1
    fi
    
    # Change to FreeBSD directory
    cd "${freebsd_dir}"
    
    # Activate Python virtual environment
    _oh_my_sdk_activate_venv "freebsd"
    
    # Update PATH to include FreeBSD tools
    export PATH="${tools_dir}:${PATH}"
    
    # Set FreeBSD specific environment variables
    export FREEBSD_DIR="${freebsd_dir}"
    export FREEBSD_SRC="${src_dir}"
    export FREEBSD_TOOLS="${tools_dir}"
    export SRCCONF="${tools_dir}/cross-make.conf"
    export MAKEOBJDIRPREFIX="${freebsd_dir}/obj"
    
    # Mark as activated
    export OMSDK_FREEBSD_CROSS_ACTIVATED=1
    
    _oh_my_sdk_print_status "success" "FreeBSD cross-compilation environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  build-kernel.sh \$FREEBSD_DIR    - Build FreeBSD kernel"
    echo "  build-world.sh \$FREEBSD_DIR     - Build FreeBSD world"
    echo
    _oh_my_sdk_print_status "info" "Environment variables set:"
    echo "  FREEBSD_DIR         - FreeBSD workspace directory"
    echo "  FREEBSD_SRC         - FreeBSD source directory"
    echo "  FREEBSD_TOOLS       - FreeBSD tools directory"
    echo "  SRCCONF            - Path to cross-compilation configuration"
    echo "  MAKEOBJDIRPREFIX   - Path to object files directory"
    echo
    _oh_my_sdk_print_status "info" "Type 'omsdk help freebsd-cross' for more information"
} 