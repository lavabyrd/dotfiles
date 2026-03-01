#!/bin/sh
. "$CONFIG_DIR/colors.sh"

WS="${NAME#space.}"
WIN_COUNT=$(aerospace list-windows --workspace "$WS" 2>/dev/null | wc -l | tr -d ' ')
CURRENT=${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null | tr -d ' ')}

if [ "$WS" = "$CURRENT" ]; then
    sketchybar --set "$NAME" drawing=on label.color="$ACCENT_COLOR"
elif [ "$WIN_COUNT" -gt 0 ]; then
    sketchybar --set "$NAME" drawing=on label.color="$OVERLAY_COLOR"
else
    sketchybar --set "$NAME" drawing=off
fi
