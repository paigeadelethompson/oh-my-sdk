#!/usr/bin/env zsh

# Helper function to check if a command exists
function _oh_my_sdk_command_exists() {
    command -v "$1" >/dev/null 2>&1
} 