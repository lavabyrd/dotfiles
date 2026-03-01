#!/bin/sh
case "$NAME" in
  clock) sketchybar --set "$NAME" label="$(date '+%H:%M')" ;;
  date)  sketchybar --set "$NAME" label="$(date '+%a %b %-d')" ;;
esac
