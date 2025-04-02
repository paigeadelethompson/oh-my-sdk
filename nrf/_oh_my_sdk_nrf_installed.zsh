#!/usr/bin/env zsh

# Function to check if NRF Connect SDK is installed
function _oh_my_sdk_nrf_installed() {
    [[ -d "${OH_MY_SDK_DIST}/nrf" ]] && [[ -d "${OH_MY_SDK_DIST}/nrf/nrf" ]] && [[ -d "${OH_MY_SDK_DIST}/nrf/bootloader" ]]
} 