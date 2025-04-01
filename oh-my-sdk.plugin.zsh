#!/usr/bin/env zsh

# oh-my-sdk plugin for managing SDK installations
# Author: Your Name
# License: MIT

# Base directory for SDK installations
typeset -g OH_MY_SDK_BASE="${HOME}/.oh-my-sdk"
typeset -g OH_MY_SDK_DIST="${HOME}/.oh-my-sdk/dist"
typeset -g OH_MY_SDK_PYENV="${OH_MY_SDK_BASE}/pyenv"
typeset -g OH_MY_SDK_LOCAL="${HOME}/.local"

# Initialize plugin
function _oh_my_sdk_init() {
    # Create necessary directories if they don't exist
    [[ ! -d "${OH_MY_SDK_BASE}" ]] && mkdir -p "${OH_MY_SDK_BASE}"
    [[ ! -d "${OH_MY_SDK_DIST}" ]] && mkdir -p "${OH_MY_SDK_DIST}"
    [[ ! -d "${OH_MY_SDK_PYENV}" ]] && mkdir -p "${OH_MY_SDK_PYENV}"
    [[ ! -d "${OH_MY_SDK_LOCAL}" ]] && mkdir -p "${OH_MY_SDK_LOCAL}"
}

# Initialize plugin when sourced
_oh_my_sdk_init

# Source all individual function files
SCRIPT_DIR="${0:A:h}"
for funcfile in "${SCRIPT_DIR}"/_oh_my_sdk_*.zsh "${SCRIPT_DIR}"/install_*.zsh "${SCRIPT_DIR}"/activate_*.zsh "${SCRIPT_DIR}"/deactivate_*.zsh "${SCRIPT_DIR}"/create_*.zsh "${SCRIPT_DIR}"/show_status.zsh "${SCRIPT_DIR}"/*_help.zsh; do
    if [[ -f "${funcfile}" ]]; then
        source "${funcfile}"
    fi
done

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
omsdk() {
    case "$1" in
        ("help") case "$2" in
                ("nrf") nrf_help ;;
                (*) echo "oh-my-sdk - SDK Management Tool"
                        echo
                        echo "Available commands:"
                        echo "  omsdk help                    - Show this help message"
                        echo "  omsdk help nrf               - Show NRF Connect SDK help"
                        echo "  omsdk install nrf            - Install NRF Connect SDK"
                        echo "  omsdk activate nrf           - Activate NRF environment"
                        echo "  omsdk deactivate             - Deactivate current environment"
                        echo "  omsdk create nrf <name>      - Create a new NRF project"
                        echo "  omsdk status                 - Show current environment status"
                        echo "  omsdk zap                    - Remove all SDK installations" ;;
                esac ;;
        ("install") case "$2" in
                ("nrf") install_nrf ;;
                (*) echo "Usage: omsdk install [nrf]"
                        return 1 ;;
                esac ;;
        ("activate") case "$2" in
                ("nrf") activate_nrf ;;
                (*) echo "Usage: omsdk activate [nrf]"
                        return 1 ;;
                esac ;;
        ("create") case "$2" in
                ("nrf") create_nrf_project "$3" ;;
                (*) echo "Usage: omsdk create [nrf] <project_name>"
                        return 1 ;;
                esac ;;
        ("status") show_status ;;
        ("deactivate") deactivate_sdk ;;
        ("zap") zap_oh_my_sdk ;;
        (*) echo "Usage: omsdk [help|install|activate|create|status|deactivate|zap]"
                return 1 ;;
    esac
} 