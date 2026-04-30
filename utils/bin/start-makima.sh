#!/bin/bash
CMD="makima"

notify_error(){
    notify-send -u critical "Makima Error" "$1"
}

if [ -z "$1" ]; then
    if pgrep -x "$CMD" > /dev/null; then
        echo "1"
    else
        echo "0"
    fi
    exit 0
fi

if [ "$1" == "1" ]; then
    pkill -x "$CMD" 2>/dev/null
    sleep 0.2

    TMP_LOG=$(mktemp)
    
    "$CMD" > /dev/null 2> "$TMP_LOG" &
    PID=$!

    sleep 0.5

    if ! kill -0 $PID 2>/dev/null; then
        notify_error "Failed to start: $(cat $TMP_LOG)"
        rm "$TMP_LOG"
        exit 1
    else
        rm "$TMP_LOG"
        notify-send "Makima Controller" "Mouse Mode Enabled"
        exit 0
    fi
fi

if [ "$1" == "0" ]; then
    pkill -x "$CMD" 2>/dev/null
    notify-send "Makima Controller" "Mouse Mode Disabled"
    exit 0
fi

# Invalid argument handler
echo "Usage: $0 [0|1] (or empty for status)"
exit 1
