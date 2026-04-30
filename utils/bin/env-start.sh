#!/bin/bash
TMP=/tmp/startup.log

echo "Startup script..." > $TMP

# Check if we are already in session
if [[ -n "$WAYLAND_DISPLAY" ]] || [[ -n "$DISPLAY" ]]; then
    echo "Already running Display Server" >> $TMP
    exit 1
fi

wait_for_monitor() {
    echo "Detecting display availability..." >> $TMP
    local counter=0

    local card=/dev/dri/card0
    if [[ ! -c "$card" ]]; then
        echo "Primary GPU not detected..." >> $TMP
        return 1
    fi

    while [ $counter -lt 1 ];
    do

        #while IFS=$'\t' read -r id encoder status name size modes encoders; do
        #    if [[ $status == "connected" && $encoder != "0" && $modes != "0"  && $size != "0x0" ]]; then
        #        echo "Found active display. Connector ID: ${id}" >> $TMP
        #        sleep 5
        #        return 0
        #    fi
        #done <  <(modetest -cd | awk -v OFS='\t' '/^Connectors:/ {found=1;next} found && /^[0-9]/ { print $1,$2,$3,$4,$5,$6,$7 }')

        STATUS=$(ddcutil getvcp d6 --terse 2>/dev/null | awk '{print $NF}')
        if [[ "$STATUS" == "x01" ]]; then
            echo "Display is active..." >> $TMP
            sleep 2
            return 0
        fi

        echo "No connected monitors detected, trying again..." >> $TMP

        sleep 0.5
        ((counter++))
    done

    echo "Reached timeout and no display was detected or available. Exiting script and initializing getty..." >> $TMP
    return 1
}

#wait_for_monitor
#ret=$?

#if [[ "$ret" == "1" ]]; then
#    echo "Starting new shell..." >> $TMP
#    exit 1
#fi

echo "Starting hyprland..." >> $TMP

start-hyprland &> /dev/null
