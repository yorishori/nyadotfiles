#!/usr/bin/env bash

PACMAN_COUNT=$(checkupdates 2>/dev/null | wc -l)

AUR_COUNT=$(yay -Qua 2>/dev/null | wc -l)

TOTAL=$(( PACMAN_COUNT + AUR_COUNT ))

if [[ "$TOTAL" -gt 0 ]]; then
    echo "{\"text\":\"$TOTAL\",\"class\":\"has-updates\",\"tooltip\":\"$PACMAN_COUNT pacman · $AUR_COUNT AUR\"}"
else
    echo '{"text":"0","class":"","tooltip":"Up to date"}'
fi
