#!/usr/bin/env zsh

# Function to install Zephyr SDK
function _oh_my_sdk_install_zephyr_sdk() {
    local zephyr_sdk_dir="${OH_MY_SDK_DIST}/zephyr-sdk"
    local sdk_version="0.17.0"
    local sdk_arch="x86_64"
    
    # Check if already installed
    if [[ -d "${zephyr_sdk_dir}" ]]; then
        _oh_my_sdk_print_status "warning" "Zephyr SDK is already installed at ${zephyr_sdk_dir}"
        return 0
    fi
    
    # Create directory
    mkdir -p "${zephyr_sdk_dir}"
    cd "${zephyr_sdk_dir}"
    
    # Download SDK
    _oh_my_sdk_print_status "info" "Downloading Zephyr SDK ${sdk_version}..."
    wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${sdk_version}/zephyr-sdk-${sdk_version}_linux-${sdk_arch}.tar.xz"
    
    # Verify download
    wget -q -O - "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${sdk_version}/sha256.sum" | shasum --check --ignore-missing
    
    # Extract SDK
    _oh_my_sdk_print_status "info" "Extracting Zephyr SDK..."
    tar xf "zephyr-sdk-${sdk_version}_linux-${sdk_arch}.tar.xz"
    rm "zephyr-sdk-${sdk_version}_linux-${sdk_arch}.tar.xz"
    
    # Run setup script with -c flag to register CMake package
    _oh_my_sdk_print_status "info" "Running Zephyr SDK setup script..."
    cd "zephyr-sdk-${sdk_version}"
    ./setup.sh -c
    
    # Install udev rules
    _oh_my_sdk_print_status "info" "Installing udev rules..."
    sudo cp "sysroots/${sdk_arch}-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules" /etc/udev/rules.d/
    sudo udevadm control --reload
    
    _oh_my_sdk_print_status "success" "Zephyr SDK installation complete!"
} 