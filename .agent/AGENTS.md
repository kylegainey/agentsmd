# AGENTS.md Template for New Projects

Copy this file to a project root as `AGENTS.md` when bootstrapping a new
repository.

## Project Memory

All project state is committed under `.agent/` and is the single source of
truth for agent work.

- `core.md`: tiny hot-path loop
- `current.md`: active step, acceptance, interrupt, and next action
- `requirements.md`: requirements before planning
- `plan.md`: executable plan before any work
- `changelog.md`: append-only change history
- `decisions.md`: why non-obvious choices were made
- `conventions.md`: style and standards (human-owned)
- `context.md`: file map and relationships
- `issues.md`: issue log tied to plan steps
- `lessons-learned.md`: durable operational lessons
- `scratch.md`: session notes
- `rotate_changelog.md`: use when history grows

## Hard Rules

1. No work without a plan: do not start code changes if `plan.md` has no
   unchecked `[ ]` items.
2. Re-read `core.md` and `current.md` at the start of each working turn.
3. Resolve open interrupts before normal plan progress.
4. Verify acceptance before marking any step `[x]`.
5. Log issues immediately and update `issues.md` + `lessons-learned.md`.
6. Keep this file only for workflow instructions that must run every turn.

## Core Templates

Use concise versions from your `README.md`-style bootstrap and keep file
templates aligned with your repository conventions.

- `core.md` and `current.md` should stay short and skimmable.
- `changelog.md` is append-only.
- `issues.md` entries should be tied to one plan step.

## Startup

When beginning work in a new session:

- Read `core.md`, `current.md`, `plan.md`, `issues.md`, and
  `lessons-learned.md`.
- If `plan.md` has no open tasks, stop and ask for direction.
- If files contradict one another, surface the conflict and stop.
