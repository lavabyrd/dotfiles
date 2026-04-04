#!/bin/sh
WEATHER=$(curl -sf --max-time 5 "https://wttr.in/?format=%c+%t" 2>/dev/null)
if [ -n "$WEATHER" ]; then
    sketchybar --set "$NAME" drawing=on label="$WEATHER"
else
    sketchybar --set "$NAME" drawing=off
fi
