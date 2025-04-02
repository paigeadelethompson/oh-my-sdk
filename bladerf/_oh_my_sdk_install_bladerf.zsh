#!/usr/bin/env zsh

# Function to install BladeRF SDK
function install_bladerf() {
    _oh_my_sdk_print_status "info" "Starting BladeRF SDK installation..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    _oh_my_sdk_install_bladerf_deps
    
    local bladerf_dir="${OH_MY_SDK_DIST}/bladerf"
    local bladerf_build="${bladerf_dir}/build"
    
    if [[ ! -d "${bladerf_dir}" ]] || [[ ! -d "${bladerf_build}" ]]; then
        _oh_my_sdk_print_status "info" "Creating BladeRF workspace..."
        mkdir -p "${bladerf_dir}"
        mkdir -p "${bladerf_build}"
        cd "${bladerf_dir}"

        # Clone bladeRF repository
        _oh_my_sdk_print_status "info" "Cloning BladeRF source..."
        git clone --recursive https://github.com/Nuand/bladeRF.git src
        
        # Build and install
        cd "${bladerf_build}"
        _oh_my_sdk_print_status "info" "Building BladeRF..."
        cmake ../src -DCMAKE_INSTALL_PREFIX="${bladerf_dir}" -DINSTALL_UDEV_RULES=OFF
        make -j$(nproc)
        make install
        
        # Create and activate virtual environment
        _oh_my_sdk_print_status "info" "Setting up Python environment..."
        cd "${bladerf_dir}"
        _oh_my_sdk_create_venv "bladerf"
        _oh_my_sdk_activate_venv "bladerf"
        
        # Install Python requirements
        pip install numpy scipy pyqt5
        
        deactivate
        _oh_my_sdk_print_status "success" "BladeRF SDK installation complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'omsdk activate bladerf' to activate the environment"
        echo "  2. Run 'bladeRF-cli -i' to start the interactive console"
        echo "  3. Run 'omsdk help bladerf' for more information"
    else
        _oh_my_sdk_print_status "warning" "BladeRF SDK is already installed."
    fi
} 