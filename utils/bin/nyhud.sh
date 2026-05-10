#!/bin/bash

# Usage: nyhud.sh <domain> <action>
# Domains: rofi, mic

DOMAIN="${1:-}"
ACTION="${2:-}"

ROFI_PID="/tmp/nya-rofi.pid"
ROFI_CURRENT="/tmp/nya-rofi.current"

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
RECORDING_DIR="$HOME/Videos/Recordings"
RECORDING_PID="/tmp/nya-recording.pid"



# -- Rofi actions
rofi_running() {
    [[ -f "$ROFI_PID" ]] && kill -0 "$(cat "$ROFI_PID")" 2>/dev/null
}
 
rofi_kill() {
    if rofi_running; then
        kill "$(cat "$ROFI_PID")" 2>/dev/null
        rm -f "$ROFI_PID" "$ROFI_CURRENT"
        sleep 0.1
    fi
}

rofi_open() {
    local name="$1"; shift
    local current=""
 
    [[ -f "$ROFI_CURRENT" ]] && current=$(cat "$ROFI_CURRENT")
 
    # Same menu → close
    if rofi_running && [[ "$current" == "$name" ]]; then
        rofi_kill
        return 1
    fi
 
    # Different menu or nothing open → replace then spawn
    rofi_kill
 
    echo "$name" > "$ROFI_CURRENT"
 
    # Run rofi in background so we can capture its pid, wait for output
    local tmpout
    tmpout=$(mktemp)
 
    "$@" > "$tmpout" &
    echo $! > "$ROFI_PID"
    wait "$(cat "$ROFI_PID")"
    local exit_code=$?
 
    rm -f "$ROFI_PID" "$ROFI_CURRENT"
 
    cat "$tmpout"
    rm -f "$tmpout"
    return $exit_code
}

# -- Mic
mic_toggle() {
    local source
    source=$(pactl get-default-source 2>/dev/null)
    pactl set-source-mute "$source" toggle
    # Signal waybar to refresh mic module
    pkill -RTMIN+2 waybar
}

# -- Screen recording
recording_running() {
    [[ -f "$RECORDING_PID" ]] && kill -0 "$(cat "$RECORDING_PID")" 2>/dev/null
}
 
screen_stop_recording() {
    if recording_running; then
        kill -SIGINT "$(cat "$RECORDING_PID")" 2>/dev/null
        rm -f "$RECORDING_PID"
        pkill -RTMIN+3 waybar
    fi
}
 
screen_screenshot_region() {
    mkdir -p "$SCREENSHOT_DIR"
    local file="$SCREENSHOT_DIR/$(date +%Y%m%d_%H%M%S).png"
 
    grim -g "$(slurp)" "$file" || return
 
    local choice
    choice=$(printf "󰆏 Copy to clipboard\n󰆑 Save only" \
        | rofi_open screen-clip \
            rofi -dmenu -no-custom \
                 -theme ~/.config/rofi/screen.rasi) || return
 
    [[ "$choice" == *Copy* ]] && wl-copy < "$file"
}
 
screen_screenshot_full() {
    mkdir -p "$SCREENSHOT_DIR"
    local file="$SCREENSHOT_DIR/$(date +%Y%m%d_%H%M%S).png"
 
    grim "$file" || return
 
    local choice
    choice=$(printf "󰆏 Copy to clipboard\n󰆑 Save only" \
        | rofi_open screen-clip \
            rofi -dmenu -no-custom \
                 -theme ~/.config/rofi/screen.rasi) || return
 
    [[ "$choice" == *Copy* ]] && wl-copy < "$file"
}
 
screen_record_region() {
    mkdir -p "$RECORDING_DIR"
    local file="$RECORDING_DIR/$(date +%Y%m%d_%H%M%S).mp4"
    local region
 
    region=$(slurp) || return
 
    wf-recorder -g "$region" -f "$file" &
    echo $! > "$RECORDING_PID"
    pkill -RTMIN+3 waybar
}
 
screen_record_full() {
    mkdir -p "$RECORDING_DIR"
    local file="$RECORDING_DIR/$(date +%Y%m%d_%H%M%S).mp4"
 
    wf-recorder -f "$file" &
    echo $! > "$RECORDING_PID"
    pkill -RTMIN+3 waybar
}

# -- Rofi Menus
rofi_session() {
    local choice
    choice=$(printf "󰌾 Lock\n󰜉 Reboot\n󰐥 Shutdown" \
        | rofi_open session \
            rofi -dmenu -no-custom \
                 -theme ~/.config/rofi/session.rasi) || return
 
    case "$choice" in
        *Lock)     hyprlock ;;
        *Reboot)   systemctl reboot ;;
        *Shutdown) systemctl poweroff ;;
    esac
}

rofi_launcher() {
    rofi_open launcher \
        rofi -show drun \
             -theme ~/.config/rofi/launcher.rasi
}

rofi_clipboard() {
    # Keep original lines for decode, strip the id prefix for display
    local entries display_entries
    entries=$(cliphist list)
    display_entries=$(echo "$entries" | sed 's/^[0-9]*\t//')
 
    local choice_display choice_original
    choice_display=$(echo "$display_entries" \
        | rofi_open clipboard \
            rofi -dmenu \
                 -theme ~/.config/rofi/clipboard.rasi) || return
 
    # Match display choice back to original entry for decode
    choice_original=$(paste <(echo "$display_entries") <(echo "$entries") \
        | awk -F'\t' -v sel="$choice_display" '$1==sel{print $2"\t"$3; exit}')
 
    echo "$choice_original" | cliphist decode | wl-copy
}
 
rofi_emoji() {
    rofi_open emoji \
        rofimoji \
            --action copy \
            --selector rofi \
            --files emoji symbols kaomoji \
            --skin-tone neutral \
            --hidden-descriptions \
            --selector-args '-theme ~/.config/rofi/emoji.rasi'
}

rofi_screen() {
    # Build menu dynamically — stop option appears only when recording
    local menu=""
    recording_running && menu="󰹙 Stop Recording\0urgent\x1ftrue\n"
    menu+="󰹑 Screenshot Region\n󰹃 Screenshot Full\n󰑊 Record Region\n󰑈 Record Full"
 
    local choice
    choice=$(printf "$menu" \
        | rofi_open screen \
            rofi -dmenu -no-custom \
                 -theme ~/.config/rofi/screen.rasi) || return
 
    case "$choice" in
        *"Stop Recording")    screen_stop_recording    ;;
        *"Screenshot Region") screen_screenshot_region ;;
        *"Screenshot Full")   screen_screenshot_full   ;;
        *"Record Region")     screen_record_region     ;;
        *"Record Full")       screen_record_full       ;;
    esac
}

# -- Dispather
case "$DOMAIN" in
    rofi)
        case "$ACTION" in
            session)   rofi_session   ;;
            launcher)  rofi_launcher  ;;
            clipboard) rofi_clipboard ;;
            emoji)     rofi_emoji     ;;
            screen)    rofi_screen    ;;
            *)
                echo "Usage: nyhud.sh rofi <session|launcher|clipboard|emoji|screen>" >&2
                exit 1
                ;;
        esac
        ;;
    mic)
        case "$ACTION" in
            toggle) mic_toggle ;;
            *)
                echo "Usage: nyhud.sh mic <toggle>" >&2
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Usage: nyhud.sh <rofi|mic> <domain>" >&2
        exit 1
        ;;
esac

