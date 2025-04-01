# oh-my-sdk

A Zsh plugin for managing SDK installations and environments.

## Quick Install

```bash
curl -s https://raw.githubusercontent.com/yourusername/oh-my-sdk/master/ayy.sh | bash && zsh
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
antigen bundle /path/to/oh-my-sdk

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
git clone https://github.com/yourusername/oh-my-sdk.git
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
➜  ~ omsdk activate nrf                                                      
ℹ  OH_MY_SDK_DIST value: /home/netcraveos/.oh-my-sdk/dist
ℹ  Looking for NRF directory at: /home/netcraveos/.oh-my-sdk/dist/nrf
ℹ  Looking for Command Line Tools at: /home/netcraveos/.oh-my-sdk/dist/nrf-command-line-tools
ℹ  Activating Python virtual environment...
ℹ  Looking for virtual environment at: /home/netcraveos/.oh-my-sdk/pyenv/nrf
ℹ  Exporting Zephyr CMake package...
Zephyr (/home/netcraveos/.oh-my-sdk/dist/nrf/zephyr/share/zephyr-package/cmake)
has been added to the user package registry in:
~/.cmake/packages/Zephyr

ZephyrUnittest (/home/netcraveos/.oh-my-sdk/dist/nrf/zephyr/share/zephyrunittest-package/cmake)
has been added to the user package registry in:
~/.cmake/packages/ZephyrUnittest

✅ NRF Connect environment activated!

ℹ  Available commands:
  • west help                  Show west command help
  • nrfutil help              Show nrfutil command help
  • omsdk deactivate          Deactivate environment
(nrf) ➜  nrf omsdk status      
ℹ  Current environment: nrf
ℹ  NRF Connect SDK location: /home/netcraveos/.oh-my-sdk/dist/nrf
ℹ  Current directory: /home/netcraveos/.oh-my-sdk/dist/nrf

ℹ  Checking SDK components...
✅ ✓ nrf directory present
✅ ✓ bootloader directory present
✅ ✓ board definitions present

ℹ  Checking Nordic Command Line Tools...
✅ ✓ Command Line Tools directory present

ℹ  Checking binary tools...
✅ ✓ nrfjprog installed
✅ ✓ mergehex installed
✅ ✓ jlinkarm worker installed

ℹ  Checking libraries...
✅ ✓ nrfjprog library installed
✅ ✓ highlevel nrfjprog library installed
✅ ✓ DFU library installed

ℹ  Checking Python components...
✅ ✓ pynrfjprog installed

ℹ  Checking Python environment...
✅ ✓ west installed
✅ ✓ nrfutil installed

ℹ  Checking PATH...
✅ ✓ Command Line Tools in PATH

ℹ  Checking library paths...
✅ ✓ Libraries in LD_LIBRARY_PATH

ℹ  Checking environment variables...
✅ ✓ ZEPHYR_BASE set
✅ ✓ ZEPHYR_TOOLCHAIN_VARIANT set
(nrf) ➜  nrf 
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