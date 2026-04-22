#!/bin/bash
TIMEOUT=15
TS_FILE="/tmp/sketchybar_claude_notify_ts"

case "$SENDER" in
    claude_notification)
        date +%s > "$TS_FILE"
        sketchybar --set claude_notify label="$INFO" drawing=on
        ;;
    routine)
        [ -f "$TS_FILE" ] || exit 0
        LAST=$(cat "$TS_FILE")
        NOW=$(date +%s)
        if [ $((NOW - LAST)) -gt $TIMEOUT ]; then
            sketchybar --set claude_notify drawing=off
            rm -f "$TS_FILE"
        fi
        ;;
esac
