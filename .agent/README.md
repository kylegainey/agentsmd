# Project Agent Workspace

This repository does not use `AGENTS.md` at the root. All agent-facing
operating memory is under `.agent/`.

## Required files

- `AGENTS.md`: copy template for seeding new project roots.
- `core.md`: 9-step hot loop.
- `current.md`: live turn state.
- `requirements.md`, `plan.md`: requirements and execution plan.
- `changelog.md`: append-only record.
- `decisions.md`, `issues.md`, `lessons-learned.md`: rationale and runtime quality ledger.
- `context.md`, `conventions.md`, `scratch.md`: map, standards, session notes.
- `rotate_changelog.md`: maintenance helper when `changelog.md` grows.

Copy `.agent/AGENTS.md` to another project's root as `AGENTS.md` when seeding it.

## Deployment package

This repo also keeps the full reusable package in `agent-files/`:

- `agent-files/AGENTS.md`
- `agent-files/.agent/`

Use the package command from this repo root when bootstrapping another project:

```bash
cp agent-files/AGENTS.md <new-repo>/AGENTS.md
cp -R agent-files/.agent/. <new-repo>/.agent/
```

or run:

```bash
./bootstrap.sh <new-repo>
```

## Bootstrap rule

If this folder is missing any of the above files, recreate them before any work.
