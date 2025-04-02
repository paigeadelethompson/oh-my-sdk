#!/usr/bin/env zsh

# Function to show current environment status
function show_status() {
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        local venv_name=$(basename "${VIRTUAL_ENV}")
        _oh_my_sdk_print_status "info" "Current environment: ${venv_name}"
        
        # Show NRF-specific status
        if [[ "${venv_name}" == "nrf" ]]; then
            local nrf_dir="${OH_MY_SDK_DIST}/nrf"
            local nrf_cli_dir="${OH_MY_SDK_DIST}/nrf-command-line-tools"
            
            # Check NRF Connect SDK
            if [[ -d "${nrf_dir}" ]]; then
                _oh_my_sdk_print_status "info" "NRF Connect SDK location: ${nrf_dir}"
                _oh_my_sdk_print_status "info" "Current directory: ${PWD}"
                
                # Check critical SDK components
                echo
                _oh_my_sdk_print_status "info" "Checking SDK components..."
                [[ -d "${nrf_dir}/nrf" ]] && _oh_my_sdk_print_status "success" "✓ nrf directory present" || _oh_my_sdk_print_status "error" "✗ nrf directory missing"
                [[ -d "${nrf_dir}/bootloader" ]] && _oh_my_sdk_print_status "success" "✓ bootloader directory present" || _oh_my_sdk_print_status "error" "✗ bootloader directory missing"
                [[ -d "${nrf_dir}/nrf/boards/nordic" ]] && _oh_my_sdk_print_status "success" "✓ board definitions present" || _oh_my_sdk_print_status "error" "✗ board definitions missing"
                
                # Check Nordic Command Line Tools
                echo
                _oh_my_sdk_print_status "info" "Checking Nordic Command Line Tools..."
                [[ -d "${nrf_cli_dir}" ]] && _oh_my_sdk_print_status "success" "✓ Command Line Tools directory present" || _oh_my_sdk_print_status "error" "✗ Command Line Tools directory missing"
                
                # Check bin directory
                echo
                _oh_my_sdk_print_status "info" "Checking binary tools..."
                [[ -f "${nrf_cli_dir}/bin/nrfjprog" ]] && _oh_my_sdk_print_status "success" "✓ nrfjprog installed" || _oh_my_sdk_print_status "error" "✗ nrfjprog missing"
                [[ -f "${nrf_cli_dir}/bin/mergehex" ]] && _oh_my_sdk_print_status "success" "✓ mergehex installed" || _oh_my_sdk_print_status "error" "✗ mergehex missing"
                [[ -f "${nrf_cli_dir}/bin/jlinkarm_nrf_worker_linux" ]] && _oh_my_sdk_print_status "success" "✓ jlinkarm worker installed" || _oh_my_sdk_print_status "error" "✗ jlinkarm worker missing"
                
                # Check lib directory
                echo
                _oh_my_sdk_print_status "info" "Checking libraries..."
                [[ -f "${nrf_cli_dir}/lib/libnrfjprogdll.so" ]] && _oh_my_sdk_print_status "success" "✓ nrfjprog library installed" || _oh_my_sdk_print_status "error" "✗ nrfjprog library missing"
                [[ -f "${nrf_cli_dir}/lib/libhighlevelnrfjprog.so" ]] && _oh_my_sdk_print_status "success" "✓ highlevel nrfjprog library installed" || _oh_my_sdk_print_status "error" "✗ highlevel nrfjprog library missing"
                [[ -f "${nrf_cli_dir}/lib/libnrfdfu.so" ]] && _oh_my_sdk_print_status "success" "✓ DFU library installed" || _oh_my_sdk_print_status "error" "✗ DFU library missing"
                
                # Check Python components
                echo
                _oh_my_sdk_print_status "info" "Checking Python components..."
                [[ -d "${nrf_cli_dir}/python/pynrfjprog" ]] && _oh_my_sdk_print_status "success" "✓ pynrfjprog installed" || _oh_my_sdk_print_status "error" "✗ pynrfjprog missing"
                
                # Check Python environment
                echo
                _oh_my_sdk_print_status "info" "Checking Python environment..."
                command -v west >/dev/null 2>&1 && _oh_my_sdk_print_status "success" "✓ west installed" || _oh_my_sdk_print_status "error" "✗ west missing"
                command -v nrfutil >/dev/null 2>&1 && _oh_my_sdk_print_status "success" "✓ nrfutil installed" || _oh_my_sdk_print_status "error" "✗ nrfutil missing"
                
                # Check PATH
                echo
                _oh_my_sdk_print_status "info" "Checking PATH..."
                [[ ":${PATH}:" == *":${nrf_cli_dir}/bin:"* ]] && _oh_my_sdk_print_status "success" "✓ Command Line Tools in PATH" || _oh_my_sdk_print_status "error" "✗ Command Line Tools not in PATH"
                
                # Check library paths
                echo
                _oh_my_sdk_print_status "info" "Checking library paths..."
                [[ ":${LD_LIBRARY_PATH}:" == *":${nrf_cli_dir}/lib:"* ]] && _oh_my_sdk_print_status "success" "✓ Libraries in LD_LIBRARY_PATH" || _oh_my_sdk_print_status "error" "✗ Libraries not in LD_LIBRARY_PATH"
                
                # Check environment variables
                echo
                _oh_my_sdk_print_status "info" "Checking environment variables..."
                [[ -n "${ZEPHYR_BASE}" ]] && _oh_my_sdk_print_status "success" "✓ ZEPHYR_BASE set" || _oh_my_sdk_print_status "error" "✗ ZEPHYR_BASE not set"
                [[ -n "${ZEPHYR_TOOLCHAIN_VARIANT}" ]] && _oh_my_sdk_print_status "success" "✓ ZEPHYR_TOOLCHAIN_VARIANT set" || _oh_my_sdk_print_status "error" "✗ ZEPHYR_TOOLCHAIN_VARIANT not set"
            else
                _oh_my_sdk_print_status "error" "NRF Connect SDK directory not found at ${nrf_dir}"
            fi
        fi
    else
        _oh_my_sdk_print_status "info" "No environment currently active"
    fi
} 