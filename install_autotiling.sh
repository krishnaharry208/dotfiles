#!/bin/bash

# 1. Update and Install System Packages
echo "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y autotiling python3-i3ipc python3-pip

# 2. Install latest version via pip (as requested)
echo "Installing autotiling via pip..."
pip install autotiling --break-system-packages

# 3. Set up the i3 configuration
CONFIG_PATH="$HOME/.config/i3/config"
AUTOSTART_LINE="exec_always --no-startup-id autotiling"

if [ -f "$CONFIG_PATH" ]; then
    # Check if the line already exists to avoid duplicates
    if grep -q "autotiling" "$CONFIG_PATH"; then
        echo "Autotiling already exists in i3 config."
    else
        echo "Adding autotiling to i3 config..."
        echo -e "\n# Autotiling script\n$AUTOSTART_LINE" >> "$CONFIG_PATH"
    fi
else
    echo "Error: i3 config file not found at $CONFIG_PATH"
fi

# 4. Reload i3 to apply changes
echo "Reloading i3wm..."
i3-msg reload

echo "Done! Autotiling is set up and running."
