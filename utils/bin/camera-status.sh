#!/usr/bin/env bash
ACTIVE=false

for dev in /dev/video*; do
    [[ -e "$dev" ]] || continue
    if fuser "$dev" &>/dev/null 2>&1; then
        ACTIVE=true
        break
    fi
done

if $ACTIVE; then
    echo '{"text":"","class":"active","tooltip":"Camera in use"}'
else
    echo '{"text":"","class":"","tooltip":"Camera idle"}'
fi
