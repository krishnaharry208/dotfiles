#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================="
echo "== Starting Full System Setup & Dotfiles =="
echo "=========================================="

# Always evaluate paths relative to the actual executing user (not root)
USER_HOME=${SUDO_USER:-$USER}
HOME_DIR=$(eval echo "~$USER_HOME")

# ----------------------------
# 1. Update System & Install Core Packages Safely
# ----------------------------
echo "== Checking and installing required system packages =="

# Build a list of missing packages to avoid wasting time re-installing
PACKAGES=(i3 alacritty thunar picom polybar rofi fastfetch git stow wget unzip fontconfig python3-i3ipc python3-pip)
TO_INSTALL=()

for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing missing packages: ${TO_INSTALL[*]}"
    sudo apt update
    sudo apt install -y "${TO_INSTALL[@]}"
else
    echo "All core system packages are already installed!"
fi

# ----------------------------
# 2. Install Autotiling via Pip (As User, NOT Root)
# ----------------------------
if ! command -v autotiling >/dev/null 2>&1 && [ ! -f "$HOME_DIR/.local/bin/autotiling" ]; then
    echo "== Installing Autotiling via pip =="
    # Run as the regular user to prevent permission issues
    sudo -u "$USER_HOME" pip install --user autotiling --break-system-packages
else
    echo "Autotiling binary already exists!"
fi

# ----------------------------
# 3. Install JetBrainsMono Nerd Font
# ----------------------------
if [ ! -d "$HOME_DIR/.local/share/fonts" ] || [ -z "$(ls -A "$HOME_DIR/.local/share/fonts" 2>/dev/null)" ]; then
    echo "== Installing JetBrainsMono Nerd Font =="
    sudo -u "$USER_HOME" mkdir -p "$HOME_DIR/.local/share/fonts"
    
    cd /tmp
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    
    unzip -o JetBrainsMono.zip -d JetBrainsMono
    cp JetBrainsMono/*.ttf "$HOME_DIR/.local/share/fonts/"
    
    # Refresh font cache as user
    sudo -u "$USER_HOME" fc-cache -fv
    rm -rf /tmp/JetBrainsMono*
else
    echo "Nerd Fonts are already installed!"
fi

# ----------------------------
# 4. Setup Dotfiles Directory
# ----------------------------
echo "== Syncing dotfiles repository =="
if [ ! -d "$HOME_DIR/dotfiles" ]; then
    sudo -u "$USER_HOME" git clone https://github.com/krishnaharry208/dotfiles "$HOME_DIR/dotfiles"
else
    echo "Dotfiles folder already exists. Pulling latest updates..."
    cd "$HOME_DIR/dotfiles"
    sudo -u "$USER_HOME" git pull
fi

cd "$HOME_DIR/dotfiles"

# Clean up duplicate paths if they exist
[ -d "polybar/scripts" ] && rm -rf polybar/scripts

# ----------------------------
# 5. Inject Autotiling into Dotfiles Config Safely
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
        # Make sure user retains ownership
        chown "$USER_HOME":"$USER_HOME" "$I3_CONFIG"
    fi
else
    echo "Warning: i3 config file not found at $I3_CONFIG yet."
fi

# ----------------------------
# 6. Safe Backup (Only if they are real directories, NOT symlinks)
# ----------------------------
echo "== Backing up existing physical configurations =="
sudo -u "$USER_HOME" mkdir -p "$HOME_DIR/.config"
sudo -u "$USER_HOME" mkdir -p "$HOME_DIR/.backup"

for app in i3 alacritty picom polybar rofi fastfetch; do
    if [ -d "$HOME_DIR/.config/$app" ] && [ ! -L "$HOME_DIR/.config/$app" ]; then
        echo "Moving physical $app config to ~/.backup/"
        mv "$HOME_DIR/.config/$app" "$HOME_DIR/.backup/"
    fi
done

# ----------------------------
# 7. Apply Configs with GNU Stow as regular User
# ----------------------------
echo "== Deploying symlinks with GNU Stow =="
STOW_PACKAGES="alacritty fastfetch i3 picom polybar rofi"

# Crucial: Run stow as the user, not root, so your symlinks are owned by you!
for pkg in $STOW_PACKAGES; do
    if [ -d "$pkg" ]; then
        echo "Stowing $pkg..."
        sudo -u "$USER_HOME" stow -R "$pkg"
    fi
done

# Reload i3 layout (will quietly skip if X server isn't running yet)
sudo -u "$USER_HOME" i3-msg reload || true

echo "=========================================="
echo "== ALL DONE! Everything is linked up!   =="
echo "== Refresh i3 or restart your system.   =="
echo "=========================================="