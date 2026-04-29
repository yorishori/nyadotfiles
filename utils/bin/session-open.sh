#!/usr/bin/env bash

CHOICE=$(printf "󰜉  Restart\n󰐦  Shutdown" | \
    tofi \
        --prompt-text "" \
        --width 160 \
        --height 120 \
        --background-color "#1e1e2e" \
        --text-color "#cdd6f4" \
        --selection-color "#a6e3a1" \
        --border-color "#313244" \
        --border-width 1 \
        --font "JetBrainsMono Nerd Font" \
        --font-size 13 \
        --padding-top 8 \
        --padding-bottom 8 \
        --padding-left 12 \
        --padding-right 12 \
        --result-spacing 4)

case "$CHOICE" in
    *Restart*)  systemctl reboot ;;
    *Shutdown*) systemctl poweroff ;;
esac
