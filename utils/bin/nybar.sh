#!/bin/bash

# Usage: nybar.sh <module>
# Modules: mic, camera, screenrec, bluetooth, network, audio, updates

MODULE="${1:-}"

json () {
    local text="$1" tooltip="${2:-}" class="${3:-}"
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
        "$text" "$tooltip" "$class"
}

mod_mic() {
    local source muted alsa_idx dev icon class

    source=$(pactl get-default-source 2>/dev/null)
    muted=$(pactl get-source-mute "$source" 2>/dev/null | grep -oP '(yes|no)')

    if [[ -z "$source" ]]; then
        json "󰍭" "" "muted"
        return
    fi

    if [[ "$muted" == "yes" ]]; then
        json "󰍭" "" "error"
        return
    fi

    # Map pactl source to ALSA card index, check if anything is capturing
    alsa_idx=$(pactl list sources short | awk -v src="$source" '$2==src{print $1}')
    dev="/dev/snd/pcmC${alsa_idx}D0c"

    if fuser "$dev" &>/dev/null; then
        json "󰍬" "" "active"
    else
        json "󰍬" "" "muted"
    fi
}

mod_camera() {
    if fuser /dev/video* &>/dev/null; then
        json "󰶷" "Camera active" "active"
    else
        json "󱦿" "" "muted"
    fi
}

mod_screenrec() {
    if pgrep -x wf-recorder &>/dev/null; then
        json "󰄙" "Recording screen" "active"
    else
        json "󰞊" "" "muted"
    fi
}

mod_bluetooth() {
    local powered connected_count icon class

    powered=$(bluetoothctl show 2>/dev/null | grep -oP '(?<=Powered: )(yes|no)')

    if [[ "$powered" != "yes" ]]; then
        json "󰂲" "" "muted"
        return
    fi

    connected_count=$(bluetoothctl devices Connected 2>/dev/null | wc -l)

    if (( connected_count > 0 )); then
        icon="󰂱 ${connected_count}"
        class="active"
    else
        icon="󰂯"
        class="active"
    fi

    json "$icon" "" "$class"
}

mod_network() {
    local icon class tooltip

    # Check ethernet first
    local eth_iface
    eth_iface=$(ip link show | grep -oP '(?<=\d: )(eth|enp|eno|ens)\w+' | head -1)

    if [[ -n "$eth_iface" ]] && ip link show "$eth_iface" | grep -q "state UP"; then
        local ip
        ip=$(ip addr show "$eth_iface" | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+' | head -1)
        if [[ -n "$ip" ]]; then
            json "󰈀" "$eth_iface — $ip" "active"
        else
            json "󰈀" "$eth_iface — no IP" "error"
        fi
        return
    fi

    # Check wifi
    local wifi_iface
    wifi_iface=$(ip link show | grep -oP '(?<=\d: )(wlan|wlp)\w+' | head -1)

    if [[ -n "$wifi_iface" ]] && ip link show "$wifi_iface" | grep -q "state UP"; then
        local ip ssid
        ip=$(ip addr show "$wifi_iface" | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+' | head -1)
        ssid=$(iw dev "$wifi_iface" info 2>/dev/null | grep -oP '(?<=ssid ).+')
        if [[ -n "$ip" ]]; then
            json "" "${ssid:-WiFi} — $ip" "active"
        else
            json "" "${ssid:-WiFi} — no IP" "error"
        fi
        return
    fi

    json "󰲛" "No network" "inactive"
}

mod_audio() {
    local sink muted vol icon
 
    sink=$(pactl get-default-sink 2>/dev/null)
    muted=$(pactl get-sink-mute "$sink" 2>/dev/null | grep -oP '(yes|no)')
    vol=$(pactl get-sink-volume "$sink" 2>/dev/null \
        | grep -oP '\d+(?=%)' | head -1)
 
    if [[ "$muted" == "yes" ]]; then
        json "󰝟" "Muted" "muted"
        return
    fi
 
    if   (( vol == 0 ));  then icon="󰕿"
    elif (( vol < 50 ));  then icon="󰖀"
    else                       icon="󰕾"
    fi
 
    json "$icon" "${vol}%" "active"
}

mod_updates() {
    local cache="/tmp/nya-updates"
 
    # Populate cache if missing (Waybar's interval triggers the refresh)
    if [[ ! -f "$cache" ]]; then
        local pac aur
        pac=$(checkupdates 2>/dev/null | wc -l)
        aur=$(yay -Qua 2>/dev/null | wc -l)
        echo "${pac}:${aur}" > "$cache"
    fi
 
    IFS=':' read -r pac aur < "$cache"
    local total=$(( pac + aur ))
 
    if (( total == 0 )); then
        json "󰚰 0" "System up to date" "muted"
    else
        json "󰚰 $total" "pacman: ${pac}  AUR: ${aur}" "warning"
    fi
}


case "$MODULE" in
    mic)       mod_mic       ;;
    camera)    mod_camera    ;;
    screenrec) mod_screenrec ;;
    bluetooth) mod_bluetooth ;;
    network)   mod_network   ;;
    audio)     mod_audio     ;;
    updates)   mod_updates   ;;
    *)
        echo "Usage: nybar.sh <mic|camera|screenrec|bluetooth|network|audio|updates>" >&2
        exit 1
        ;;
esac

