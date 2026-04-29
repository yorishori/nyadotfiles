#!/usr/bin/env bash

RECORDERS=("wf-recorder" "obs" "gpu-screen-recorder" "kooha")

ACTIVE=false
for proc in "${RECORDERS[@]}"; do
    if pgrep -x "$proc" &>/dev/null; then
        ACTIVE=true
        break
    fi
done

if $ACTIVE; then
    echo '{"text":"󰻂","class":"active","tooltip":"Recording active"}'
else
    echo '{"text":"󰻂","class":"","tooltip":"Not recording"}'
fi
