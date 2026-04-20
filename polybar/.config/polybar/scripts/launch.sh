#!/usr/bin/env bash

# 1. Define the bar name (matches [bar/example] in config)
BAR_NAME="example"

# 2. Terminate already running bar instances
# We use 'killall -9' as a backup to ensure they actually die
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# 3. Launch Polybar
# Using 'nohup' or '&>' redirects output so it doesn't hang your terminal
echo "---" | tee -a /tmp/polybar.log
polybar $BAR_NAME 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."