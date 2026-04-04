#!/bin/sh
. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

STATE=$(osascript -e 'tell application "Spotify" to player state' 2>/dev/null)

if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
    TRACK=$(osascript -e '
        tell application "Spotify"
            return artist of current track & " — " & name of current track
        end tell' 2>/dev/null)

    POSITION=$(osascript -e 'tell application "Spotify" to player position' 2>/dev/null)
    DURATION_MS=$(osascript -e 'tell application "Spotify" to duration of current track' 2>/dev/null)

    POS=${POSITION%.*}
    DUR=$(( ${DURATION_MS%.*} / 1000 ))

    BAR="░░░░░░░░░░"
    if [ "${DUR:-0}" -gt 0 ] 2>/dev/null; then
        FILLED=$(( POS * 10 / DUR ))
        BAR=""
        i=0
        while [ $i -lt 10 ]; do
            if [ $i -lt "$FILLED" ]; then BAR="${BAR}▓"; else BAR="${BAR}░"; fi
            i=$(( i + 1 ))
        done
    fi

    if [ "$STATE" = "paused" ]; then
        TRACK_COLOR=$OVERLAY_COLOR
    else
        TRACK_COLOR=$ICON_COLOR
    fi

    sketchybar --set spotify drawing=on icon.color="$GREEN" label="$TRACK" label.color="$TRACK_COLOR"
    sketchybar --set spotify_progress drawing=on label="$BAR"
else
    sketchybar --set spotify drawing=off
    sketchybar --set spotify_progress drawing=off
fi
