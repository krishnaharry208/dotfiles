#!/bin/bash

chosen=$(printf "Shutdown\nReboot\nLogout" | rofi -dmenu -p "Power")

case "$chosen" in
    (Shutdown)
        shutdown now
        ;;
    (Reboot)
        reboot
        ;;
    (Logout)
        # Detect session and logout properly
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            loginctl terminate-session "$XDG_SESSION_ID"
        else
            pkill -KILL -u "$USER"
        fi
        ;;
esac
