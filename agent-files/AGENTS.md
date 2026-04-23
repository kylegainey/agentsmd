# AGENTS.md

## Project Memory

- Keep all agent workflow state in `./.agent/` (required files listed below).
- Use compact, requirement-sized entries in workflow files.
- Keep `changelog.md` append-only.

## Required `.agent/` files

- `core.md`: per-turn control loop
- `current.md`: live state
- `requirements.md`: requirements list
- `plan.md`: execution plan with unchecked tasks
- `changelog.md`: append-only history
- `decisions.md`: non-obvious choices
- `conventions.md`: standards and rules
- `context.md`: file map and relationships
- `issues.md`: issue log
- `lessons-learned.md`: repeated lessons
- `scratch.md`: session notes
- `rotate_changelog.md`: archive helper

## Startup checks

1. Read `.agent/core.md` and `.agent/current.md`.
2. Read `.agent/plan.md`, `.agent/issues.md`, and `.agent/lessons-learned.md`.
3. Start work only with at least one unchecked item in `.agent/plan.md`.

## File protection

- Do not overwrite project tracking files like `.agent/current.md`,
  `.agent/requirements.md`, `.agent/plan.md`, `.agent/changelog.md`,
  `.agent/decisions.md`, `.agent/issues.md`, `.agent/lessons-learned.md`,
  `.agent/context.md`, `.agent/conventions.md`, or `.agent/scratch.md`
  unless explicitly instructed.
- Keep history files append-only.
