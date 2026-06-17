#!/usr/bin/env bash

# Get current volume (%)
get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{print $2}' | tr -d ' %'
}

# Check mute status
is_muted() {
    pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'
}

case "$1" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        if [[ "$(is_muted)" == "yes" ]]; then
            echo " Muted"
        else
            vol=$(get_volume)

            # Clamp visual max to 100%
            if [ "$vol" -gt 100 ]; then
                vol=100
            fi

            echo " ${vol}%"
        fi
        ;;
esac