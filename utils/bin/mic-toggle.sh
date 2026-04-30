#!/usr/bin/env bash
# mic_toggle.sh — Toggle mute on all audio input sources (PipeWire/WirePlumber)
# Uses pw-dump for reliable node discovery and filtering.

# Get all nodes that are audio sources (microphone inputs, not outputs).
# Filter by media.class == "Audio/Source" or "Stream/Input/Audio"
mapfile -t SOURCE_IDS < <(
    pw-dump \
    | jq -r '.[] | select(.type == "PipeWire:Interface:Node")
             | select(
                 .info.props["media.class"] == "Audio/Source" or
                 .info.props["media.class"] == "Audio/Source/Virtual" or
                 .info.props["media.class"] == "Stream/Input/Audio"
               )
             | .id'
)

if [[ ${#SOURCE_IDS[@]} -eq 0 ]]; then
    echo "No audio input sources found." >&2
    exit 1
fi

# Determine the default input source via wpctl
DEFAULT_ID=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null \
    | grep -oP '^\d+' | head -n1)

# Fall back: find the first source marked with * in wpctl status
if [[ -z "$DEFAULT_ID" ]]; then
    DEFAULT_ID=$(wpctl status \
        | awk '/Sources:/,/Filters:|^$/' \
        | grep '\*' \
        | grep -oP '\b[0-9]+\b' \
        | head -n1)
fi

# Final fallback: use the first discovered source
DEFAULT_ID="${DEFAULT_ID:-${SOURCE_IDS[0]}}"

# Check mute state of the default source via pw-dump
MUTED=$(
    pw-dump \
    | jq -r --argjson id "$DEFAULT_ID" \
        '.[] | select(.id == $id) | .info.props["node.mute"] // "false"'
)
MUTED="${MUTED:-false}"

if [[ "$MUTED" == "true" ]]; then
    ACTION="unmute"
    TOGGLE=0
else
    ACTION="mute"
    TOGGLE=1
fi

STATE=$([ "$MUTED" == "true" ] && echo "muted" || echo "unmuted")
echo "Default source (ID $DEFAULT_ID) is $STATE — ${ACTION}ing all input sources..."

# Cache pw-dump output to avoid calling it once per source
PW_DUMP=$(pw-dump)

for ID in "${SOURCE_IDS[@]}"; do
    NAME=$(echo "$PW_DUMP" | jq -r --argjson id "$ID" \
        '.[] | select(.id == $id)
         | .info.props["node.nick"]
           // .info.props["node.description"]
           // .info.props["node.name"]
           // "unknown"')
    wpctl set-mute "$ID" "$TOGGLE"
    echo "  [${ACTION}d] $NAME (ID $ID)"
done

echo "Done."
