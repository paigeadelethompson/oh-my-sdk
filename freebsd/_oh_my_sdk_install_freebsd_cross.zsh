#!/usr/bin/env zsh

# Function to install FreeBSD cross-compilation environment
function install_freebsd_cross() {
    _oh_my_sdk_print_status "info" "Starting FreeBSD cross-compilation environment setup..."
    
    # Install system dependencies first
    _oh_my_sdk_print_status "info" "Checking system dependencies..."
    _oh_my_sdk_install_system_deps
    _oh_my_sdk_install_freebsd_cross_deps
    
    local freebsd_dir="${OH_MY_SDK_DIST}/freebsd"
    local src_dir="${freebsd_dir}/src"
    local obj_dir="${freebsd_dir}/obj"
    local tools_dir="${freebsd_dir}/tools"
    
    if [[ ! -d "${src_dir}" ]]; then
        _oh_my_sdk_print_status "info" "Creating FreeBSD workspace..."
        mkdir -p "${freebsd_dir}"
        mkdir -p "${obj_dir}"
        mkdir -p "${tools_dir}"
        cd "${freebsd_dir}"

        # Create and activate virtual environment
        _oh_my_sdk_print_status "info" "Setting up Python virtual environment..."
        _oh_my_sdk_create_venv "freebsd"
        _oh_my_sdk_activate_venv "freebsd"

        # Clone FreeBSD source
        _oh_my_sdk_print_status "info" "Cloning FreeBSD source..."
        git clone --depth 1 https://git.freebsd.org/src.git "${src_dir}"
        
        # Create cross-build configuration
        _oh_my_sdk_print_status "info" "Creating cross-build configuration..."
        cat > "${tools_dir}/cross-make.conf" << 'EOF'
CC=clang
CXX=clang++
CPP=clang-cpp
LD=ld.lld
CROSS_BINUTILS_PREFIX=
WITHOUT_TESTS=yes
WITHOUT_TOOLCHAIN=yes
MK_TESTS=no
MK_CLANG=no
MK_GCC=no
MK_LLDB=no
EOF

        # Create helper scripts
        _oh_my_sdk_print_status "info" "Creating helper scripts..."
        
        # Build kernel script
        cat > "${tools_dir}/build-kernel.sh" << 'EOF'
#!/bin/sh
MAKEOBJDIRPREFIX="$1/obj" \
make -C "$1/src" \
    -j$(nproc) \
    TARGET=amd64 \
    TARGET_ARCH=amd64 \
    SRCCONF="$1/tools/cross-make.conf" \
    buildkernel
EOF
        chmod +x "${tools_dir}/build-kernel.sh"

        # Build world script
        cat > "${tools_dir}/build-world.sh" << 'EOF'
#!/bin/sh
MAKEOBJDIRPREFIX="$1/obj" \
make -C "$1/src" \
    -j$(nproc) \
    TARGET=amd64 \
    TARGET_ARCH=amd64 \
    SRCCONF="$1/tools/cross-make.conf" \
    buildworld
EOF
        chmod +x "${tools_dir}/build-world.sh"

        deactivate
        _oh_my_sdk_print_status "success" "FreeBSD cross-compilation environment setup complete!"
        echo
        _oh_my_sdk_print_status "info" "Next steps:"
        echo "  1. Run 'omsdk activate freebsd-cross' to activate the environment"
        echo "  2. Run 'build-kernel.sh \$FREEBSD_DIR' to build the kernel"
        echo "  3. Run 'build-world.sh \$FREEBSD_DIR' to build the world"
        echo "  4. Run 'omsdk help freebsd-cross' for more information"
    else
        _oh_my_sdk_print_status "warning" "FreeBSD cross-compilation environment is already installed."
    fi
} 