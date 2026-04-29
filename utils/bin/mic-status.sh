#!/usr/bin/env bash
MUTED=$(pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | grep -c "yes")

if [[ "$MUTED" -eq 0 ]]; then
    echo '{"text":"󰍬","class":"active","tooltip":"Mic active"}'
else
    echo '{"text":"󰍭","class":"","tooltip":"Mic muted"}'
fi
