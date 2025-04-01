#!/usr/bin/env zsh

# Function to show NRF Connect help
function nrf_help() {
    echo "NRF Connect SDK Help"
    echo "==================="
    echo
    echo "Installation:"
    echo "  omsdk install nrf              Install NRF Connect SDK"
    echo "  omsdk create nrf <name>        Create a new NRF project"
    echo "  omsdk list nrf boards         List available NRF boards"
    echo
    echo "Environment:"
    echo "  omsdk activate nrf             Activate NRF environment"
    echo "  omsdk deactivate              Deactivate current environment"
    echo
    echo "Project Management:"
    echo "  west build -b <board>         Build project for specific board"
    echo "  west flash                    Flash project to board"
    echo "  west debug                    Start debug session"
    echo
    echo "Common Boards:"
    echo "  nrf52840dk_nrf52840          nRF52840 Development Kit"
    echo "  nrf52dk_nrf52832             nRF52 Development Kit"
    echo "  nrf5340dk_nrf5340_cpuapp     nRF5340 Development Kit"
    echo "  nrf9160dk_nrf9160            nRF9160 Development Kit"
    echo
    echo "Configuration:"
    echo "  prj.conf                      Project configuration"
    echo "  CMakeLists.txt               Build configuration"
    echo "  app.overlay                  NRF-specific device tree overlay"
    echo
    echo "Bluetooth:"
    echo "  CONFIG_BT=y                  Enable Bluetooth"
    echo "  CONFIG_BT_PERIPHERAL=y       Configure as peripheral"
    echo "  CONFIG_BT_CENTRAL=y          Configure as central"
    echo
    echo "Documentation:"
    echo "  https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/"
} 