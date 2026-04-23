# Changelog

| Timestamp (UTC) | Commit | What | Why | Files |
|---|---|---|---|---|
| 2026-04-22T22:22:02Z | `—` | Added .agent memory scaffolding | User request | `.agent/core.md`, `.agent/current.md`, `.agent/requirements.md`, `.agent/plan.md`, `.agent/changelog.md`, `.agent/decisions.md`, `.agent/context.md`, `.agent/issues.md`, `.agent/lessons-learned.md`, `.agent/conventions.md`, `.agent/scratch.md`, `.agent/rotate_changelog.md` |
| 2026-04-22T22:23:33Z | `—` | Removed root AGENTS files, consolidated agent instructions under `.agent/` | User request for deployment safety | `AGENTS.md`, `AGENT_SETUP.md`, `rotate_changelog.md`, `.agent/README.md` |
| 2026-04-22T22:24:42Z | `—` | Reintroduced `AGENTS.md` as portable template inside `.agent/` | User request for easy copy to other projects | `.agent/AGENTS.md` |
| 2026-04-22T22:26:27Z | `—` | Added reusable `copy-to-project` bootstrap package | User request for portable project initialization | `copy-to-project/AGENTS.md`, `copy-to-project/.agent/*`, `copy-to-project/README.md`, `.agent/current.md`, `.agent/context.md`, `.agent/README.md`, `.agent/changelog.md` |
| 2026-04-22T22:26:48Z | `—` | Added `copy-to-project/bootstrap.sh` for direct root bootstrap | User request for easy reuse in this repo and new projects | `copy-to-project/bootstrap.sh`, `copy-to-project/README.md` |
| 2026-04-22T22:27:39Z | `—` | Made bootstrap copy script safe for existing projects | User request to avoid overwriting project-tracking files | `copy-to-project/bootstrap.sh`, `copy-to-project/README.md` |
| 2026-04-22T22:28:16Z | `—` | Refined safe copy boundaries: overwrite boilerplate, protect tracking files | User request on non-destructive copying rules | `copy-to-project/bootstrap.sh`, `copy-to-project/README.md` |
| 2026-04-23T13:37:12Z | `—` | Added dry-run mode to bootstrap script | User request for non-destructive preview before copy | `copy-to-project/bootstrap.sh`, `copy-to-project/README.md`, `copy-to-project/AGENTS.md` |
| 2026-04-23T13:42:36Z | `—` | Renamed reusable bootstrap package and moved script to dedicated directory | User request to separate package and script locations | `copy-to-project` -> `agent-files`, `agent-files/bootstrap/bootstrap.sh`, `agent-files/AGENTS.md`, `.agent/README.md`, `.agent/context.md`, `.agent/current.md` |
| 2026-04-23T13:43:57Z | `—` | Moved bootstrap script to repository root and added project README | User request for simpler script location and project documentation | `bootstrap.sh`, `agent-files/README.md`, `agent-files/AGENTS.md`, `.agent/README.md`, `.agent/context.md`, `.agent/current.md`, `README.md` |
