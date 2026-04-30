# Project Setup

## Goal
- Keep this repository as a reusable bootstrap source for agent-oriented projects.
- Package and document what gets copied when seeding another repo.

## Status
- Active

## Current Focus
- Keep bootstrap tooling obvious and discoverable from the repo root.

## Next Action
- Run the root bootstrap script when seeding a target repository.

## Key Files
- `bootstrap.sh`: copies `agent-files/AGENTS.md`, `agent-files/CLAUDE.md`, and `agent-files/.agent/` into a target directory. Optionally installs hooks with `--with-hooks`.
- `agent-files/README.md`: package usage notes, file behavior, and hooks reference.
- `agent-files/skills/`: Claude Code skills shipped to every target (e.g. `sync-context`).
- `agent-files/hooks/`: optional Claude Code hooks that enforce `AGENTS.md` rules.
- `.agent/README.md`: internal agent memory index for this repository.

## Quick commands

```bash
./bootstrap.sh <target-dir>
./bootstrap.sh --dry-run <target-dir>
./bootstrap.sh --with-hooks <target-dir>
```
