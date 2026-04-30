# Project Agent Workspace

This repository does not use `AGENTS.md` at the root. All agent-facing
operating memory is under `.agent/`.

## Required files

- `core.md`: 9-step hot loop.
- `current.md`: live turn state.
- `requirements.md`, `plan.md`: requirements and execution plan.
- `changelog.md`: append-only record.
- `decisions.md`, `issues.md`, `lessons-learned.md`: rationale and runtime quality ledger.
- `context.md`, `conventions.md`, `scratch.md`: map, standards, session notes.
- `rotate_changelog.md`: maintenance helper when `changelog.md` grows.

## Deployment package

The reusable templates shipped to other repos live in `agent-files/`:

- `agent-files/AGENTS.md`
- `agent-files/CLAUDE.md`
- `agent-files/.agent/`

Seed a target project with the bootstrap script from this repo root:

```bash
./bootstrap.sh <target-dir>
./bootstrap.sh --dry-run <target-dir>
```

See `agent-files/README.md` for per-file overwrite, warn, and skip behavior.

## Bootstrap rule

If this folder is missing any of the above files, recreate them before any work.
