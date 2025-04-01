#!/usr/bin/env zsh

# Function to create a new NRF project
function create_nrf_project() {
    if ! _oh_my_sdk_nrf_installed; then
        _oh_my_sdk_print_status "error" "NRF Connect SDK is not installed. Please run 'omsdk install nrf' first."
        return 1
    fi
    
    local project_name="$1"
    if [[ -z "${project_name}" ]]; then
        _oh_my_sdk_print_status "error" "Usage: omsdk create nrf <project_name>"
        return 1
    fi
    
    # Get list of available boards
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    if [[ ! -d "${nrf_dir}/nrf/boards/nordic" ]]; then
        _oh_my_sdk_print_status "error" "No board definitions found in SDK"
        return 1
    fi
    
    local valid_boards=($(find "${nrf_dir}/nrf/boards/nordic" -maxdepth 1 -type d -exec basename {} \;))
    
    # Show available boards
    _oh_my_sdk_print_status "info" "Available NRF boards:"
    echo
    for i in "${!valid_boards[@]}"; do
        echo "  $((i+1)). ${valid_boards[$i]}"
    done
    
    # Prompt for board selection
    echo
    echo -n "Select board number: "
    read board_num
    
    if ! [[ "${board_num}" =~ ^[0-9]+$ ]] || [[ "${board_num}" -lt 1 ]] || [[ "${board_num}" -gt "${#valid_boards[@]}" ]]; then
        _oh_my_sdk_print_status "error" "Invalid board selection"
        return 1
    fi
    
    local board_name="${valid_boards[$((board_num-1))]}"
    
    # Create project directory
    mkdir -p "${project_name}"
    cd "${project_name}"
    
    # Create basic project structure
    cat > CMakeLists.txt << 'EOL'
cmake_minimum_required(VERSION 3.20.0)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(${PROJECT_NAME})

target_sources(app PRIVATE src/main.c)
EOL
    
    mkdir -p src
    cat > src/main.c << 'EOL'
#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>

LOG_MODULE_REGISTER(main, CONFIG_LOG_DEFAULT_LEVEL);

int main(void)
{
    LOG_INF("Hello World! %s", CONFIG_BOARD);
    return 0;
}
EOL
    
    cat > prj.conf << 'EOL'
CONFIG_LOG=y
CONFIG_LOG_MODE_IMMEDIATE=y
CONFIG_BT=y
CONFIG_BT_PERIPHERAL=y
EOL
    
    # Create board-specific overlay file
    cat > "${board_name}.overlay" << 'EOL'
&default_conn {
    status = "okay";
};
EOL
    
    _oh_my_sdk_print_status "success" "Created new NRF project: ${project_name}"
    echo
    _oh_my_sdk_print_status "info" "To build the project:"
    echo "  1. cd ${project_name}"
    echo "  2. west build -b ${board_name}"
} 