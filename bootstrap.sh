#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [--dry-run] [<target-dir>]

Copies the template AGENTS.md, CLAUDE.md, and .agent skeleton into <target-dir>.

Options:
  --dry-run   Show copy decisions without writing files.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
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
DEST_AGENT_DIR="$DEST_DIR/.agent"

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

if (( DRY_RUN )); then
  printf 'Dry-run complete for %s\n' "$DEST_DIR"
else
  printf 'Bootstrap copied to %s\n' "$DEST_DIR"
fi
