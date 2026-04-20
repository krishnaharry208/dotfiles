#!/usr/bin/env bash

# Options
options=" Shutdown\n󰜉 Reboot\n Lock\n󰍃 Logout"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "System" \
    -theme-str 'window {width: 250px; border: 2px; border-color: #7aa2f7; border-radius: 15px;} \
                listview {lines: 4;} \
                element {padding: 10px;} \
                element selected {background-color: #24283b; text-color: #7aa2f7;}')

case "$chosen" in
    *Shutdown) poweroff ;;
    *Reboot) reboot ;;
    *Lock) betterlockscreen -l ;; # Change to your lock screen command
    *Logout) i3-msg exit ;; # Change to your WM exit command
esac