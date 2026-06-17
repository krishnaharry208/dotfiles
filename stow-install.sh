#!/bin/bash

# Stow-Only Dotfiles Deployment Script
# This script deploys configuration files using GNU Stow
# It assumes system packages and dependencies are already installed

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}== Stow Dotfiles Deployment          ==${NC}"
echo -e "${GREEN}=========================================${NC}"

# Get the script directory (dotfiles folder)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="${SUDO_USER:-$USER}"
HOME_DIR=$(eval echo "~$USER_HOME")

echo -e "${YELLOW}Dotfiles directory: $DOTFILES_DIR${NC}"
echo -e "${YELLOW}Target home: $HOME_DIR${NC}"

# Verify stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}Error: GNU Stow is not installed${NC}"
    echo "Install it with: sudo apt install stow"
    exit 1
fi

# Create ~/.config if it doesn't exist
if [ ! -d "$HOME_DIR/.config" ]; then
    echo -e "${YELLOW}Creating ~/.config directory${NC}"
    sudo -u "$USER_HOME" mkdir -p "$HOME_DIR/.config"
fi

# Backup existing configs before stowing
echo -e "${YELLOW}== Backing up existing configurations ==${NC}"
sudo -u "$USER_HOME" mkdir -p "$HOME_DIR/.backup"

PACKAGES="alacritty fastfetch i3 picom polybar rofi"
for pkg in $PACKAGES; do
    if [ -d "$HOME_DIR/.config/$pkg" ] && [ ! -L "$HOME_DIR/.config/$pkg" ]; then
        echo -e "${YELLOW}Moving ~/.config/$pkg to ~/.backup/${NC}"
        sudo -u "$USER_HOME" mv "$HOME_DIR/.config/$pkg" "$HOME_DIR/.backup/"
    fi
done

# Deploy symlinks with Stow
echo -e "${YELLOW}== Deploying configurations with Stow ==${NC}"

cd "$DOTFILES_DIR"

for pkg in $PACKAGES; do
    if [ -d "$pkg" ]; then
        echo -e "${GREEN}Stowing $pkg...${NC}"
        # Run as user to maintain proper permissions
        sudo -u "$USER_HOME" stow -R "$pkg"
    else
        echo -e "${RED}Warning: $pkg directory not found, skipping${NC}"
    fi
done

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}== All configurations deployed!        ==${NC}"
echo -e "${GREEN}== Symlinks created in ~/.config       ==${NC}"
echo -e "${GREEN}=========================================${NC}"

echo ""
echo -e "${YELLOW}To undo these changes, run:${NC}"
echo "  cd $DOTFILES_DIR"
echo "  stow -D alacritty fastfetch i3 picom polybar rofi"
echo ""
echo -e "${YELLOW}To see what was created, run:${NC}"
echo "  ls -la ~/.config/"
