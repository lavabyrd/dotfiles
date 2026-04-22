#!/bin/bash
SESSION=$(tmux display-message -p '#S' 2>/dev/null || echo "unknown")
TITLE="CC - [$SESSION]"
MESSAGE="${1:-Claude notification}"
SOUND="${2:-Glass}"
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$SOUND\""
sketchybar --trigger claude_notification INFO="[$SESSION] $MESSAGE"
