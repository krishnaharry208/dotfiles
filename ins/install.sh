#!/bin/bash

set -e

echo "== Installing dependencies =="

sudo apt update

sudo apt install -y \
    i3 \
    alacritty \
    thunar \
    picom \
    polybar \
    rofi \
    fastfetch \
    git \
    stow \
    wget \
    unzip \
    fontconfig \
    python3-pip \
    python3-i3ipc

echo "== Installing autotiling =="

if ! command -v autotiling >/dev/null 2>&1; then
    pip3 install --user autotiling --break-system-packages
fi

echo "== Installing JetBrainsMono Nerd Font =="

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    TMP_DIR=$(mktemp -d)

    wget -q \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip \
    -O "$TMP_DIR/JetBrainsMono.zip"

    unzip -qo "$TMP_DIR/JetBrainsMono.zip" -d "$TMP_DIR"

    cp "$TMP_DIR"/*.ttf "$FONT_DIR"

    fc-cache -fv

    rm -rf "$TMP_DIR"
fi

echo ""
echo "Dependencies installed successfully."
echo ""
echo "Apply your dotfiles with:"
echo "cd ~/dotfiles"
echo "stow */"
