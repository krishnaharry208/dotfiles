#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "== Starting Full System Setup & Dotfiles =="
echo "=========================================="

# Detect user (important if run with sudo)
USER_HOME=${SUDO_USER:-$USER}
HOME_DIR=$(eval echo "~$USER_HOME")

# ----------------------------
# 1. Update System & Install Core Packages
# ----------------------------
echo "== Installing required packages =="
sudo apt update && sudo apt upgrade -y
sudo apt install -y i3 alacritty thunar picom polybar rofi fastfetch git stow wget unzip fontconfig python3-i3ipc python3-pip

# ----------------------------
# 2. Install Autotiling via Pip
# ----------------------------
echo "== Installing Autotiling via pip =="
pip install --user autotiling --break-system-packages

# ----------------------------
# 3. Install JetBrainsMono Nerd Font
# ----------------------------
echo "== Installing JetBrainsMono Nerd Font =="
mkdir -p "$HOME_DIR/.local/share/fonts"

cd /tmp
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

unzip -o JetBrainsMono.zip -d JetBrainsMono
cp JetBrainsMono/*.ttf "$HOME_DIR/.local/share/fonts/"
fc-cache -fv
rm -rf /tmp/JetBrainsMono*

# ----------------------------
# 4. Setup Dotfiles Directory
# ----------------------------
echo "== Syncing dotfiles repository =="
if [ ! -d "$HOME_DIR/dotfiles" ]; then
    git clone https://github.com/krishnaharry208/dotfiles "$HOME_DIR/dotfiles"
else
    echo "Dotfiles folder already exists. Pulling latest updates..."
    cd "$HOME_DIR/dotfiles" && git pull
fi

cd "$HOME_DIR/dotfiles"

# Clean up that duplicate polybar scripts folder if it exists in repo
[ -d "polybar/scripts" ] && rm -rf polybar/scripts

# ----------------------------
# 5. Inject Autotiling into Dotfiles Config
# ----------------------------
echo "== Configuring Autotiling in i3 config =="
I3_CONFIG="$HOME_DIR/dotfiles/i3/.config/config"
AUTOSTART_LINE="exec_always --no-startup-id autotiling"

if [ -f "$I3_CONFIG" ]; then
    if grep -q "autotiling" "$I3_CONFIG"; then
        echo "Autotiling is already configured in dotfiles."
    else
        echo "Adding autotiling execution line to dotfiles i3 config..."
        echo -e "\n# Alternating tiling layout (Horizontal/Vertical)\n$AUTOSTART_LINE" >> "$I3_CONFIG"
    fi
else
    echo "Warning: i3 config file not found at $I3_CONFIG yet."
fi

# ----------------------------
# 6. Safe Backup (Only if they are real directories, NOT symlinks)
# ----------------------------
echo "== Backing up existing physical configurations =="
mkdir -p "$HOME_DIR/.config"
mkdir -p "$HOME_DIR/.backup"

for app in i3 alacritty picom polybar rofi fastfetch; do
    if [ -d "$HOME_DIR/.config/$app" ] && [ ! -L "$HOME_DIR/.config/$app" ]; then
        echo "Moving physical $app config to ~/.backup/"
        mv "$HOME_DIR/.config/$app" "$HOME_DIR/.backup/"
    fi
done

# ----------------------------
# 7. Apply Configs with GNU Stow
# ----------------------------
echo "== Deploying symlinks with GNU Stow =="
cd "$HOME_DIR/dotfiles"

STOW_PACKAGES="alacritty fastfetch i3 picom polybar rofi"

for pkg in $STOW_PACKAGES; do
    if [ -d "$pkg" ]; then
        echo "Stowing $pkg..."
        stow -R "$pkg"
    fi
done

# Reload i3 layout (will quietly skip if X server isn't running yet)
i3-msg reload || true

echo "=========================================="
echo "== ALL DONE! Everything is linked up!   =="
echo "== Refresh i3 or restart your system.   =="
echo "=========================================="