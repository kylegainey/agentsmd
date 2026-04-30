#!/usr/bin/env bash
set -euo pipefail

# PreToolUse(Write|Edit) hook: enforce append-only on .agent/changelog.md.
# Bypass with AGENT_ALLOW_NONAPPEND=1.

input=$(cat)

tool_name=$(printf '%s' "$input" | jq -r '.tool_name // ""')
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')

case "$file_path" in
  *.agent/changelog.md) ;;
  *) exit 0 ;;
esac

if [ "${AGENT_ALLOW_NONAPPEND:-0}" = "1" ]; then
  exit 0
fi

block() {
  local reason="$1"
  jq -n --arg r "$reason" '{decision:"block", reason:$r}'
  exit 2
}

case "$tool_name" in
  Write)
    block ".agent/changelog.md is append-only; Write would overwrite history. Use Edit to append, or set AGENT_ALLOW_NONAPPEND=1 if the user explicitly asked for a rewrite."
    ;;
  Edit)
    old=$(printf '%s' "$input" | jq -r '.tool_input.old_string // ""')
    new=$(printf '%s' "$input" | jq -r '.tool_input.new_string // ""')

    if [ ! -f "$file_path" ]; then
      exit 0
    fi

    current=$(cat "$file_path")

    len_old=${#old}
    len_current=${#current}
    len_new=${#new}

    if [ "$len_old" -gt "$len_current" ]; then
      block ".agent/changelog.md edit rejected: old_string is not a suffix of the file. Append-only edits must target the tail of the file."
    fi

    suffix_start=$((len_current - len_old))
    if [ "${current:$suffix_start}" != "$old" ]; then
      block ".agent/changelog.md edit rejected: old_string is not a suffix of the file. Append-only edits must target the tail of the file."
    fi

    if [ "$len_new" -lt "$len_old" ] || [ "${new:0:$len_old}" != "$old" ]; then
      block ".agent/changelog.md edit rejected: new_string must start with old_string verbatim (additions go after, not before or instead)."
    fi
    ;;
esac

exit 0
