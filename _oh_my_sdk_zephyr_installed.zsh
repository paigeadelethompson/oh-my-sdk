#!/usr/bin/env zsh

# Function to check if Zephyr SDK is installed
function _oh_my_sdk_zephyr_installed() {
    [[ -d "${OH_MY_SDK_DIST}/zephyr" ]] && [[ -f "${OH_MY_SDK_DIST}/zephyr/zephyr-env.sh" ]]
} 