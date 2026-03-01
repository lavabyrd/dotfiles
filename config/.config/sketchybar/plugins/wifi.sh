#!/bin/sh
. "$CONFIG_DIR/icons.sh"

INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
SSID=$(networksetup -getairportnetwork "$INTERFACE" 2>/dev/null | awk -F': ' '{print $2}')

if [ -z "$SSID" ] || [ "$SSID" = "You are not associated with an AirPort network." ]; then
    sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" label="offline"
else
    sketchybar --set "$NAME" icon="$ICON_WIFI" label="$SSID"
fi
