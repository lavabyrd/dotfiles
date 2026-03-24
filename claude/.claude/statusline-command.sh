#!/bin/sh

input=$(cat)
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

cwd=$(echo "$cwd" | sed "s|^$HOME|~|")
out=""
[ -n "$ctx" ] && out="$(printf '%.0f' "$ctx")% ctx"
[ -n "$cost" ] && out="$out | \$$(printf '%.2f' "$cost")"
[ -n "$model" ] && out="$out | $model"
[ -n "$cwd" ] && out="$out | $cwd"
echo "${out# | }"
