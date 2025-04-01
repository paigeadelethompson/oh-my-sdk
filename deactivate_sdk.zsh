#!/usr/bin/env zsh

# Function to deactivate current environment
function deactivate_sdk() {
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        deactivate
        echo "SDK environment deactivated"
    else
        echo "No SDK environment active"
    fi
} 