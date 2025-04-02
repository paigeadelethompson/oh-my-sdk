#!/usr/bin/env zsh

# Helper function to create a Python virtual environment
function _oh_my_sdk_create_venv() {
    local venv_name="$1"
    local venv_path="${OH_MY_SDK_PYENV}/${venv_name}"
    
    if ! _oh_my_sdk_venv_exists "${venv_name}"; then
        python3 -m venv "${venv_path}"
    fi
} 