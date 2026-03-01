#!/bin/sh
. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -c 'AC Power')

if [ "$CHARGING" -gt 0 ]; then
    ICON=$ICON_BATTERY_CHARGING
    COLOR=$GREEN
elif [ "$PERCENTAGE" -ge 80 ]; then
    ICON=$ICON_BATTERY_FULL
    COLOR=$GREEN
elif [ "$PERCENTAGE" -ge 60 ]; then
    ICON=$ICON_BATTERY_HIGH
    COLOR=$GREEN
elif [ "$PERCENTAGE" -ge 40 ]; then
    ICON=$ICON_BATTERY_MED
    COLOR=$YELLOW
elif [ "$PERCENTAGE" -ge 20 ]; then
    ICON=$ICON_BATTERY_LOW
    COLOR=$YELLOW
else
    ICON=$ICON_BATTERY_CRITICAL
    COLOR=$RED
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="${PERCENTAGE}%"
