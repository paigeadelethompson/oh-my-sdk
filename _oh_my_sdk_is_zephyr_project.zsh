#!/usr/bin/env zsh

# Function to check if a directory is a Zephyr project
function _oh_my_sdk_is_zephyr_project() {
    local dir="$1"
    [[ -f "${dir}/prj.conf" ]] && [[ -f "${dir}/CMakeLists.txt" ]]
} 