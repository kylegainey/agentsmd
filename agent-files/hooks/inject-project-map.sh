#!/usr/bin/env bash
set -euo pipefail

# SessionStart hook: surface .agent/context.md once per session so the agent
# starts with the project file map, entry points, and Do Not Touch list.

root="${CLAUDE_PROJECT_DIR:-$PWD}"
context="$root/.agent/context.md"

if [ ! -f "$context" ]; then
  exit 0
fi

printf '<agent-context>\n'
cat "$context"
printf '\n</agent-context>\n'

exit 0
