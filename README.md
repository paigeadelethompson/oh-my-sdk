# oh-my-sdk

A Zsh plugin for managing SDK installations and environments.

## Features

- Manage multiple SDK installations (NRF Connect SDK, Zephyr SDK)
- Automatic environment activation when entering project directories
- Virtual environment management for Python dependencies
- Project creation templates
- Consistent command interface with `omsdk` prefix

## Installation

Add the following line to your `.zshrc`:

```bash
# For GitHub installation (short format)
antigen bundle paigeadelethompson/oh-my-sdk

# OR using full GitHub URL format
antigen bundle https://github.com/paigeadelethompson/oh-my-sdk.git

# OR for local installation (development)
# Using absolute path (recommended)
antigen bundle /absolute/path/to/oh-my-sdk

# OR using Git protocol
antigen bundle file:///absolute/path/to/oh-my-sdk

# OR using --no-local-clone for direct sourcing
antigen bundle /absolute/path/to/oh-my-sdk --no-local-clone
```

Reload your shell:
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

### NRF Connect SDK

```bash
# Install NRF Connect SDK
omsdk install nrf

# Activate NRF environment
omsdk activate nrf

# Create a new NRF project
omsdk create nrf my_project

# List available NRF boards
omsdk list nrf boards

# Show NRF-specific help
omsdk help nrf

# Deactivate current environment
omsdk deactivate
```

### Zephyr SDK

```bash
# Install Zephyr SDK
omsdk install zephyr

# Activate Zephyr environment
omsdk activate zephyr

# Create a new Zephyr project
omsdk create zephyr my_project

# List available Zephyr boards
omsdk list zephyr boards

# Show Zephyr-specific help
omsdk help zephyr

# Deactivate current environment
omsdk deactivate
```

### General Commands

```bash
# Show general help
omsdk help

# Show current environment status
omsdk status

# List installed SDKs
omsdk list

# Remove all SDK installations
omsdk zap
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 