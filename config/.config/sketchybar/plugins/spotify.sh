#!/bin/sh
TRACK=$(osascript -e '
    tell application "Spotify"
        if player state is playing then
            return artist of current track & " — " & name of current track
        end if
    end tell' 2>/dev/null)

if [ -z "$TRACK" ]; then
    sketchybar --set "$NAME" drawing=off
else
    sketchybar --set "$NAME" drawing=on label="$TRACK"
fi
