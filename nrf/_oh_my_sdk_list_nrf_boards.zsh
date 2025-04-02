#!/usr/bin/env zsh

# Function to list available NRF boards
function _oh_my_sdk_list_nrf_boards() {
    if ! _oh_my_sdk_nrf_installed; then
        _oh_my_sdk_print_status "error" "NRF Connect SDK not installed. Please run 'omsdk install nrf' first."
        return 1
    fi
    
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    if [[ -d "${nrf_dir}/nrf/boards/nordic" ]]; then
        _oh_my_sdk_print_status "info" "Available NRF boards:"
        echo
        for board in "${nrf_dir}/nrf/boards/nordic"/*/; do
            if [[ -d "$board" ]]; then
                local board_name=$(basename "$board")
                echo "  • ${board_name}"
            fi
        done
    else
        _oh_my_sdk_print_status "error" "No board definitions found in SDK"
        return 1
    fi
} 