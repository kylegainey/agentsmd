#!/usr/bin/env bash
set -euo pipefail

# UserPromptSubmit hook: prepend .agent/core.md and .agent/current.md to the
# turn so the agent re-reads them, per agent-files/AGENTS.md.

root="${CLAUDE_PROJECT_DIR:-$PWD}"

emit() {
  local tag="$1"
  local file="$2"
  if [ -f "$file" ]; then
    printf '<%s>\n' "$tag"
    cat "$file"
    printf '\n</%s>\n' "$tag"
  fi
}

emit agent-core "$root/.agent/core.md"
emit agent-current "$root/.agent/current.md"

exit 0
