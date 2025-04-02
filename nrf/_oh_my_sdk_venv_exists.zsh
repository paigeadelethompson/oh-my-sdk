#!/usr/bin/env zsh

# Helper function to check if a Python virtual environment exists
function _oh_my_sdk_venv_exists() {
    local venv_name="$1"
    local venv_path="${OH_MY_SDK_PYENV}/${venv_name}"
    [[ -d "${venv_path}" ]] && [[ -f "${venv_path}/bin/activate" ]]
} 