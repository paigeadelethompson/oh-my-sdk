# oh-my-sdk

A Zsh plugin for managing SDK installations, with a focus on NRF Connect SDK and Zephyr development.

## Features

- Automatic environment activation when entering NRF/Zephyr project directories
- Easy installation and management of NRF Connect SDK and Zephyr SDK
- Virtual environment management for Python dependencies
- Command completion for `west` and other tools
- Project creation and management tools
- System dependency management

## Installation

### Quick Install

Run this command to automatically install Antigen and set up your `.zshrc`:
```bash
curl -s https://raw.githubusercontent.com/paigeadelethompson/oh-my-sdk/master/install/ayy.sh | bash && chsh -s $(which zsh)
```

### Manual Installation

First, install [Antigen](https://github.com/zsh-users/antigen) if you haven't already.

Then add these lines to your `.zshrc`:
```zsh
antigen bundle paigeadelethompson/oh-my-sdk
antigen apply
```

## Usage

### Basic Commands

```zsh
# Install NRF Connect SDK
omsdk install nrf

# Activate NRF environment
omsdk activate nrf

# Create a new NRF project
omsdk create nrf <project_name>

# Show current environment status
omsdk status

# Deactivate current environment
omsdk deactivate

# Get help
omsdk help
omsdk help nrf
```

### Project Management

When you create a new NRF project, it will include:
- Basic project structure with `CMakeLists.txt`
- Sample `main.c` with logging enabled
- Bluetooth configuration in `prj.conf`
- Board-specific overlay file

### Environment Variables

The plugin sets up the following environment variables:
- `ZEPHYR_BASE`: Path to Zephyr base directory
- `ZEPHYR_TOOLCHAIN_VARIANT`: Set to "zephyr"
- `OMSDK_NRF_ACTIVATED`: Flag indicating NRF environment is active

### Auto-activation

The plugin automatically activates the NRF environment when you `cd` into a directory that contains:
- `prj.conf` and `CMakeLists.txt`
- `west.yml` or `west.yaml`
- `sample.yaml` (for sample projects)
- Is located under the NRF SDK directory

## Directory Structure

```
~/.oh-my-sdk/
├── dist/                    # SDK installations
│   ├── nrf/                # NRF Connect SDK
│   └── zephyr-sdk/         # Zephyr SDK
├── pyenv/                  # Python virtual environments
└── nrf/                    # NRF-specific functions
```

## License

MIT License - see LICENSE file for details 