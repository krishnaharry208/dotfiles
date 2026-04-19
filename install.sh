#!/bin/bash

set -e

echo "== Starting full setup =="

# Detect user (important for curl + sudo)
USER_HOME=${SUDO_USER:-$USER}
HOME_DIR=$(eval echo "~$USER_HOME")

# ----------------------------
# Setup APT sources (Debian 13 - trixie)
# ----------------------------
echo "== Setting APT sources =="

cp /etc/apt/sources.list /etc/apt/sources.list.backup

cat <<EOF > /etc/apt/sources.list
# Debian 13 official Repository
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

# Debian 13 Security Updates
deb http://security.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware

# Debian 13 Updates
deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
EOF

# ----------------------------
# Update system
# ----------------------------
apt update && apt upgrade -y

# ----------------------------
# Install packages
# ----------------------------
echo "== Installing packages =="

apt install -y i3 alacritty thunar picom git stow wget unzip fontconfig

# ----------------------------
# Install JetBrainsMono Nerd Font
# ----------------------------
echo "== Installing JetBrainsMono Nerd Font =="

mkdir -p "$HOME_DIR/.local/share/fonts"

cd /tmp
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

unzip -o JetBrainsMono.zip -d JetBrainsMono

cp JetBrainsMono/*.ttf "$HOME_DIR/.local/share/fonts/"

fc-cache -fv

# ----------------------------
# Clone dotfiles (if not exists)
# ----------------------------
echo "== Setting up dotfiles =="

if [ ! -d "$HOME_DIR/dotfiles" ]; then
    git clone https://github.com/krishnaharry208/dotfiles "$HOME_DIR/dotfiles"
else
    cd "$HOME_DIR/dotfiles" && git pull
fi

cd "$HOME_DIR/dotfiles"

# ----------------------------
# Backup old configs
# ----------------------------
echo "== Backing up configs =="

mkdir -p "$HOME_DIR/.backup"

[ -e "$HOME_DIR/.config/i3" ] && mv "$HOME_DIR/.config/i3" "$HOME_DIR/.backup/"
[ -e "$HOME_DIR/.config/alacritty" ] && mv "$HOME_DIR/.config/alacritty" "$HOME_DIR/.backup/"
[ -e "$HOME_DIR/.config/picom" ] && mv "$HOME_DIR/.config/picom" "$HOME_DIR/.backup/"

# ----------------------------
# Apply configs with stow
# ----------------------------
echo "== Applying configs with stow =="

for dir in */ ; do
    stow -t "$HOME_DIR" "${dir%/}"
done

echo "== DONE! Reboot or restart i3 =="
