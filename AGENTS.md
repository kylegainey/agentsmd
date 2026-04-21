# Agent Operating Instructions

## Project Memory

All project state lives in `.agent/` at the repository root and is committed to version control. It is the single source of truth. Override the path with `AGENT_DIR` when sharing one memory store across projects.

```
.agent/
├── requirements.md   # what must be built — frozen after planning
├── plan.md           # how we're building it — written before any work
├── changelog.md      # what changed and why — append only
├── decisions.md      # why non-obvious choices were made
├── conventions.md    # code standards — human-managed
├── context.md        # file map and relationships — kept current
├── issues.md         # issue log tied to plan steps
├── lessons-learned.md # durable lessons read every session
└── scratch.md        # session notes — cleared each session
```

On-demand files (load only when needed, not at init):

```
.agent/rotate_changelog.md   # invoke when changelog exceeds ~200 rows
```

---

## Hard Rules

Non-negotiable. No exceptions.

1. **No work without a plan.** If `plan.md` has no unchecked `[ ]` items, stop. Create or update the plan first.
2. **Update records at every step.** Complete the update checklist before the next step.
3. **Re-read before acting.** At the start of each working turn, re-read `plan.md`, `changelog.md`, `issues.md`, and `lessons-learned.md`. Do not rely on in-context summaries.
4. **Conflict = stop.** If any two files contradict each other, surface the conflict to the user. Do not resolve it unilaterally.
5. **Requirements freeze at planning.** Do not edit `requirements.md` after planning begins unless the user explicitly requests it.
6. **Changelog is append-only.** Never edit or delete existing entries.
7. **Conventions are human-managed.** Do not write to `conventions.md` without explicit user instruction.
8. **Keep `context.md` current.** Update the file map before the next step whenever a file is created, deleted, moved, or significantly refactored. A stale map is worse than none.
9. **Log issues immediately.** Any issue, regression, blocker, or missed instruction must be recorded in `issues.md` and linked to a specific plan step before moving on.
10. **Capture the miss clearly.** Every issue entry must record whether the miss was `llm`- or `user`-related and what detail was missed.
11. **Update lessons immediately.** After logging an issue, update `lessons-learned.md` by adding a new lesson or revising the closest existing one.
12. **Verify acceptance before closing a step.** Confirm acceptance criteria are met before marking any step `[x]`.
13. **Resume work after startup.** Once session-start reads are complete, continue with the next incomplete interrupt or plan step unless the user asked only for status, planning, or clarification.
14. **Interrupts must be explicit.** If a new issue or concern must preempt current work, update `plan.md` first with an interrupt entry that identifies the paused step and where work should resume.
15. **Split broad steps.** If a step requires multiple independent validations, split it into separate steps before continuing.
16. **Re-plan on growth.** If a step expands materially during execution, update `plan.md` before continuing.

---

## File Definitions

### `requirements.md`

What must be true. Written before planning and frozen once planning begins.

```markdown
# Requirements

## R-01: <Title>
<What must be true. Measurable where possible.>
```

- Numbered `R-NN`. Never renumbered.
- Retired requirements marked `[SUPERSEDED: see R-NN]` — never deleted.

---

### `plan.md`

Active work plan. It must contain at least one unchecked `[ ]` before any project work begins, and it must be updated before work starts.

```markdown
# Plan

STATUS: draft | active | complete
MILESTONE: <name or number>

## Interrupts

### Interrupt 1: <Title> [R-NN]
**Pauses:** Step <N> [R-NN]
- [ ] Sub-task

**Acceptance:** <Specific, verifiable condition confirming this interrupt is done.>

## Step 1: <Title> [R-NN]
- [ ] Sub-task

**Acceptance:** <Specific, verifiable condition confirming this step is done.>
```

- Each step references requirements via `R-NN`.
- Use the `## Interrupts` section only when preemptive work is required; otherwise omit it.
- Use `### Interrupt N: <Title> [R-NN]` entries under `## Interrupts`.
- Interrupt entries must identify the paused step and reference the relevant requirement via `R-NN`.
- Resolve open interrupts in listed order before resuming normal plan steps.
- Leave the paused step incomplete; once the interrupt is complete, resume that paused step before later work.
- Split a step if it requires multiple independent validations.
- If a step expands materially during execution, update `plan.md` before continuing.
- Mark sub-tasks `[x]` only after verifying acceptance criteria are met.
- Do not delete steps — mark complete and move on.
- Do not delete completed interrupt entries during the active milestone.
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

Lightweight ADR log. Capture *why*, not just *what*. Use it for choices a future agent or developer would otherwise need to reverse-engineer.

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

Code standards and pointers to standards. **Human-managed only.** The agent reads and follows this file but does not write to it without explicit user instruction.

```markdown
# Conventions

## Language / Framework
## Style
## Reference Standards
## Project-Specific Rules
```

---

### `context.md`

File map and relationship index. It keeps the agent oriented without reading the whole repo. It must stay accurate — staleness is actively harmful.

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

### `issues.md`

Issues discovered during execution. Tie each entry to one plan step so future sessions can see where the miss occurred.

```markdown
# Issues

## I-01: <Title>
**Date:** YYYY-MM-DD
**Status:** open | resolved
**Linked Step:** Step <N> [R-NN]
**Source:** llm | user

**Summary:** <What went wrong.>
**What Was Missed:** <Instruction, assumption, check, or detail that was missed.>
**Action:** <Fix, mitigation, or follow-up.>
```

- Every issue must reference exactly one plan step.
- `Source` identifies where the miss originated. It is for diagnosis, not blame.
- Do not delete resolved issues; update `Status` and `Action` instead.

---

### `lessons-learned.md`

Durable lessons from issues. This file is read every session so mistakes do not repeat.

```markdown
# Lessons Learned

## L-01: <Title>
**Date:** YYYY-MM-DD
**Related Issues:** I-01

**Lesson:** <Reusable lesson to apply in future work.>
**Apply From Now On:** <Concrete behavior or check the agent should perform.>
```

- Update this file every time an issue is logged. Add a new lesson or revise an existing one to capture the reusable takeaway.
- Prefer revising an existing lesson over adding a near-duplicate.
- Re-read it after logging a new issue and at the start of every working turn.

---

### `scratch.md`

Session-scoped working notes. Not authoritative. Clear or archive them at the start of each session.

```markdown
## Session: 2026-04-19T14:00Z
<freeform notes>
```

---

## Update Checklist

Complete after every action before the next step:

- [ ] `plan.md` step and interrupt status current; acceptance criteria verified before any `[x]`
- [ ] `changelog.md` new entry appended
- [ ] `decisions.md` updated if a non-obvious choice was made
- [ ] `context.md` File Map updated if files were created, deleted, moved, or refactored
- [ ] `issues.md` updated if any issue, blocker, regression, or missed instruction was noted
- [ ] `lessons-learned.md` updated for every issue entry
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

1. Check if `.agent/` exists. If not, create empty scaffolding for all active files.
2. Read all active `.agent/` files before acting.
3. At the start of every working turn: re-read `plan.md`, `changelog.md`, `issues.md`, and `lessons-learned.md`.
4. If `plan.md` has no `[ ]` items — stop and ask the user what to do next.
5. If `requirements.md` is empty — gather requirements before planning.
6. If files contradict or anything is ambiguous — surface it, do not guess.
7. If `plan.md` has open interrupt items, resolve the oldest open interrupt first.
8. If `plan.md` has open step items and the user is asking for execution, resume the next incomplete step in the same session.
