# oh-my-sdk

A Zsh plugin for managing SDK installations and environments.

## Features

- Install and manage NRF Connect SDK
- Create new NRF projects with proper board configuration
- Auto-detect and activate SDK environments
- Manage Python virtual environments for each SDK
- List available boards and configurations

## Installation

### Using Antigen

Add the following to your `.zshrc`:

```zsh
antigen bundle paigeadelethompson/oh-my-sdk
```

### Manual Installation

1. Clone this repository:
```zsh
git clone https://github.com/paigeadelethompson/oh-my-sdk.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/oh-my-sdk
```

2. Add `oh-my-sdk` to your plugins list in `.zshrc`:
```zsh
plugins=(... oh-my-sdk)
```

## Usage

### NRF Connect SDK

```zsh
# Install NRF Connect SDK
omsdk install nrf

# Activate NRF environment
omsdk activate nrf

# Create a new NRF project
omsdk create nrf my_project

# List available boards
omsdk list nrf boards

# Show help
omsdk help nrf
```

## License

MIT License 