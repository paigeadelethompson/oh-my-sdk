#!/usr/bin/env zsh

# Function to install USRP SDK
function install_usrp() {
    _oh_my_sdk_print_status "info" "Starting USRP SDK installation..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    _oh_my_sdk_install_usrp_deps
    
    local usrp_dir="${OH_MY_SDK_DIST}/usrp"
    local uhd_dir="${usrp_dir}/uhd"
    local gnuradio_dir="${usrp_dir}/gnuradio"
    local build_dir="${usrp_dir}/build"
    
    if [[ ! -d "${usrp_dir}" ]] || [[ ! -d "${uhd_dir}" ]]; then
        _oh_my_sdk_print_status "info" "Creating USRP workspace..."
        mkdir -p "${usrp_dir}"
        mkdir -p "${build_dir}"
        cd "${usrp_dir}"

        # Create and activate virtual environment
        _oh_my_sdk_print_status "info" "Setting up Python virtual environment..."
        _oh_my_sdk_create_venv "usrp"
        _oh_my_sdk_activate_venv "usrp"

        # Clone UHD
        _oh_my_sdk_print_status "info" "Cloning UHD source..."
        git clone --recursive https://github.com/EttusResearch/uhd.git "${uhd_dir}"
        
        # Build and install UHD
        _oh_my_sdk_print_status "info" "Building UHD..."
        cd "${build_dir}"
        cmake -DCMAKE_INSTALL_PREFIX="${usrp_dir}" "${uhd_dir}/host"
        make -j$(nproc)
        make install
        
        # Download UHD FPGA images
        _oh_my_sdk_print_status "info" "Downloading UHD FPGA images..."
        "${usrp_dir}/lib/uhd/utils/uhd_images_downloader.py"
        
        # Clone GNU Radio
        _oh_my_sdk_print_status "info" "Cloning GNU Radio source..."
        cd "${usrp_dir}"
        git clone --recursive https://github.com/gnuradio/gnuradio.git "${gnuradio_dir}"
        
        # Build and install GNU Radio
        _oh_my_sdk_print_status "info" "Building GNU Radio..."
        cd "${build_dir}"
        cmake -DCMAKE_INSTALL_PREFIX="${usrp_dir}" \
              -DUHD_DIR="${usrp_dir}/lib/cmake/uhd" \
              "${gnuradio_dir}"
        make -j$(nproc)
        make install
        
        # Install Python packages
        _oh_my_sdk_print_status "info" "Installing Python requirements..."
        pip install numpy scipy matplotlib
        
        deactivate
        _oh_my_sdk_print_status "success" "USRP SDK installation complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'omsdk activate usrp' to activate the environment"
        echo "  2. Run 'uhd_find_devices' to detect USRP hardware"
        echo "  3. Run 'gnuradio-companion' to start GNU Radio"
        echo "  4. Run 'omsdk help usrp' for more information"
    else
        _oh_my_sdk_print_status "warning" "USRP SDK is already installed."
    fi
} 