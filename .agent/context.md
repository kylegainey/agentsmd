# Project Context

## Overview
<3 sentences max: what this project does, what it does not do, and project boundaries.>

## Entry Points
| Purpose | Path |
|---|---|

## File Map
| Path | Purpose | Owned By | Consumed By |
|---|---|---|---|
| `.agent/` | Project memory | agent | agent |

## Key Agent Files

- `agent-files/AGENTS.md`: portable root template for new repos.
- `agent-files/.agent/`: starter `.agent/` skeleton for new repos.
- `agent-files/README.md`: deployment instructions for the template package.
- `bootstrap.sh`: script to copy template files into a target root.
- `.agent/AGENTS.md`: portable root `AGENTS.md` template for other projects.
- `.agent/README.md`: bootstrap and file-index for this project.
- `.agent/core.md`: compact workflow loop.
- `.agent/current.md`: live step state.
- `.agent/requirements.md`: requirement definitions.
- `.agent/plan.md`: execution plan.
- `.agent/changelog.md`: append-only change log.
- `.agent/decisions.md`: durable decision notes.
- `.agent/context.md`: this file map.
- `.agent/issues.md`: issue log.
- `.agent/lessons-learned.md`: issue-derived lessons.
- `.agent/conventions.md`: style and standards.
- `.agent/scratch.md`: session notes.
- `.agent/rotate_changelog.md`: changelog maintenance.

## Key Relationships
- <Important dependencies and data flows>

## Do Not Touch
| Path | Reason |
|---|---|
