#!/usr/bin/env zsh

# oh-my-sdk plugin for managing SDK installations
# Author: Your Name
# License: MIT

# Base directory for SDK installations
export OH_MY_SDK_BASE="${HOME}/.oh-my-sdk"
export OH_MY_SDK_DIST="${OH_MY_SDK_BASE}/dist"
export OH_MY_SDK_PYENV="${OH_MY_SDK_BASE}/pyenv"

# Hook directories
export OH_MY_SDK_HOOKS="${OH_MY_SDK_BASE}/hooks"
export OH_MY_SDK_HOOKS_INSTALL="${OH_MY_SDK_HOOKS}/install"
export OH_MY_SDK_HOOKS_ACTIVATE="${OH_MY_SDK_HOOKS}/activate"
export OH_MY_SDK_HOOKS_DEACTIVATE="${OH_MY_SDK_HOOKS}/deactivate"

# Create necessary directories if they don't exist
[[ ! -d "${OH_MY_SDK_BASE}" ]] && mkdir -p "${OH_MY_SDK_BASE}"
[[ ! -d "${OH_MY_SDK_DIST}" ]] && mkdir -p "${OH_MY_SDK_DIST}"
[[ ! -d "${OH_MY_SDK_PYENV}" ]] && mkdir -p "${OH_MY_SDK_PYENV}"

# Create hook directories if they don't exist
[[ ! -d "${OH_MY_SDK_HOOKS}" ]] && mkdir -p "${OH_MY_SDK_HOOKS}"
[[ ! -d "${OH_MY_SDK_HOOKS_INSTALL}" ]] && mkdir -p "${OH_MY_SDK_HOOKS_INSTALL}"
[[ ! -d "${OH_MY_SDK_HOOKS_ACTIVATE}" ]] && mkdir -p "${OH_MY_SDK_HOOKS_ACTIVATE}"
[[ ! -d "${OH_MY_SDK_HOOKS_DEACTIVATE}" ]] && mkdir -p "${OH_MY_SDK_HOOKS_DEACTIVATE}"

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
    [[ -d "${OH_MY_SDK_DIST}/nrf" ]] && [[ -f "${OH_MY_SDK_DIST}/nrf/nrf-env.sh" ]]
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
    
    if [[ ! -d "${nrf_dir}" ]]; then
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
        pip install nrfutil==6.1.7  # Using latest stable version
        
        # Install essential nrfutil commands
        _oh_my_sdk_print_status "info" "Installing nrfutil device command..."
        nrfutil install device
        
        _oh_my_sdk_print_status "info" "Installing nrfutil nrf5sdk-tools..."
        nrfutil install nrf5sdk-tools
        
        _oh_my_sdk_print_status "info" "Installing nrfutil completion..."
        nrfutil install completion
        nrfutil completion install zsh
        
        # Download and install NRF Connect SDK
        _oh_my_sdk_print_status "info" "Downloading and installing NRF Connect SDK..."
        nrfutil install ncs
        
        deactivate
        _oh_my_sdk_print_status "success" "NRF Connect SDK installation complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'activate_nrf' to activate the environment"
        echo "  2. Run 'create_nrf_project <name>' to create a new project"
        echo "  3. Run 'nrf_help' for more information"
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
        _oh_my_sdk_print_status "error" "NRF Connect SDK is not installed. Please run 'install_nrf' first."
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
    echo "  • deactivate_sdk            Deactivate environment"
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
    [[ -f "${dir}/prj.conf" ]] && [[ -f "${dir}/CMakeLists.txt" ]] && \
    ([[ -f "${dir}/app.overlay" ]] || ls "${dir}"/*.overlay 1> /dev/null 2>&1)
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
            echo "NRF Connect SDK not installed. Run 'install_nrf' to install."
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
        echo "NRF Connect SDK not installed. Please run 'install_nrf' first."
        return 1
    fi
    
    local nrf_dir="${OH_MY_SDK_DIST}/nrf"
    cd "${nrf_dir}"
    _oh_my_sdk_activate_venv "nrf"
    west boards | grep -i "nrf" | sort
    deactivate
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
        echo "NRF Connect SDK not installed. Please run 'install_nrf' first."
        return 1
    fi
    
    local project_name="$1"
    if [[ -z "${project_name}" ]]; then
        echo "Usage: create_nrf_project <project_name>"
        return 1
    fi
    
    # List available boards and prompt for selection
    echo "Available NRF boards:"
    _oh_my_sdk_list_nrf_boards
    
    echo -n "Enter board name (e.g., nrf52840dk_nrf52840): "
    read board_name
    
    if [[ -z "${board_name}" ]]; then
        echo "Board name is required"
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
    
    # Create app.overlay for NRF-specific configurations
    cat > app.overlay << 'EOL'
&default_conn {
    status = "okay";
};
EOL
    
    echo "Created new NRF project: ${project_name}"
    echo "To build the project:"
    echo "1. cd ${project_name}"
    echo "2. west build -b ${board_name}"
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
    echo "  install_nrf                 Install NRF Connect SDK"
    echo "  create_nrf_project <name>   Create a new NRF project"
    echo "  _oh_my_sdk_list_nrf_boards List available NRF boards"
    echo
    echo "Environment:"
    echo "  activate_nrf                Activate NRF environment"
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
    echo "  nrf9160dk_nrf9160          nRF9160 Development Kit"
    echo
    echo "Configuration:"
    echo "  prj.conf                    Project configuration"
    echo "  CMakeLists.txt             Build configuration"
    echo "  app.overlay                NRF-specific device tree overlay"
    echo
    echo "Bluetooth:"
    echo "  CONFIG_BT=y                Enable Bluetooth"
    echo "  CONFIG_BT_PERIPHERAL=y     Configure as peripheral"
    echo "  CONFIG_BT_CENTRAL=y        Configure as central"
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

# Export functions
export -f activate_zephyr
export -f activate_nrf
export -f deactivate_sdk
export -f install_zephyr
export -f install_nrf

# Export new hook commands
export -f create_install_hook
export -f create_activate_hook
export -f create_deactivate_hook
export -f list_hooks

# Export new project creation commands
export -f create_zephyr_project
export -f create_nrf_project
export -f _oh_my_sdk_list_nrf_boards

# Export help commands
export -f zephyr_help
export -f nrf_help
export -f zap_oh_my_sdk 