#!/usr/bin/env zsh

# Function to install USRP dependencies
function _oh_my_sdk_install_usrp_deps() {
    _oh_my_sdk_print_status "info" "Installing USRP dependencies..."
    
    # Check package manager and install dependencies
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y build-essential cmake git python3-dev python3-pip python3-venv \
            libboost-all-dev libusb-1.0-0-dev doxygen python3-docutils python3-mako \
            python3-numpy python3-requests python3-setuptools python3-ruamel.yaml \
            libfftw3-dev libpcap-dev libudev-dev libgps-dev libthrift-dev \
            libqt5opengl5-dev python3-qt5 qtbase5-dev
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y gcc gcc-c++ make cmake git python3-devel python3-pip \
            boost-devel libusb1-devel doxygen python3-docutils python3-mako \
            python3-numpy python3-requests python3-setuptools python3-ruamel-yaml \
            fftw-devel libpcap-devel systemd-devel gpsd-devel thrift-devel \
            qt5-qtbase-devel python3-qt5
    elif command -v yum &> /dev/null; then
        sudo yum install -y gcc gcc-c++ make cmake git python3-devel python3-pip \
            boost-devel libusb1-devel doxygen python3-docutils python3-mako \
            python3-numpy python3-requests python3-setuptools python3-ruamel-yaml \
            fftw-devel libpcap-devel systemd-devel gpsd-devel thrift-devel \
            qt5-qtbase-devel python3-qt5
    elif command -v zypper &> /dev/null; then
        sudo zypper install -y gcc gcc-c++ make cmake git python3-devel python3-pip \
            libboost_*-devel libusb-1_0-devel doxygen python3-docutils python3-Mako \
            python3-numpy python3-requests python3-setuptools python3-ruamel.yaml \
            fftw3-devel libpcap-devel libudev-devel libgps-devel libthrift-devel \
            libqt5-qtbase-devel python3-qt5
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm base-devel cmake git python python-pip boost libusb \
            doxygen python-docutils python-mako python-numpy python-requests \
            python-setuptools python-ruamel-yaml fftw libpcap systemd gpsd thrift \
            qt5-base python-pyqt5
    else
        _oh_my_sdk_print_status "error" "No supported package manager found"
        return 1
    fi
    
    _oh_my_sdk_print_status "success" "USRP dependencies installed"
} 