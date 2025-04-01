#!/usr/bin/env zsh

# Function to activate Zephyr environment
function activate_zephyr() {
    if ! _oh_my_sdk_zephyr_installed; then
        echo "Zephyr SDK is not installed. Please run 'install_zephyr' first."
        return 1
    fi
    
    local zephyr_dir="${OH_MY_SDK_DIST}/zephyr"
    cd "${zephyr_dir}"
    _oh_my_sdk_activate_venv "zephyr"
    west zephyr-export
    echo "Zephyr environment activated"
} 