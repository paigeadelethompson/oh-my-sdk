#!/usr/bin/env zsh

# Function to install Infineon AIROC/CYP SDKs
function install_infineon() {
    _oh_my_sdk_print_status "info" "Starting Infineon AIROC/CYP SDK installation..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    _oh_my_sdk_install_infineon_deps
    
    local infineon_dir="${OH_MY_SDK_DIST}/infineon"
    local modustoolbox_dir="${infineon_dir}/modustoolbox"
    
    if [[ ! -d "${infineon_dir}" ]] || [[ ! -d "${modustoolbox_dir}" ]]; then
        _oh_my_sdk_print_status "info" "Creating Infineon workspace..."
        mkdir -p "${infineon_dir}"
        mkdir -p "${modustoolbox_dir}"
        cd "${infineon_dir}"

        # Create and activate virtual environment
        _oh_my_sdk_print_status "info" "Setting up Python virtual environment..."
        _oh_my_sdk_create_venv "infineon"
        _oh_my_sdk_activate_venv "infineon"

        # Download and install ModusToolbox
        _oh_my_sdk_print_status "info" "Downloading ModusToolbox..."
        local mtb_url="https://itoolspriv.infineon.com/itbhs/download/dc0f6690625945f98176e1c67f5e66d4/content"
        local mtb_deb="${OH_MY_SDK_DIST}/modustoolbox.deb"
        
        # Download the .deb package
        curl -L "${mtb_url}" -o "${mtb_deb}"
        
        # Extract the .deb contents using alien
        _oh_my_sdk_print_status "info" "Extracting ModusToolbox..."
        cd "${OH_MY_SDK_DIST}"
        if ! alien --generate --scripts "${mtb_deb}"; then
            _oh_my_sdk_print_status "error" "Failed to extract package"
            rm "${mtb_deb}"
            return 1
        fi
        
        # Move opt/ModusToolbox contents to our directory
        if [[ -d "opt/ModusToolbox" ]]; then
            mv opt/ModusToolbox/* "${modustoolbox_dir}/"
            rm -rf opt
        else
            _oh_my_sdk_print_status "error" "ModusToolbox directory not found in package"
            rm "${mtb_deb}"
            return 1
        fi
        
        # Clean up package files
        rm "${mtb_deb}"
        rm -f modustoolbox-*.tar.gz
        
        # Install Python packages
        _oh_my_sdk_print_status "info" "Installing Python requirements..."
        pip install pyocd
        pip install --upgrade cysecuretools
        
        deactivate
        _oh_my_sdk_print_status "success" "Infineon AIROC/CYP SDK installation complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'omsdk activate infineon' to activate the environment"
        echo "  2. Run 'omsdk create infineon <name>' to create a new project"
        echo "  3. Run 'omsdk help infineon' for more information"
    else
        _oh_my_sdk_print_status "warning" "Infineon AIROC/CYP SDK is already installed."
    fi
} 