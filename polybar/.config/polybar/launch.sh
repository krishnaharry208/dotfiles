#!/usr/bin/env bash

# Kill any existing Polybar instances
killall -q polybar

# Wait until all instances are gone
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Launch Polybar (bar name must match your config section)
polybar example &

echo "Polybar launched..."
