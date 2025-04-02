#!/usr/bin/env zsh

# Function to install NRF Connect SDK
function install_nrf() {
    _oh_my_sdk_print_status "info" "Starting NRF Connect SDK installation..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    
    # Install Zephyr SDK
    _oh_my_sdk_print_status "info" "Installing Zephyr SDK..."
    _oh_my_sdk_install_zephyr_sdk
    
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    
    if [[ ! -d "${nrf_dir}" ]] || [[ ! -d "${nrf_dir}/nrf" ]]; then
        _oh_my_sdk_print_status "info" "Creating NRF Connect workspace..."
        mkdir -p "${nrf_dir}"
        cd "${nrf_dir}"
        
        # Create and activate virtual environment
        _oh_my_sdk_print_status "info" "Setting up Python virtual environment..."
        _oh_my_sdk_create_venv "nrf"
        _oh_my_sdk_activate_venv "nrf"
        
        # Install nrfutil and its dependencies in the virtual environment
        _oh_my_sdk_print_status "info" "Installing nrfutil and its dependencies..."
        pip install --upgrade pip
        
        # Install requirements from NRF SDK
        _oh_my_sdk_print_status "info" "Installing NRF SDK requirements..."
        pip install -r "${nrf_dir}/nrf/scripts/requirements.txt"
        
        # Install requirements from Zephyr
        _oh_my_sdk_print_status "info" "Installing Zephyr requirements..."
        pip install -r "${nrf_dir}/zephyr/scripts/requirements.txt"
        
        # Old way of installing nrfutil and dependencies
        # pip install nrfutil==5.2.0  # Using a stable version
        
        # Install essential nrfutil commands
        # _oh_my_sdk_print_status "info" "Installing nrfutil tools..."
        # pip install nrfutil[device]
        # pip install nrfutil[dfu]
        # pip install nrfutil[dfu-serial]
        # pip install nrfutil[dfu-usb-serial]
        
        # Download and install NRF Connect SDK
        _oh_my_sdk_print_status "info" "Downloading and installing NRF Connect SDK..."
        west init -m https://github.com/nrfconnect/sdk-nrf --mr main .
        west update
        
        # Export Zephyr CMake package
        _oh_my_sdk_print_status "info" "Exporting Zephyr CMake package..."
        if ! west zephyr-export; then
            _oh_my_sdk_print_status "error" "Failed to export Zephyr CMake package"
            return 1
        fi
        
        # Install Nordic Command Line Tools
        _oh_my_sdk_print_status "info" "Installing Nordic Command Line Tools..."
        local nrf_cli_url="https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/10-24-2/nrf-command-line-tools-10.24.2_linux-amd64.tar.gz"
        local nrf_cli_tar="${OH_MY_SDK_DIST}/nrf-command-line-tools.tar.gz"
        
        wget -q "${nrf_cli_url}" -O "${nrf_cli_tar}"
        tar -xzf "${nrf_cli_tar}" -C "${OH_MY_SDK_DIST}"
        rm "${nrf_cli_tar}"
        [[ -f "${OH_MY_SDK_DIST}/README.txt" ]] && rm "${OH_MY_SDK_DIST}/README.txt"

        # Use the separate JLink installation function
        _oh_my_sdk_install_jlink
        
        deactivate
        _oh_my_sdk_print_status "success" "NRF Connect SDK installation complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'omsdk activate nrf' to activate the environment"
        echo "  2. Run 'omsdk create nrf <name>' to create a new project"
        echo "  3. Run 'omsdk help nrf' for more information"
    else
        _oh_my_sdk_print_status "warning" "NRF Connect SDK is already installed."
    fi
} 