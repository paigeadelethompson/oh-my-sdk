#!/bin/bash

# Exit on error
set -e

# Install antigen
echo "Installing antigen..."
mkdir -p ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh

# Create or update .zshrc
echo "Setting up .zshrc..."
cat > ~/.zshrc << 'EOL'
# Load antigen
source ~/.antigen/antigen.zsh

# Load oh-my-zsh
antigen use oh-my-zsh

# Load oh-my-sdk plugin
antigen bundle paigeadelethompson/oh-my-sdk

# Load syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# Apply antigen changes
antigen apply
EOL

echo "Setup complete! Please run 'chsh -s $(which zsh)' to set zsh as your default shell."
echo "Then restart your terminal or run 'zsh' to start using your new shell configuration." 