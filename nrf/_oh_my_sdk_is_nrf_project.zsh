#!/usr/bin/env zsh

# Function to check if a directory is an NRF project
function _oh_my_sdk_is_nrf_project() {
    local dir="${1:-$PWD}"
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    
    # Debug output
    echo "Checking directory: $dir"
    echo "NRF SDK directory: $nrf_dir"
    
    # Debug file existence
    echo "Checking for prj.conf: ${dir}/prj.conf"
    echo "Checking for CMakeLists.txt: ${dir}/CMakeLists.txt"
    echo "Checking for west.yml/yaml"
    
    # Basic project structure check
    if [[ ! -f "${dir}/prj.conf" ]]; then
        echo "Missing prj.conf"
        return 1
    fi
    
    if [[ ! -f "${dir}/CMakeLists.txt" ]]; then
        echo "Missing CMakeLists.txt"
        return 1
    fi
    
    # Check if this is a Zephyr project by looking for west.yml or west.yaml
    if [[ -f "${dir}/west.yml" ]]; then
        echo "Found west.yml"
        return 0
    fi
    
    if [[ -f "${dir}/west.yaml" ]]; then
        echo "Found west.yaml"
        return 0
    fi
    
    # If we're under the nrf SDK directory, consider it an NRF project
    if [[ "${dir}" == "${nrf_dir}"* ]]; then
        echo "Under NRF SDK directory"
        return 0
    fi
    
    # Check if this is a known NRF sample project
    if [[ -f "${dir}/sample.yaml" ]]; then
        echo "Found sample.yaml - likely an NRF sample project"
        return 0
    fi
    
    echo "Not an NRF project"
    return 1
} 