#!/usr/bin/bash
# hypr-float.sh — generic floating TUI app toggler for Hyprland
#
# Usage:
#   hypr-float.sh --bin <binary> [--size <WxH>] [--close-on-unfocus <true|false>]
#
# Examples:
#   hypr-float.sh --bin btop --size 1200x700 --close-on-unfocus false
#   hypr-float.sh --bin pulsemixer --size 800x400 --close-on-unfocus true
#   hypr-float.sh --bin impala
#
# Notes:
#   - Class name is derived from the binary name.
#   - --size defaults to 900x550 if omitted.
#   - --close-on-unfocus defaults to false if omitted.
#   - close-on-unfocus applies dynamically at spawn time via hyprctl keyword,
#     so no static config entry per app is needed.

# ── Defaults ──────────────────────────────────────────────────────────────────
BIN=""
WIDTH=900
HEIGHT=550
CLOSE_ON_UNFOCUS=false

# ── Argument parsing ───────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --bin)
            BIN="$2"; shift 2 ;;
        --size)
            IFS='x' read -r WIDTH HEIGHT <<< "$2"; shift 2 ;;
        --close-on-unfocus)
            CLOSE_ON_UNFOCUS="$2"; shift 2 ;;
        *)
            echo "Unknown parameter: $1"
            echo "Usage: hypr-float.sh --bin <binary> [--size <WxH>] [--close-on-unfocus <true|false>]"
            exit 1 ;;
    esac
done

# ── Validation ─────────────────────────────────────────────────────────────────
if [[ -z "$BIN" ]]; then
    echo "Error: --bin is required."
    echo "Usage: hypr-float.sh --bin <binary> [--size <WxH>] [--close-on-unfocus <true|false>]"
    exit 1
fi

if ! command -v "$BIN" &>/dev/null; then
    echo "Error: '$BIN' not found in PATH."
    exit 1
fi

CLASS="$BIN"

# ── Toggle logic ───────────────────────────────────────────────────────────────
WINDOW=$(hyprctl clients -j | jq -r --arg class "$CLASS" '.[] | select(.class == $class) | .address' | head -n1)

if [[ -n "$WINDOW" ]]; then
    FOCUSED=$(hyprctl activewindow -j | jq -r '.class')

    if [[ "$FOCUSED" == "$CLASS" ]]; then
        # Focused — close it
        hyprctl dispatch killactive
    else
        # Open but not focused — pull to current workspace and focus
        hyprctl dispatch movetoworkspace "e+0,class:$CLASS"
        hyprctl dispatch focuswindow "class:$CLASS"
    fi
else
    # Not open — apply dynamic windowrules then spawn

    # Always: float, center, size
    hyprctl keyword windowrulev2 "float,class:^(${CLASS})$"
    hyprctl keyword windowrulev2 "center,class:^(${CLASS})$"
    hyprctl keyword windowrulev2 "size ${WIDTH} ${HEIGHT},class:^(${CLASS})$"

    # Optional: close when focus is lost
    if [[ "$CLOSE_ON_UNFOCUS" == "true" ]]; then
        hyprctl keyword windowrulev2 "closeonfocusloss,class:^(${CLASS})$"
    fi

    kitty \
        --class "$CLASS" \
        --override initial_window_width="${WIDTH}" \
        --override initial_window_height="${HEIGHT}" \
        -e "$BIN" &
fi
