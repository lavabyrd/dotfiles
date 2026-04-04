#!/bin/sh
. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

TITLE=$(nowplaying-cli get title 2>/dev/null)
ARTIST=$(nowplaying-cli get artist 2>/dev/null)
RATE=$(nowplaying-cli get playbackRate 2>/dev/null)
BUNDLE=$(nowplaying-cli get appBundleIdentifier 2>/dev/null)

if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
    sketchybar --set nowplaying drawing=off
    sketchybar --set nowplaying_progress drawing=off
    exit 0
fi

if [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ]; then
    LABEL="$ARTIST — $TITLE"
else
    LABEL="$TITLE"
fi

case "$BUNDLE" in
    com.spotify.client)  ICON="$ICON_SPOTIFY"; COLOR="$GREEN" ;;
    com.apple.Music)     ICON="󰎆";             COLOR="$RED"   ;;
    *)                   ICON="󰝚";             COLOR="$BLUE"  ;;
esac

ELAPSED=$(nowplaying-cli get elapsedTime 2>/dev/null)
DURATION=$(nowplaying-cli get duration 2>/dev/null)

BAR="░░░░░░░░░░"
if [ -n "$ELAPSED" ] && [ "$ELAPSED" != "null" ] && [ -n "$DURATION" ] && [ "$DURATION" != "null" ]; then
    DUR_INT=${DURATION%.*}
    ELA_INT=${ELAPSED%.*}
    if [ "${DUR_INT:-0}" -gt 0 ] 2>/dev/null; then
        FILLED=$(( ELA_INT * 10 / DUR_INT ))
        BAR=""
        i=0
        while [ $i -lt 10 ]; do
            if [ $i -lt "$FILLED" ]; then BAR="${BAR}▓"; else BAR="${BAR}░"; fi
            i=$(( i + 1 ))
        done
    fi
fi

if [ "$RATE" = "0" ] || [ "$RATE" = "0.0" ]; then
    LABEL_COLOR=$OVERLAY_COLOR
else
    LABEL_COLOR=$ICON_COLOR
fi

sketchybar --set nowplaying \
    drawing=on \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="$LABEL" \
    label.color="$LABEL_COLOR"

sketchybar --set nowplaying_progress drawing=on label="$BAR"
