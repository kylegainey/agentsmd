# AGENTS.md Template for New Projects

Copy this file to a project root as `AGENTS.md`.

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

1. Read `core.md` and `current.md`.
2. Read `plan.md`, `issues.md`, and `lessons-learned.md`.
3. Start work only with at least one unchecked item in `plan.md`.

## Bootstrap behavior

- Copying this package into an existing repo should never overwrite project
  tracking files like `current.md`, `requirements.md`, `plan.md`, `changelog.md`,
  `decisions.md`, `issues.md`, `lessons-learned.md`, `context.md`,
  `conventions.md`, or `scratch.md`.
- Boilerplate files (for example `AGENTS.md` and `.agent/README.md`) may be
  replaced intentionally.
- Use `./bootstrap.sh --dry-run <target>` to preview what will be
  copied before changing any files.
