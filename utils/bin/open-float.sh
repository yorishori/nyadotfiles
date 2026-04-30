#!/bin/bash
ghostty --class=com.hypr.float --confirm-close-surface=false -e $1 &
GHOSTTY_PID=$!

# Wait for the window to actually appear
while ! hyprctl clients | grep -q "com.hypr.float"; do
    sleep 0.01
done

# Resize and center
hyprctl dispatch resizeactive exact 60% 60%
hyprctl dispatch centerwindow
