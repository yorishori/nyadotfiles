#!/bin/bash

# Use: nylaunch.sh <app>
# Apps: bluetui, impala, pulsemixer, pacseek, btop, services, yazi

APP="${1:-}"

# App config [app:"class|cols|lines|command"]
declare -A APP_CFG
APP_CFG[bluetui]="nya-bluetui|80|24|bluetui"
APP_CFG[impala]="nya-impala|80|24|impala"
APP_CFG[pulsemixer]="nya-pulsemixer|80|24|pulsemixer"
APP_CFG[pacseek]="nya-pacseek|100|30|pacseek"
APP_CFG[btop]="nya-btop|130|38|btop"
APP_CFG[services]="nya-services|130|38|fzf-services.sh"
APP_CFG[yazi]="nya-yazi|130|38|yazi"
APP_CFG[ikhal]="nya-ikhal|80|24|ikhal"



if [[ -z "$APP" || -z "{APP_CFG[$APP]}" ]]; then
    echo "Usage: nylaunch.sh <bluetui|impala|pulsemixer|pacseek|btop|services|yazi|ikhal>" >&2
    exit
fi

IFS='|' read -r CLASS COLS LINES CMD <<< "${APP_CFG[$APP]}"

window_exists() {
    hyprctl clients -j | grep -q "\"class\": \"$CLASS\""
}

focus_window() {
    local addr
    addr=$(hyprctl clients -j \
        | grep -B20 "\"class\": \"$CLASS\"" \
        | grep '"address"' \
        | tail -1 \
        | grep -oP '0x[0-9a-f]+')

    local ws
    ws=$(hyprctl activeworkspace -j | grep -oP '"id":\s*\K\d+' | head -1)

    hyprctl dispatch 'hl.dsp.window.move({window = "address:'"$addr"'", workspace = '"$ws"'})'
    hyprctl dispatch 'hl.dsp.focus({window = "address:'"$addr"'"})'
}

if window_exists; then
    focus_window
    exit 0
fi

kitty \
    --class "$CLASS" \
    --override "initial_window_width=${COLS}c" \
    --override "initial_window_height=${LINES}c" \
    --override "remember_window_size=no" \
    "$CMD" &
