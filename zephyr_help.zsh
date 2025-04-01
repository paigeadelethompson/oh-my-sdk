#!/usr/bin/env zsh

# Function to show Zephyr help
function zephyr_help() {
    echo "Zephyr SDK Help"
    echo "==============="
    echo
    echo "Installation:"
    echo "  install_zephyr              Install Zephyr SDK"
    echo "  create_zephyr_project <name> Create a new Zephyr project"
    echo
    echo "Environment:"
    echo "  activate_zephyr             Activate Zephyr environment"
    echo "  deactivate_sdk              Deactivate current environment"
    echo
    echo "Project Management:"
    echo "  west build -b <board>       Build project for specific board"
    echo "  west flash                  Flash project to board"
    echo "  west debug                  Start debug session"
    echo
    echo "Common Boards:"
    echo "  nrf52840dk_nrf52840        nRF52840 Development Kit"
    echo "  nrf52dk_nrf52832           nRF52 Development Kit"
    echo "  nrf5340dk_nrf5340_cpuapp   nRF5340 Development Kit"
    echo
    echo "Configuration:"
    echo "  prj.conf                    Project configuration"
    echo "  CMakeLists.txt             Build configuration"
    echo "  boards/                    Board-specific overlays"
    echo
    echo "Documentation:"
    echo "  https://docs.zephyrproject.org/"
} 