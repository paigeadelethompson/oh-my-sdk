# oh-my-sdk

A Zsh plugin for managing SDK installations and environments.

## Quick Install

```bash
curl -s https://raw.githubusercontent.com/yourusername/SDKSetup/main/ayy.sh | bash && zsh
```

## Manual Installation

### Prerequisites

- Zsh shell
- Git
- Python 3
- pip (Python package manager)

### Installing Antigen

1. Install antigen:
```bash
mkdir -p ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh
```

2. Configure your `.zshrc`:
```bash
# Load antigen
source ~/.antigen/antigen.zsh

# Load oh-my-zsh
antigen use oh-my-zsh

# Load oh-my-sdk plugin
antigen bundle /path/to/SDKSetup

# Load syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# Apply antigen changes
antigen apply
```

3. Restart your shell:
```bash
zsh
```

### Installing oh-my-sdk

1. Clone this repository:
```bash
git clone https://github.com/yourusername/SDKSetup.git
```

2. The plugin will be automatically loaded by antigen.

## Usage

### NRF Connect SDK

Install NRF Connect SDK:
```bash
omsdk install nrf
```

Activate NRF environment:
```bash
omsdk activate nrf
```

Create a new NRF project:
```bash
omsdk create nrf my_project
```

Show current status:
```bash
omsdk status
```

### Zephyr SDK

Install Zephyr SDK:
```bash
install_zephyr
```

Activate Zephyr environment:
```bash
activate_zephyr
```

Create a new Zephyr project:
```bash
create_zephyr_project my_project
```

## Features

- Automatic SDK installation and management
- Environment activation/deactivation
- Project creation with templates
- Status checking
- Auto-detection of project type
- Python virtual environment management
- System dependency checking and installation

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 