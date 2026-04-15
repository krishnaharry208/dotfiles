#!/bin/bash

# Get volume & mute
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -n1 | tr -d '%')
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

# Clamp max 100
if [ "$VOLUME" -gt 100 ]; then
    VOLUME=100
fi

# Colors
BG_NORMAL="#3b4252"   # change to your theme
BG_MUTED="#e53935"

# Icons based on volume
if [ "$VOLUME" -eq 0 ]; then
    ICON="󰖁 "   # muted/zero
elif [ "$VOLUME" -lt 30 ]; then
    ICON=" "   # low
elif [ "$VOLUME" -lt 70 ]; then
    ICON=" "   # medium
else
    ICON=" "   # high
fi

# Output
if [ "$MUTED" = "yes" ]; then
    echo "%{T2}%{F$BG_MUTED}%{T-}%{B$BG_MUTED}%{F#FFFFFF} 󰝟 Muted %{B-}%{T2}%{F$BG_MUTED}%{T-}"
else
    echo "%{T2}%{F$BG_NORMAL}%{T-}%{B$BG_NORMAL}%{F#FFFFFF} ${ICON} ${VOLUME}% %{B-}%{T2}%{F$BG_NORMAL}%{T-}"
fi
