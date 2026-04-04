#!/bin/sh
. "$CONFIG_DIR/colors.sh"

MIC_ACTIVE=$(ioreg -r -d 1 -c IOAudioEngine 2>/dev/null | grep -c '"IOAudioEngineState" = 1')
CAMERA_ACTIVE=$(lsof 2>/dev/null | grep -cE "AppleCamera|USBVDC")

if [ "$CAMERA_ACTIVE" -gt 0 ] && [ "$MIC_ACTIVE" -gt 0 ]; then
    sketchybar --set "$NAME" drawing=on label="cam+mic" label.color="$RED"
elif [ "$CAMERA_ACTIVE" -gt 0 ]; then
    sketchybar --set "$NAME" drawing=on label="cam" label.color="$RED"
elif [ "$MIC_ACTIVE" -gt 0 ]; then
    sketchybar --set "$NAME" drawing=on label="mic" label.color="$RED"
else
    sketchybar --set "$NAME" drawing=off
fi
