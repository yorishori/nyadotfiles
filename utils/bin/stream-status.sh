#!/bin/bash

get_json() {
    local STREAMS="$1"
    local ICON_ACTIVE="$2"
    local ICON_IDLE="$3"
    local LABEL="$4"
    local COUNT=$(echo "$STREAMS" | jq 'length')

    if [ "$COUNT" -gt 0 ]; then
        APPS=$(echo "$STREAMS" | jq -r 'join(", ")')
        echo "{\"text\":\"$ICON_ACTIVE\",\"class\":\"active\",\"tooltip\":\"$LABEL: $APPS\"}"
    else
        echo "{\"text\":\"$ICON_IDLE\",\"class\":\"\",\"tooltip\":\"$LABEL idle\"}"
    fi
}

S=$(pw-dump)

if [ $1 -eq 1 ]; then
    MIC=$(echo "$S" | jq '
    [
        .[] 
        | select(
            .type == "PipeWire:Interface:Node" 
            and .info.props["media.class"] == "Stream/Input/Audio") 
        | .info.props["application.name"]
    ] | unique')

    get_json "$MIC" "󰍬" "󰍭" "Mic"
    
elif [ $1 -eq 2 ]; then
    CAM=$(echo "$S" | jq '
    [
        .[]
        | select(
            .type == "PipeWire:Interface:Node"
            and .info.props["media.class"] == "Video/Source"
            and .info.props["media.role"] == "Camera"
            and .info.state == "running"
        )
        | .info.props["application.name"]
    ] | unique')
    
    C=$(echo "$CAM" | jq 'length')
    
    if [ "$C" -lt 1 ]; then
        PIDS=$(fuser /dev/video* 2>/dev/null)
    
        if [[ -n "$PIDS" ]]; then
            CAM=$(ps -o comm= -p $PIDS | sort -u | jq -R . | jq -s .)
        fi
    fi
    
    get_json "$CAM" "󰶷" "󱦿" "Webcam"

elif [ $1 -eq 3 ]; then
    SRC="[]"
    if pgrep -x "wf-recorder" &>/dev/null; then
        SRC="[\"wf-recorder\"]"
    fi
    get_json "$SRC" "󰄙" "󰞊" "Screen recording"

else 
    echo "{\"text\":\"ERROR\",\"class\":\"active\",\"tooltip\":\"Not a valid input.\"}"
fi


