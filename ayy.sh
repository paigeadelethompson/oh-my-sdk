#!/bin/bash

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
antigen bundle /home/netcraveos/CursorProjects/oh-my-sdk

# Load syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# Apply antigen changes
antigen apply
EOL

echo "Setup complete! Please run 'zsh' to start using your new shell configuration." 