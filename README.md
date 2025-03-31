# oh-my-sdk

A Zsh plugin for managing SDK installations and environments, with support for Zephyr and NRF Connect SDKs.

## Features

- Manages SDK installations in `~/.oh-my-sdk/`
- Creates isolated Python virtual environments for each SDK
- Auto-activates SDK environments based on directory
- Provides easy activation/deactivation commands
- Handles system dependencies installation
- Supports Zephyr and NRF Connect SDKs

## Installation

### Using oh-my-zsh

1. Clone this repository to your oh-my-zsh plugins directory:
```bash
git clone https://github.com/paigeadelethompson/oh-my-sdk ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/oh-my-sdk
```

2. Add the plugin to your `~/.zshrc`:
```bash
plugins=(... oh-my-sdk)
```

3. Reload your shell:
```bash
source ~/.zshrc
```

### Using Antigen

1. Add the following line to your `~/.zshrc`:
```bash
antigen bundle paigeadelethompson/oh-my-sdk
```

2. Reload your shell:
```bash
source ~/.zshrc
```

Note: Make sure you have Antigen properly set up in your `~/.zshrc` before adding the plugin. If you haven't set up Antigen yet, you'll need to add the following to your `~/.zshrc`:

```bash
source ~/.antigen/antigen.zsh
antigen init
```

For more information about Antigen, visit the [Antigen repository](https://github.com/zsh-users/antigen).

## Usage

### Installing SDKs

To install Zephyr SDK:
```bash
install_zephyr
```

To install NRF Connect SDK:
```bash
install_nrf
```

These commands will:
1. Check and install required system dependencies
2. Create necessary directories
3. Set up Python virtual environments
4. Install the SDK and its dependencies

### Managing Environments

Activate Zephyr environment:
```bash
activate_zephyr
```

Activate NRF Connect environment:
```bash
activate_nrf
```

Deactivate current environment:
```bash
deactivate_sdk
```

Note: The activation commands will fail if the corresponding SDK is not installed. You must run the installation commands first.

### Auto-activation

The plugin automatically detects the type of project based on the presence of specific files:

- For Zephyr projects:
  - `prj.conf`
  - `CMakeLists.txt`

- For NRF Connect projects:
  - `prj.conf`
  - `CMakeLists.txt`
  - `app.overlay` or any `.overlay` file

When you enter a directory containing these files, the plugin will:
1. Detect the project type based on the presence of these files
2. If the corresponding SDK is installed, activate the appropriate environment
3. If the SDK is not installed, prompt you to install it first

### Creating Hooks

The plugin provides commands to create hooks that will be executed during SDK installation, activation, and deactivation events.

#### Creating Installation Hooks
```bash
create_install_hook my_hook
```
Creates a new hook script that will be executed after SDK installation.

#### Creating Activation Hooks
```bash
create_activate_hook my_hook
```
Creates a new hook script that will be executed when activating an SDK environment.

#### Creating Deactivation Hooks
```bash
create_deactivate_hook my_hook
```
Creates a new hook script that will be executed when deactivating an SDK environment.

#### Listing Hooks
```bash
list_hooks
```
Lists all available hooks in each category.

#### Hook Script Structure
Each hook script receives the SDK name as an argument and can be customized to perform specific actions:

```bash
#!/usr/bin/env zsh

SDK_NAME="$1"

case "${SDK_NAME}" in
    "zephyr")
        # Add your Zephyr-specific hook commands here
        echo "Executing Zephyr hook"
        ;;
    "nrf")
        # Add your NRF-specific hook commands here
        echo "Executing NRF hook"
        ;;
    *)
        echo "Unknown SDK: ${SDK_NAME}"
        exit 1
        ;;
esac
```

Hooks are stored in the following directories:
```
~/.oh-my-sdk/hooks/
├── install/     # Installation hooks
├── activate/    # Activation hooks
└── deactivate/  # Deactivation hooks
```

## Directory Structure

```
~/.oh-my-sdk/
├── dist/           # SDK installations
│   ├── zephyr/     # Zephyr SDK
│   └── nrf/        # NRF Connect SDK
└── pyenv/          # Python virtual environments
    ├── zephyr/     # Zephyr Python environment
    └── nrf/        # NRF Connect Python environment
```

## Requirements

- Zsh
- Python 3
- System dependencies (automatically installed if missing):
  - git
  - cmake
  - ninja-build
  - gperf
  - ccache
  - dfu-util
  - device-tree-compiler
  - wget
  - python3
  - python3-pip
  - python3-venv
  - make
  - gcc
  - gcc-multilib
  - g++-multilib
  - libsdl2-dev
  - libmagic1

## License

MIT License

### Creating New Projects

#### Zephyr Project
```bash
create_zephyr_project my_project
```
This will create a new Zephyr project with:
- Basic project structure
- CMakeLists.txt
- src/main.c with a Hello World example
- prj.conf with logging enabled

#### NRF Connect Project
```bash
create_nrf_project my_project
```
This will:
1. List available NRF boards
2. Prompt you to select a board
3. Create a new NRF project with:
   - Basic project structure
   - CMakeLists.txt
   - src/main.c with a Hello World example
   - prj.conf with logging and Bluetooth enabled
   - app.overlay with NRF-specific configurations

#### Listing Available NRF Boards
```bash
_oh_my_sdk_list_nrf_boards
```
Lists all available NRF boards for project creation.

### Getting Help

The plugin provides help commands for both SDKs:

#### Zephyr Help
```bash
zephyr_help
```
Shows comprehensive help for Zephyr SDK, including:
- Installation commands
- Environment management
- Project management
- Common board targets
- Configuration files
- Documentation link

#### NRF Connect Help
```bash
nrf_help
```
Shows comprehensive help for NRF Connect SDK, including:
- Installation commands
- Environment management
- Project management
- Common board targets
- Configuration files
- Bluetooth configuration
- Documentation link

### Uninstallation

To completely remove oh-my-sdk and all its contents (including installed SDKs and environments):

```bash
zap_oh_my_sdk
```

This will:
1. Remove the entire `~/.oh-my-sdk` directory and all its contents
2. Prompt you to restart your shell
3. Allow you to start fresh with a clean installation if desired

Note: This is a destructive operation that will remove all installed SDKs, environments, and configurations. Make sure to back up any important data before running this command. 