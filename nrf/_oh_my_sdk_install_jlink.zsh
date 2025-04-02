#!/usr/bin/env zsh

# Function to extract and install JLink from the Nordic Command Line Tools
function _oh_my_sdk_install_jlink() {
    # Find and handle the JLink file
    local jlink_file=$(find "${OH_MY_SDK_DIST}" -name "JLink_Linux_*.tgz" -type f)
    if [[ -n "${jlink_file}" ]]; then
        # Extract JLink to our own directory
        _oh_my_sdk_print_status "info" "Extracting JLink..."
        tar xzf "${jlink_file}" -C "${OH_MY_SDK_DIST}"
        
        # Find the extracted JLink directory
        local jlink_dir=$(find "${OH_MY_SDK_DIST}" -maxdepth 1 -name "JLink_Linux_*" -type d)
        if [[ -n "${jlink_dir}" ]]; then
            _oh_my_sdk_print_status "info" "JLink extracted to: ${jlink_dir}"
            
            # Create symlink in /opt/SEGGER if it doesn't exist
            if [[ ! -d "/opt/SEGGER" ]]; then
                _oh_my_sdk_print_status "info" "Creating symlink in /opt/SEGGER..."
                sudo mkdir -p /opt/SEGGER
                local jlink_name=$(basename "${jlink_dir}")
                sudo ln -sf "${jlink_dir}" "/opt/SEGGER/${jlink_name}"
                sudo ln -sf "${jlink_dir}" "/opt/SEGGER/JLink"
                _oh_my_sdk_print_status "success" "Created symlinks: /opt/SEGGER/${jlink_name} -> ${jlink_dir}"
                _oh_my_sdk_print_status "success" "Created symlink: /opt/SEGGER/JLink -> ${jlink_dir}"
            else
                _oh_my_sdk_print_status "info" "Directory /opt/SEGGER already exists."
                local jlink_name=$(basename "${jlink_dir}")
                if [[ ! -L "/opt/SEGGER/${jlink_name}" ]]; then
                    _oh_my_sdk_print_status "info" "Creating symlinks in existing /opt/SEGGER directory..."
                    sudo ln -sf "${jlink_dir}" "/opt/SEGGER/${jlink_name}"
                    sudo ln -sf "${jlink_dir}" "/opt/SEGGER/JLink"
                    _oh_my_sdk_print_status "success" "Created symlinks: /opt/SEGGER/${jlink_name} -> ${jlink_dir}"
                    _oh_my_sdk_print_status "success" "Created symlink: /opt/SEGGER/JLink -> ${jlink_dir}"
                else
                    _oh_my_sdk_print_status "info" "Symlinks already exist in /opt/SEGGER."
                fi
            fi
        else
            _oh_my_sdk_print_status "error" "Failed to find extracted JLink directory"
        fi
        
        # Clean up JLink archive
        rm "${jlink_file}"
    else
        _oh_my_sdk_print_status "warning" "No JLink archive found in Nordic Command Line Tools"
    fi
} 