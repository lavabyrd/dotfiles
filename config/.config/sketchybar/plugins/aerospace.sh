#!/bin/sh
. "$CONFIG_DIR/colors.sh"

WS="${NAME#space.}"
WIN_COUNT=$(aerospace list-windows --workspace "$WS" 2>/dev/null | wc -l | tr -d ' ')
CURRENT=${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null | tr -d ' ')}

if [ "$WS" = "$CURRENT" ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        icon.color="$BAR_COLOR" \
        background.drawing=on \
        background.color="$ACCENT_COLOR" \
        background.corner_radius=4 \
        background.height=22
elif [ "$WIN_COUNT" -gt 0 ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        icon.color="$OVERLAY_COLOR" \
        background.drawing=off
else
    sketchybar --set "$NAME" drawing=off
fi
