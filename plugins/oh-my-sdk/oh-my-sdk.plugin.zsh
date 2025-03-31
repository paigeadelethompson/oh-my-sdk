#!/usr/bin/env zsh

# oh-my-sdk plugin for managing SDK installations
# Author: Your Name
# License: MIT

# Base directory for SDK installations
export OH_MY_SDK_BASE="${HOME}/.oh-my-sdk"
export OH_MY_SDK_DIST="${OH_MY_SDK_BASE}/dist"
export OH_MY_SDK_PYENV="${OH_MY_SDK_BASE}/pyenv"
export OH_MY_SDK_LOCAL="${HOME}/.local"

# Hook directories
export OH_MY_SDK_HOOKS="${OH_MY_SDK_BASE}/hooks"
export OH_MY_SDK_HOOKS_INSTALL="${OH_MY_SDK_HOOKS}/install"
export OH_MY_SDK_HOOKS_ACTIVATE="${OH_MY_SDK_HOOKS}/activate"
export OH_MY_SDK_HOOKS_DEACTIVATE="${OH_MY_SDK_HOOKS}/deactivate"

# Create necessary directories if they don't exist
[[ ! -d "${OH_MY_SDK_BASE}" ]] && mkdir -p "${OH_MY_SDK_BASE}"
[[ ! -d "${OH_MY_SDK_DIST}" ]] && mkdir -p "${OH_MY_SDK_DIST}"
[[ ! -d "${OH_MY_SDK_PYENV}" ]] && mkdir -p "${OH_MY_SDK_PYENV}"
[[ ! -d "${OH_MY_SDK_LOCAL}" ]] && mkdir -p "${OH_MY_SDK_LOCAL}"

# Create hook directories if they don't exist
[[ ! -d "${OH_MY_SDK_HOOKS}" ]] && mkdir -p "${OH_MY_SDK_HOOKS}"
[[ ! -d "${OH_MY_SDK_HOOKS_INSTALL}" ]] && mkdir -p "${OH_MY_SDK_HOOKS_INSTALL}"
[[ ! -d "${OH_MY_SDK_HOOKS_ACTIVATE}" ]] && mkdir -p "${OH_MY_SDK_HOOKS_ACTIVATE}"
[[ ! -d "${OH_MY_SDK_HOOKS_DEACTIVATE}" ]] && mkdir -p "${OH_MY_SDK_HOOKS_DEACTIVATE}"

# Helper function to print status messages
function _oh_my_sdk_print_status() {
    local type="$1"
    local message="$2"
    
    case "${type}" in
        "info")
            echo "ℹ️  ${message}"
            ;;
        "success")
            echo "✅ ${message}"
            ;;
        "warning")
            echo "⚠️  ${message}"
            ;;
        "error")
            echo "❌ ${message}"
            ;;
        *)
            echo "${message}"
            ;;
    esac
}

# Helper function to check if a command exists
function _oh_my_sdk_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Helper function to check if a Python virtual environment exists
function _oh_my_sdk_venv_exists() {
    [[ -d "${OH_MY_SDK_PYENV}/$1" ]]
}

# Helper function to create a Python virtual environment
function _oh_my_sdk_create_venv() {
    local venv_name="$1"
    local venv_path="${OH_MY_SDK_PYENV}/${venv_name}"
    
    if ! _oh_my_sdk_venv_exists "${venv_name}"; then
        python3 -m venv "${venv_path}"
    fi
}

# Helper function to activate a Python virtual environment
function _oh_my_sdk_activate_venv() {
    local venv_name="$1"
    local venv_path="${OH_MY_SDK_PYENV}/${venv_name}"
    
    if _oh_my_sdk_venv_exists "${venv_name}"; then
        source "${venv_path}/bin/activate"
        return 0
    fi
    return 1
}

# Function to check and install system dependencies
function _oh_my_sdk_install_system_deps() {
    local deps=(
        "git"
        "cmake"
        "ninja-build"
        "gperf"
        "ccache"
        "dfu-util"
        "device-tree-compiler"
        "wget"
        "python3"
        "python3-pip"
        "python3-venv"
        "make"
        "gcc"
        "gcc-multilib"
        "g++-multilib"
        "libsdl2-dev"
        "libmagic1"
    )
    
    for dep in "${deps[@]}"; do
        if ! _oh_my_sdk_command_exists "$dep"; then
            echo "Installing $dep..."
            sudo apt-get install -y "$dep"
        fi
    done
}

# Function to check if Zephyr SDK is installed
function _oh_my_sdk_zephyr_installed() {
    [[ -d "${OH_MY_SDK_DIST}/zephyr" ]] && [[ -f "${OH_MY_SDK_DIST}/zephyr/zephyr-env.sh" ]]
}

# Function to check if NRF Connect SDK is installed
function _oh_my_sdk_nrf_installed() {
    [[ -d "${OH_MY_SDK_DIST}/nrf" ]] && [[ -d "${OH_MY_SDK_DIST}/nrf/nrf" ]]
}

# Function to install Zephyr SDK
function install_zephyr() {
    echo "Installing Zephyr SDK..."
    
    # Install system dependencies first
    _oh_my_sdk_install_system_deps
    
    local zephyr_dir="${OH_MY_SDK_DIST}/zephyr"
    
    if [[ ! -d "${zephyr_dir}" ]]; then
        mkdir -p "${zephyr_dir}"
        cd "${zephyr_dir}"
        
        # Create and activate virtual environment
        _oh_my_sdk_create_venv "zephyr"
        _oh_my_sdk_activate_venv "zephyr"
        
        # Install west
        pip install west
        
        # Initialize west workspace
        west init .
        west update
        
        # Export Zephyr CMake package
        west zephyr-export
        
        # Install Python dependencies
        west packages pip --install
        
        # Install Zephyr SDK
        west sdk install
        
        deactivate
        echo "Zephyr SDK installation complete!"
    else
        echo "Zephyr SDK is already installed."
    fi
}

# Function to install NRF Connect SDK
function install_nrf() {
    _oh_my_sdk_print_status "info" "Starting NRF Connect SDK installation..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    
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
        pip install nrfutil==5.2.0  # Using a stable version
        
        # Install essential nrfutil commands
        _oh_my_sdk_print_status "info" "Installing nrfutil tools..."
        pip install nrfutil[device]
        pip install nrfutil[dfu]
        pip install nrfutil[dfu-serial]
        pip install nrfutil[dfu-usb-serial]
        
        # Download and install NRF Connect SDK
        _oh_my_sdk_print_status "info" "Downloading and installing NRF Connect SDK..."
        west init -m https://github.com/nrfconnect/sdk-nrf --mr main .
        west update
        
        # Export Zephyr CMake package
        west zephyr-export
        
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

# Function to activate NRF Connect environment
function activate_nrf() {
    if ! _oh_my_sdk_nrf_installed; then
        _oh_my_sdk_print_status "error" "NRF Connect SDK is not installed. Please run 'omsdk install nrf' first."
        return 1
    fi
    
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    cd "${nrf_dir}"
    
    # Activate Python virtual environment
    _oh_my_sdk_print_status "info" "Activating Python virtual environment..."
    _oh_my_sdk_activate_venv "nrf"
    
    # Set up NRF environment variables
    _oh_my_sdk_print_status "info" "Setting up NRF Connect environment variables..."
    export NRF_CLI_DIR="${OH_MY_SDK_BASE}/nordic-cli/nrf-command-line-tools"
    export JLINK_DIR="${OH_MY_SDK_BASE}/nordic-cli/JLink_Linux_V794e_x86_64"
    export PATH="${NRF_CLI_DIR}/bin:${JLINK_DIR}:${PATH}"
    export BUILD_DIR="build"
    
    # Export Zephyr CMake package (NRF uses Zephyr)
    _oh_my_sdk_print_status "info" "Exporting Zephyr CMake package..."
    west zephyr-export
    
    # Add nrfutil to PATH
    export PATH="${VIRTUAL_ENV}/bin:${PATH}"
    
    _oh_my_sdk_print_status "success" "NRF Connect environment activated!"
    echo
    _oh_my_sdk_print_status "info" "Available commands:"
    echo "  • west build -b <board>     Build project for specific board"
    echo "  • west flash                Flash project to board"
    echo "  • west debug                Start debug session"
    echo "  • nrfutil device list       List connected devices"
    echo "  • nrfutil device recover    Recover a device"
    echo "  • nrfutil device erase      Erase device memory"
    echo "  • nrfutil dfu genpkg        Generate DFU package"
    echo "  • nrfutil dfu serial        Perform DFU over serial"
    echo "  • nrfutil dfu usb-serial    Perform DFU over USB"
    echo "  • omsdk deactivate          Deactivate environment"
}

# Function to deactivate current environment
function deactivate_sdk() {
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        deactivate
        echo "SDK environment deactivated"
    else
        echo "No SDK environment active"
    fi
}

# Function to check if a directory is a Zephyr project
function _oh_my_sdk_is_zephyr_project() {
    local dir="$1"
    [[ -f "${dir}/prj.conf" ]] && [[ -f "${dir}/CMakeLists.txt" ]]
}

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

# Auto-detect and activate environment based on current directory
function _oh_my_sdk_auto_activate() {
    local current_dir="$PWD"
    
    if _oh_my_sdk_is_zephyr_project "${current_dir}"; then
        if _oh_my_sdk_zephyr_installed; then
            activate_zephyr
        else
            echo "Zephyr SDK not installed. Run 'install_zephyr' to install."
        fi
    elif _oh_my_sdk_is_nrf_project "${current_dir}"; then
        if _oh_my_sdk_nrf_installed; then
            activate_nrf
        else
            echo "NRF Connect SDK not installed. Run 'omsdk install nrf' to install."
        fi
    fi
}

# Add auto-activation to chpwd hook
autoload -U add-zsh-hook
add-zsh-hook chpwd _oh_my_sdk_auto_activate

# Function to create a hook script
function _oh_my_sdk_create_hook() {
    local hook_dir="$1"
    local hook_name="$2"
    local hook_path="${hook_dir}/${hook_name}"
    
    if [[ -f "${hook_path}" ]]; then
        echo "Hook ${hook_name} already exists"
        return 1
    fi
    
    cat > "${hook_path}" << 'EOL'
#!/usr/bin/env zsh

# Hook script for oh-my-sdk
# This script will be executed when the corresponding event occurs
# Arguments:
#   $1: SDK name (zephyr or nrf)

SDK_NAME="$1"

case "${SDK_NAME}" in
    "zephyr")
        # Add your Zephyr-specific hook commands here
        echo "Executing Zephyr hook"
        ;;
    "nrf")
        # Add your NRF-specific hook commands here
        echo "Executing NRF hook"
        ;;
    *)
        echo "Unknown SDK: ${SDK_NAME}"
        exit 1
        ;;
esac
EOL
    
    chmod +x "${hook_path}"
    echo "Created hook: ${hook_path}"
}

# Command to create an installation hook
function create_install_hook() {
    local hook_name="$1"
    if [[ -z "${hook_name}" ]]; then
        echo "Usage: create_install_hook <hook_name>"
        return 1
    fi
    _oh_my_sdk_create_hook "${OH_MY_SDK_HOOKS_INSTALL}" "${hook_name}"
}

# Command to create an activation hook
function create_activate_hook() {
    local hook_name="$1"
    if [[ -z "${hook_name}" ]]; then
        echo "Usage: create_activate_hook <hook_name>"
        return 1
    fi
    _oh_my_sdk_create_hook "${OH_MY_SDK_HOOKS_ACTIVATE}" "${hook_name}"
}

# Command to create a deactivation hook
function create_deactivate_hook() {
    local hook_name="$1"
    if [[ -z "${hook_name}" ]]; then
        echo "Usage: create_deactivate_hook <hook_name>"
        return 1
    fi
    _oh_my_sdk_create_hook "${OH_MY_SDK_HOOKS_DEACTIVATE}" "${hook_name}"
}

# Command to list all hooks
function list_hooks() {
    echo "Installation hooks:"
    ls -l "${OH_MY_SDK_HOOKS_INSTALL}" 2>/dev/null || echo "No installation hooks"
    
    echo -e "\nActivation hooks:"
    ls -l "${OH_MY_SDK_HOOKS_ACTIVATE}" 2>/dev/null || echo "No activation hooks"
    
    echo -e "\nDeactivation hooks:"
    ls -l "${OH_MY_SDK_HOOKS_DEACTIVATE}" 2>/dev/null || echo "No deactivation hooks"
}

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

# Function to create a new Zephyr project
function create_zephyr_project() {
    if ! _oh_my_sdk_zephyr_installed; then
        echo "Zephyr SDK not installed. Please run 'install_zephyr' first."
        return 1
    fi
    
    local project_name="$1"
    if [[ -z "${project_name}" ]]; then
        echo "Usage: create_zephyr_project <project_name>"
        return 1
    fi
    
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
EOL
    
    echo "Created new Zephyr project: ${project_name}"
    echo "To build the project:"
    echo "1. cd ${project_name}"
    echo "2. west build -b <board>"
}

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
    
    # List available boards and prompt for selection
    _oh_my_sdk_print_status "info" "Available NRF boards:"
    _oh_my_sdk_list_nrf_boards
    
    echo -n "Enter board name: "
    read board_name
    
    if [[ -z "${board_name}" ]]; then
        _oh_my_sdk_print_status "error" "Board name is required"
        return 1
    fi
    
    # Verify board exists in SDK
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    if [[ ! -d "${nrf_dir}/nrf/boards/nordic/${board_name}" ]]; then
        _oh_my_sdk_print_status "error" "Invalid board name: ${board_name}"
        return 1
    fi
    
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

# Function to show Zephyr help
function zephyr_help() {
    echo "Zephyr SDK Help"
    echo "==============="
    echo
    echo "Installation:"
    echo "  install_zephyr              Install Zephyr SDK"
    echo "  create_zephyr_project <name> Create a new Zephyr project"
    echo
    echo "Environment:"
    echo "  activate_zephyr             Activate Zephyr environment"
    echo "  deactivate_sdk              Deactivate current environment"
    echo
    echo "Project Management:"
    echo "  west build -b <board>       Build project for specific board"
    echo "  west flash                  Flash project to board"
    echo "  west debug                  Start debug session"
    echo
    echo "Common Boards:"
    echo "  nrf52840dk_nrf52840        nRF52840 Development Kit"
    echo "  nrf52dk_nrf52832           nRF52 Development Kit"
    echo "  nrf5340dk_nrf5340_cpuapp   nRF5340 Development Kit"
    echo
    echo "Configuration:"
    echo "  prj.conf                    Project configuration"
    echo "  CMakeLists.txt             Build configuration"
    echo "  boards/                    Board-specific overlays"
    echo
    echo "Documentation:"
    echo "  https://docs.zephyrproject.org/"
}

# Function to show NRF Connect help
function nrf_help() {
    echo "NRF Connect SDK Help"
    echo "==================="
    echo
    echo "Installation:"
    echo "  omsdk install nrf              Install NRF Connect SDK"
    echo "  omsdk create nrf <name>        Create a new NRF project"
    echo "  omsdk list nrf boards         List available NRF boards"
    echo
    echo "Environment:"
    echo "  omsdk activate nrf             Activate NRF environment"
    echo "  omsdk deactivate              Deactivate current environment"
    echo
    echo "Project Management:"
    echo "  west build -b <board>         Build project for specific board"
    echo "  west flash                    Flash project to board"
    echo "  west debug                    Start debug session"
    echo
    echo "Common Boards:"
    echo "  nrf52840dk_nrf52840          nRF52840 Development Kit"
    echo "  nrf52dk_nrf52832             nRF52 Development Kit"
    echo "  nrf5340dk_nrf5340_cpuapp     nRF5340 Development Kit"
    echo "  nrf9160dk_nrf9160            nRF9160 Development Kit"
    echo
    echo "Configuration:"
    echo "  prj.conf                      Project configuration"
    echo "  CMakeLists.txt               Build configuration"
    echo "  app.overlay                  NRF-specific device tree overlay"
    echo
    echo "Bluetooth:"
    echo "  CONFIG_BT=y                  Enable Bluetooth"
    echo "  CONFIG_BT_PERIPHERAL=y       Configure as peripheral"
    echo "  CONFIG_BT_CENTRAL=y          Configure as central"
    echo
    echo "Documentation:"
    echo "  https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/"
}

# Function to completely remove oh-my-sdk
function zap_oh_my_sdk() {
    if [[ -d "${OH_MY_SDK_ROOT}" ]]; then
        echo "Removing oh-my-sdk directory and all contents..."
        rm -rf "${OH_MY_SDK_ROOT}"
        echo "oh-my-sdk has been completely removed."
        echo "Please restart your shell to apply changes."
    else
        echo "oh-my-sdk directory not found."
    fi
}

# Main omsdk command function
function omsdk() {
    case "$1" in
        "help")
            case "$2" in
                "nrf")
                    nrf_help
                    ;;
                *)
                    echo "oh-my-sdk - SDK Management Tool"
                    echo
                    echo "Available commands:"
                    echo "  omsdk help                    - Show this help message"
                    echo "  omsdk help nrf               - Show NRF Connect SDK help"
                    echo "  omsdk install nrf            - Install NRF Connect SDK"
                    echo "  omsdk activate nrf           - Activate NRF environment"
                    echo "  omsdk deactivate             - Deactivate current environment"
                    echo "  omsdk create nrf <name>      - Create a new NRF project"
                    echo "  omsdk list nrf boards        - List available NRF boards"
                    echo "  omsdk status                 - Show current environment status"
                    echo "  omsdk list                   - List installed SDKs"
                    echo "  omsdk zap                    - Remove all SDK installations"
                    ;;
            esac
            ;;
        "install")
            case "$2" in
                "nrf")
                    install_nrf
                    ;;
                *)
                    echo "Usage: omsdk install [nrf]"
                    return 1
                    ;;
            esac
            ;;
        "activate")
            case "$2" in
                "nrf")
                    activate_nrf
                    ;;
                *)
                    echo "Usage: omsdk activate [nrf]"
                    return 1
                    ;;
            esac
            ;;
        "create")
            case "$2" in
                "nrf")
                    create_nrf_project "$3"
                    ;;
                *)
                    echo "Usage: omsdk create [nrf] <project_name>"
                    return 1
                    ;;
            esac
            ;;
        "list")
            case "$2" in
                "nrf")
                    case "$3" in
                        "boards")
                            _oh_my_sdk_list_nrf_boards
                            ;;
                        *)
                            echo "Usage: omsdk list nrf [boards]"
                            return 1
                            ;;
                    esac
                    ;;
                *)
                    echo "Usage: omsdk list [nrf]"
                    return 1
                    ;;
            esac
            ;;
        "deactivate")
            deactivate_sdk
            ;;
        *)
            echo "Usage: omsdk [help|install|activate|create|list|deactivate|status|zap]"
            return 1
            ;;
    esac
}

# Export the main command
export -f omsdk 