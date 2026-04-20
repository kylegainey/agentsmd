# Agent Operating Instructions

## Project Memory

All project state lives in `.agent/` at the repository root, committed to version control. This is the single source of truth. Override the path via `AGENT_DIR` env var when sharing a memory store across projects.

```
.agent/
├── requirements.md   # what must be built — frozen after planning
├── plan.md           # how we're building it — written before any work
├── changelog.md      # what changed and why — append only
├── decisions.md      # why non-obvious choices were made
├── conventions.md    # code standards — human-managed
├── context.md        # file map and relationships — kept current
└── scratch.md        # session notes — cleared each session
```

On-demand files (load explicitly when needed, not at init):

```
.agent/rotate_changelog.md   # invoke when changelog exceeds ~200 rows
```

---

## Hard Rules

Non-negotiable. No exceptions.

1. **No work without a plan.** If `plan.md` has no unchecked `[ ]` items, stop. Create or update the plan first.
2. **Update records at every step.** Complete the update checklist before moving to the next step.
3. **Re-read before acting.** At the start of each working turn, re-read `plan.md` and `changelog.md`. Do not reason from in-context summaries.
4. **Conflict = stop.** If any two files contradict each other, surface the conflict to the user. Do not resolve it unilaterally.
5. **Requirements freeze at planning.** Do not edit `requirements.md` after planning begins unless the user explicitly requests it.
6. **Changelog is append-only.** Never edit or delete existing entries.
7. **Conventions are human-managed.** Do not write to `conventions.md` without explicit user instruction.
8. **Keep `context.md` current.** Update the file map before moving to the next step whenever a file is created, deleted, moved, or significantly refactored. A stale map is worse than no map.
9. **Verify acceptance before closing a step.** Confirm acceptance criteria are met before marking any step `[x]`.

---

## File Definitions

### `requirements.md`

What the project must accomplish. Written before planning. Frozen once planning begins.

```markdown
# Requirements

## R-01: <Title>
<What must be true. Measurable where possible.>
```

- Numbered `R-NN`. Never renumbered.
- Retired requirements marked `[SUPERSEDED: see R-NN]` — never deleted.

---

### `plan.md`

The active work plan. Must exist with at least one `[ ]` before any project work begins. Written or updated before performing any work.

```markdown
# Plan

STATUS: draft | active | complete
MILESTONE: <name or number>

## Step 1: <Title> [R-NN]
- [ ] Sub-task

**Acceptance:** <Specific, verifiable condition confirming this step is done.>
```

- Each step references requirements via `R-NN`.
- Mark sub-tasks `[x]` only after verifying acceptance criteria are met.
- Do not delete steps — mark complete and move on.
- When all steps are `[x]` and STATUS is `complete`, follow the Milestone Rotation procedure.

---

### `changelog.md`

Append-only audit trail. One entry per logical change, not per file touched.

| Timestamp (UTC) | Commit | What | Why | Files |
|---|---|---|---|---|
| 2026-04-19T14:32Z | `abc1234` | Added auth module | R-04, Step 2 | `src/auth.py` |
| 2026-04-19T15:01Z | `—` | Updated plan step 2 status | Step 2 complete | `.agent/plan.md` |

- Commit: short hash in a git context, otherwise `—`.
- Why: always reference a requirement (`R-NN`), plan step, or explicit user instruction.
- When the table exceeds ~200 rows, invoke `.agent/rotate_changelog.md`.

---

### `decisions.md`

Lightweight ADR log. Captures *why*, not just *what*. Use for any choice a future agent or developer would otherwise have to reverse-engineer.

```markdown
# Decisions

## D-01: <Title>
**Date:** YYYY-MM-DD
**Status:** accepted | superseded by D-NN

**Context:** <What forced a decision.>
**Decision:** <What was decided.>
**Consequences:** <Trade-offs accepted.>
```

- Numbered `D-NN`. Never renumbered.
- Superseded entries updated in-place (`Status` field only) — not deleted.

---

### `conventions.md`

Code conventions and pointers to standards. **Human-managed only.** Agent reads and follows strictly. Agent does not write here without explicit user instruction.

```markdown
# Conventions

## Language / Framework
## Style
## Reference Standards
## Project-Specific Rules
```

---

### `context.md`

File map and relationship index. Exists so the agent can orient itself without reading the whole repo. Must be accurate — staleness is actively harmful.

```markdown
# Project Context

## Overview
<3 sentences max: what this is, what it does, what it explicitly does not do.>

## Entry Points
| Purpose | Path |
|---|---|
| Application entry | `src/main.py` |

## File Map
| Path | Purpose | Owned By | Consumed By |
|---|---|---|---|
| `src/auth.py` | Authentication logic | auth module | `src/api.py`, tests |
| `.agent/` | Project memory | agent | agent |

## Key Relationships
<Non-obvious dependencies, data flows, coupling. Bullets, not prose.>

## Do Not Touch
| Path | Reason |
|---|---|
| `vendor/` | Third-party, not project-owned |
```

- Overview: 3 sentences maximum. This is a map, not documentation.
- Update File Map whenever a file is created, deleted, moved, or significantly refactored.
- Agent may add "Do Not Touch" entries with a clear reason.

---

### `scratch.md`

Session-scoped working notes. Not authoritative. Cleared or archived at the start of each session.

```markdown
## Session: 2026-04-19T14:00Z
<freeform notes>
```

---

## Update Checklist

Run after every action before proceeding to the next step:

- [ ] `plan.md` step status current; acceptance criteria verified before any `[x]`
- [ ] `changelog.md` new entry appended
- [ ] `decisions.md` updated if a non-obvious choice was made
- [ ] `context.md` File Map updated if files were created, deleted, moved, or refactored
- [ ] `requirements.md` updated only if explicitly requested by user
- [ ] `scratch.md` has current session notes

---

## Milestone Rotation

When `plan.md` reaches `STATUS: complete`:

1. Append a 3–5 sentence milestone summary to `.agent/milestones.md` (include milestone name and date).
2. Archive current `plan.md` to `.agent/archive/plan-<milestone>.md`.
3. Reset `plan.md` to empty scaffolding with `STATUS: draft`.
4. Append a rotation entry to `changelog.md`.

---

## Initialization

1. Check if `.agent/` exists. If not, create it with all active files as empty scaffolding.
2. Read all active `.agent/` files before taking any action.
3. At the start of every working turn: re-read `plan.md` and `changelog.md`.
4. If `plan.md` has no `[ ]` items — stop and ask the user what to do next.
5. If `requirements.md` is empty — gather requirements before planning.
6. If files contradict or anything is ambiguous — surface it, do not guess.
