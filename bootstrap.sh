#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
WITH_HOOKS=0

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [--dry-run] [--with-hooks] [<target-dir>]

Copies the template AGENTS.md, CLAUDE.md, and .agent skeleton into <target-dir>.

Options:
  --dry-run     Show copy decisions without writing files.
  --with-hooks  Also install Claude Code hooks (changelog-append,
                plan-gate, inject-context) into <target-dir>/.claude/.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --with-hooks)
      WITH_HOOKS=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -n "${DEST_DIR-}" ]]; then
        printf 'error: unexpected argument: %s\n' "$1" >&2
        usage >&2
        exit 1
      fi
      DEST_DIR="$1"
      shift
      ;;
  esac
done

DEST_DIR="${DEST_DIR:-.}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$SCRIPT_DIR/agent-files"
TEMPLATE_DIR="$PACKAGE_DIR/.agent"
HOOKS_DIR="$PACKAGE_DIR/hooks"
SKILLS_DIR="$PACKAGE_DIR/skills"
DEST_AGENT_DIR="$DEST_DIR/.agent"
DEST_CLAUDE_DIR="$DEST_DIR/.claude"
DEST_HOOKS_DIR="$DEST_CLAUDE_DIR/hooks"
DEST_SKILLS_DIR="$DEST_CLAUDE_DIR/skills"
DEST_SETTINGS="$DEST_CLAUDE_DIR/settings.json"

overwrite_allowed=(
  "AGENTS.md"
  ".agent/core.md"
  ".agent/README.md"
  ".agent/rotate_changelog.md"
)

warn_if_exists=(
  "CLAUDE.md"
)

track_files=(
  ".agent/current.md"
  ".agent/requirements.md"
  ".agent/plan.md"
  ".agent/changelog.md"
  ".agent/decisions.md"
  ".agent/context.md"
  ".agent/issues.md"
  ".agent/lessons-learned.md"
  ".agent/conventions.md"
  ".agent/scratch.md"
)

is_in_list() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

copy_if_allowed() {
  local src="$1"
  local dst="$2"
  local rel="$3"

  if [[ -f "$dst" ]]; then
    if is_in_list "$rel" "${track_files[@]}"; then
      printf 'skip (tracking): %s\n' "$rel"
      return 0
    fi

    if is_in_list "$rel" "${warn_if_exists[@]}"; then
      if (( DRY_RUN )); then
        printf 'warn (dry-run): %s exists, not overwritten\n' "$rel"
      else
        printf 'warn: %s exists, not overwritten\n' "$rel"
      fi
      return 0
    fi

    if is_in_list "$rel" "${overwrite_allowed[@]}"; then
      if (( DRY_RUN )); then
        printf 'overwrite (dry-run): %s\n' "$rel"
      else
        mkdir -p "$(dirname "$dst")"
        cp "$src" "$dst"
        printf 'overwrite: %s\n' "$rel"
      fi
      return 0
    fi

    printf 'skip: %s\n' "$rel"
    return 0
  fi

  if (( DRY_RUN )); then
    printf 'copy (dry-run): %s\n' "$rel"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  printf 'copy: %s\n' "$rel"
}

if (( ! DRY_RUN )); then
  mkdir -p "$DEST_DIR" "$DEST_AGENT_DIR"
fi

while IFS= read -r -d '' src_file; do
  rel_path="${src_file#$TEMPLATE_DIR/}"
  copy_if_allowed "$src_file" "$DEST_AGENT_DIR/$rel_path" ".agent/$rel_path"
done < <(find "$TEMPLATE_DIR" -type f -print0)

copy_if_allowed "$PACKAGE_DIR/AGENTS.md" "$DEST_DIR/AGENTS.md" "AGENTS.md"
copy_if_allowed "$PACKAGE_DIR/CLAUDE.md" "$DEST_DIR/CLAUDE.md" "CLAUDE.md"

install_hook_script() {
  local src="$1"
  local rel
  rel=".claude/hooks/$(basename "$src")"
  local dst="$DEST_DIR/$rel"

  if (( DRY_RUN )); then
    if [[ -f "$dst" ]]; then
      printf 'overwrite (dry-run): %s\n' "$rel"
    else
      printf 'copy (dry-run): %s\n' "$rel"
    fi
    return 0
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  chmod +x "$dst"
  if [[ -f "$dst" ]]; then
    printf 'install: %s\n' "$rel"
  fi
}

install_settings() {
  local fragment="$HOOKS_DIR/settings.fragment.json"
  local rel=".claude/settings.json"

  if [[ ! -f "$DEST_SETTINGS" ]]; then
    if (( DRY_RUN )); then
      printf 'copy (dry-run): %s\n' "$rel"
      return 0
    fi
    mkdir -p "$DEST_CLAUDE_DIR"
    cp "$fragment" "$DEST_SETTINGS"
    printf 'install: %s\n' "$rel"
    return 0
  fi

  if jq -e '._agentHooks' "$DEST_SETTINGS" >/dev/null 2>&1; then
    printf 'skip (hooks already installed): %s\n' "$rel"
    return 0
  fi

  if (( DRY_RUN )); then
    printf 'merge (dry-run): %s\n' "$rel"
    return 0
  fi

  local tmp
  tmp="$(mktemp)"
  jq -s '.[0] * .[1]' "$DEST_SETTINGS" "$fragment" >"$tmp"
  mv "$tmp" "$DEST_SETTINGS"
  printf 'merge: %s\n' "$rel"
}

install_hooks() {
  if ! command -v jq >/dev/null 2>&1; then
    printf 'error: --with-hooks requires jq, not found in PATH\n' >&2
    exit 1
  fi

  if (( ! DRY_RUN )); then
    mkdir -p "$DEST_HOOKS_DIR"
  fi

  while IFS= read -r -d '' src; do
    install_hook_script "$src"
  done < <(find "$HOOKS_DIR" -maxdepth 1 -type f -name '*.sh' -print0)

  install_settings
}

install_skill_file() {
  local src="$1"
  local rel="${src#$SKILLS_DIR/}"
  local label=".claude/skills/$rel"
  local dst="$DEST_SKILLS_DIR/$rel"

  if (( DRY_RUN )); then
    if [[ -f "$dst" ]]; then
      printf 'overwrite (dry-run): %s\n' "$label"
    else
      printf 'copy (dry-run): %s\n' "$label"
    fi
    return 0
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  printf 'install: %s\n' "$label"
}

install_skills() {
  if [[ ! -d "$SKILLS_DIR" ]]; then
    return 0
  fi

  while IFS= read -r -d '' src; do
    install_skill_file "$src"
  done < <(find "$SKILLS_DIR" -type f -print0)
}

install_skills

if (( WITH_HOOKS )); then
  install_hooks
fi

if (( DRY_RUN )); then
  printf 'Dry-run complete for %s\n' "$DEST_DIR"
else
  printf 'Bootstrap copied to %s\n' "$DEST_DIR"
fi
