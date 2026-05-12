#!/bin/bash
TMP=/tmp/startup.log

echo "Startup script..." > $TMP

# Check if we are already in session
if [[ -n "$WAYLAND_DISPLAY" ]] || [[ -n "$DISPLAY" ]]; then
    echo "Already running Display Server" >> $TMP
    exit 1
fi

echo "Starting hyprland..." >> $TMP

start-hyprland &> /dev/null
