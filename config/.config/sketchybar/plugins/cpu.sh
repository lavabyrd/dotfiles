#!/bin/sh
. "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/icons.sh"

CPU=$(top -l 1 -n 0 | awk '/CPU usage/ {gsub(/%,?/, "", $3); print $3}')

PAGE_SIZE=$(pagesize)
PAGES_ACTIVE=$(vm_stat | awk '/^Pages active:/ {gsub(/\./, "", $NF); print $NF+0}')
PAGES_WIRED=$(vm_stat | awk '/^Pages wired down:/ {gsub(/\./, "", $NF); print $NF+0}')
PAGES_COMPRESSED=$(vm_stat | awk '/^Pages occupied by compressor:/ {gsub(/\./, "", $NF); print $NF+0}')
RAM_GB=$(awk "BEGIN {printf \"%.1f\", ($PAGES_ACTIVE + $PAGES_WIRED + $PAGES_COMPRESSED) * $PAGE_SIZE / 1073741824}")

CPU_INT=${CPU%.*}
if [ "${CPU_INT:-0}" -gt 80 ] 2>/dev/null; then
    COLOR=$RED
elif [ "${CPU_INT:-0}" -gt 50 ] 2>/dev/null; then
    COLOR=$YELLOW
else
    COLOR=$ICON_COLOR
fi

sketchybar --set "$NAME" icon.color="$COLOR" label="${CPU}% ${RAM_GB}G"
