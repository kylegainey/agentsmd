#!/usr/bin/env bash
set -euo pipefail

# PreToolUse(Write|Edit) hook: block code edits when .agent/plan.md has no
# unchecked `- [ ]` items. Tracking edits inside .agent/ are always allowed.
# Bypass with AGENT_BYPASS_PLAN_GATE=1.

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')

if [ -z "$file_path" ]; then
  exit 0
fi

case "$file_path" in
  */.agent/*|.agent/*) exit 0 ;;
esac

if [ "${AGENT_BYPASS_PLAN_GATE:-0}" = "1" ]; then
  exit 0
fi

root="${CLAUDE_PROJECT_DIR:-$PWD}"
plan="$root/.agent/plan.md"

if [ ! -f "$plan" ]; then
  exit 0
fi

unchecked=$(grep -cE '^- \[ \]' "$plan" || true)

if [ "${unchecked:-0}" -gt 0 ]; then
  exit 0
fi

jq -n --arg p "$plan" '{
  decision: "block",
  reason: ("plan-gate: " + $p + " has no unchecked `- [ ]` items. Add a plan step (or set AGENT_BYPASS_PLAN_GATE=1 if the user explicitly authorized work without a plan).")
}'
exit 2
