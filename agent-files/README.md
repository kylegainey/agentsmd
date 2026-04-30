# Agent Workspace Package

This package seeds a project root with these files:

- `AGENTS.md`
- `CLAUDE.md`
- `.agent/`

Use the accompanying bootstrap tooling or copy the files into the target
project root manually.

## File behavior

### Always overwritten

- `AGENTS.md`
- `.agent/core.md`
- `.agent/README.md`
- `.agent/rotate_changelog.md`

### Warn and keep existing

- `CLAUDE.md`

### Never overwritten

- `.agent/current.md`
- `.agent/requirements.md`
- `.agent/plan.md`
- `.agent/changelog.md`
- `.agent/decisions.md`
- `.agent/context.md`
- `.agent/issues.md`
- `.agent/lessons-learned.md`
- `.agent/conventions.md`
- `.agent/scratch.md`

## Skills (always shipped)

Bootstrap always copies `agent-files/skills/*` into `<target>/.claude/skills/`.
Skills are documentation/instruction files Claude Code surfaces by name and by
description-based routing.

| Skill | What it does |
|---|---|
| `sync-context` | Surveys the project and reconciles `.agent/context.md` (Overview, Entry Points, File Map, Key Agent Files, Do Not Touch). Diffs proposed changes inline and waits for `apply` before writing. Preserves `Key Relationships` and any free-form prose. Invokable as `/sync-context` or model-routed when context.md looks stale. |

Skill files are always overwritten on re-bootstrap (they're code).

## Hooks (optional)

Pass `--with-hooks` to install Claude Code hooks that mechanically enforce
parts of `AGENTS.md`. Scripts land in `<target>/.claude/hooks/`, and
`<target>/.claude/settings.json` is created or merged.

| Hook | Event | Enforces | Bypass env var |
|---|---|---|---|
| `changelog-append.sh` | `PreToolUse(Write\|Edit)` | `.agent/changelog.md` is append-only | `AGENT_ALLOW_NONAPPEND=1` |
| `plan-gate.sh` | `PreToolUse(Write\|Edit)` | edits outside `.agent/` require an unchecked `- [ ]` item in `.agent/plan.md` | `AGENT_BYPASS_PLAN_GATE=1` |
| `inject-context.sh` | `UserPromptSubmit` | re-surfaces `.agent/core.md` and `.agent/current.md` each turn | n/a (additive only) |
| `inject-project-map.sh` | `SessionStart` | surfaces `.agent/context.md` once per session (project file map, entry points, Do Not Touch) | n/a (additive only) |

### Install behavior

- Hook scripts are **always overwritten** on re-bootstrap (they're code).
- `settings.json`:
  - Missing → seeded from `agent-files/hooks/settings.fragment.json`.
  - Already contains `_agentHooks` sentinel → skipped (idempotent).
  - Exists without sentinel → deep-merged with the fragment via `jq`,
    preserving existing keys (e.g. `permissions`).

Requires `jq` on `PATH`.

## Source

This package is maintained in the `project-setup` bootstrap repository.
