#!/usr/bin/env zsh

# Helper function to activate a Python virtual environment
function _oh_my_sdk_activate_venv() {
    local venv_name="$1"
    local venv_path="${OH_MY_SDK_PYENV}/${venv_name}"
    
    # Debug output
    _oh_my_sdk_print_status "info" "Looking for virtual environment at: ${venv_path}"
    
    if _oh_my_sdk_venv_exists "${venv_name}"; then
        source "${venv_path}/bin/activate"
        return 0
    fi
    _oh_my_sdk_print_status "error" "Virtual environment ${venv_name} not found at ${venv_path}"
    return 1
} 