#!/bin/sh
BADGE=$(lsappinfo info -only StatusLabel com.tinyspeck.slackmacgap 2>/dev/null \
    | grep -o '"label"="[^"]*"' \
    | grep -o '"[^"]*"$' \
    | tr -d '"')

if [ -z "$BADGE" ]; then
    sketchybar --set "$NAME" drawing=off
else
    sketchybar --set "$NAME" drawing=on label="$BADGE"
fi
