#!/usr/bin/env zsh

# Function to check if a directory is an NRF project
function _oh_my_sdk_is_nrf_project() {
    local dir="${1:-$PWD}"
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    
    # Basic project structure check
    if [[ ! -f "${dir}/prj.conf" ]]; then
        return 1
    fi
    
    if [[ ! -f "${dir}/CMakeLists.txt" ]]; then
        return 1
    fi
    
    # Check if this is a Zephyr project by looking for west.yml or west.yaml
    if [[ -f "${dir}/west.yml" ]]; then
        return 0
    fi
    
    if [[ -f "${dir}/west.yaml" ]]; then
        return 0
    fi
    
    # If we're under the nrf SDK directory, consider it an NRF project
    if [[ "${dir}" == "${nrf_dir}"* ]]; then
        return 0
    fi
    
    # Check if this is a known NRF sample project
    if [[ -f "${dir}/sample.yaml" ]]; then
        return 0
    fi
    
    return 1
} 