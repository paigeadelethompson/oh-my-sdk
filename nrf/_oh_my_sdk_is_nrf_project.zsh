#!/usr/bin/env zsh

# Function to check if a directory is an NRF project
function _oh_my_sdk_is_nrf_project() {
    local dir="${1:-$PWD}"
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    
    # Debug output
    echo "Checking directory: $dir"
    echo "NRF SDK directory: $nrf_dir"
    
    # Basic project structure check
    if [[ ! -f "${dir}/prj.conf" ]]; then
        echo "No prj.conf found"
        return 1
    fi
    
    if [[ ! -f "${dir}/CMakeLists.txt" ]]; then
        echo "No CMakeLists.txt found"
        return 1
    fi
    
    # If we have both prj.conf and CMakeLists.txt, and we're under the nrf SDK directory,
    # consider it an NRF project
    if [[ "${dir}" == "${nrf_dir}"* ]]; then
        echo "Valid NRF project found"
        return 0
    fi
    
    echo "Not under NRF SDK directory"
    return 1
} 