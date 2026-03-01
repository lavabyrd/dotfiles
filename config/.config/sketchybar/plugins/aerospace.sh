#!/bin/sh
. "$CONFIG_DIR/colors.sh"

WS="${NAME#space.}"

if [ "$WS" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" label.color="$ACCENT_COLOR"
else
    sketchybar --set "$NAME" label.color="$OVERLAY_COLOR"
fi
