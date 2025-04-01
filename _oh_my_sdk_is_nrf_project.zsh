#!/usr/bin/env zsh

# Function to check if a directory is an NRF project
function _oh_my_sdk_is_nrf_project() {
    local dir="$1"
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    
    # Basic project structure check
    if [[ ! -f "${dir}/prj.conf" ]] || [[ ! -f "${dir}/CMakeLists.txt" ]]; then
        return 1
    fi
    
    # Check for board overlay files in project directory
    if [[ -d "${nrf_dir}/nrf/boards/nordic" ]]; then
        # Get list of valid board names from SDK
        local valid_boards=($(find "${nrf_dir}/nrf/boards/nordic" -maxdepth 1 -type d -exec basename {} \;))
        
        # Check if any overlay file matches a valid board name
        for board in "${valid_boards[@]}"; do
            if [[ -f "${dir}/${board}.overlay" ]]; then
                return 0
            fi
        done
    fi
    
    return 1
} 