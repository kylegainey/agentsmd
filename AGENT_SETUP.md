# Agent Setup Guide

This repo uses a structured agent memory system. Agents store project state in `.agent/`, committed alongside the code. This gives you a full audit trail, reproducible context, and a human-readable record of decisions.

---

## How It Works

The agent reads `.agent/` at the start of every session and writes to it as it works. `issues.md` and `lessons-learned.md` are part of that active context, so missed details and their lessons carry forward. Commit these files like any other code. Any agent or human picking up the project later has full context without reading the whole codebase.

The instruction file is `agents.md` at the repo root, or wherever your agent framework expects it. See [Platform Notes](#platform-notes).

---

## File Reference

| File | Purpose | Who Edits |
|---|---|---|
| `requirements.md` | What must be built. Frozen after planning. | Human (initial), agent (requirements stage only) |
| `plan.md` | Step-by-step work plan with acceptance criteria. | Agent (before every work session) |
| `changelog.md` | Append-only record of every change. | Agent |
| `decisions.md` | Why non-obvious choices were made (ADRs). | Agent |
| `conventions.md` | Code standards and style rules. | **Human only** |
| `context.md` | File map and relationship index. | Agent (kept current), human (seed "Do Not Touch") |
| `issues.md` | Issue log linked to specific plan steps. | Agent |
| `lessons-learned.md` | Reusable lessons derived from issues; read every session. | Agent |
| `scratch.md` | Session working notes. Cleared each session. | Agent |

On-demand (not loaded at init — invoke explicitly):

| File | Purpose |
|---|---|
| `rotate_changelog.md` | Procedure to archive changelog when it gets large. |

Milestone archives land in `.agent/archive/` automatically.

---

## Tracking Issues and Lessons

Any issue, regression, blocker, or missed instruction should be recorded in `issues.md` before moving on.

- Link every issue to exactly one plan step.
- Record whether the miss was `llm`- or `user`-related.
- State the specific detail, assumption, or check that was missed.
- After logging the issue, update `lessons-learned.md` by adding a new lesson or revising the closest existing one.

`lessons-learned.md` should be read at the start of each session alongside `plan.md`, `changelog.md`, and `issues.md`.

---

## Starting a New Project

1. Copy `agents.md` to your repo root (or configure your agent platform to reference it).
2. Tell the agent: *"Initialize the project memory and gather requirements."*
3. The agent will create `.agent/` scaffolding, including `issues.md` and `lessons-learned.md`, and start asking questions.
4. Review `requirements.md` when done. This is your last easy edit — it freezes once planning starts.
5. Tell the agent: *"Create the plan."*
6. Review `plan.md`. Add or adjust steps if needed before giving the green light.
7. Tell the agent: *"Begin work on Step 1."*

Commit `.agent/` after initialization.

---

## Picking Up an Existing Project

1. Open your agent session.
2. Tell the agent: *"Read the project memory and tell me where we are."*
3. The agent will summarize current status from `plan.md`, `changelog.md`, `issues.md`, and `lessons-learned.md`.
4. If the user is asking for execution, the agent should continue with the next incomplete interrupt or plan step in the same session. If the user asked only for status or planning, it should stop after the summary.

No additional setup needed — all context is in `.agent/`.

---

## Continuing Work in a Session

The initial `.agent/` read is a startup step, not a stopping point.

- If the plan has open interrupt items, address the oldest open interrupt before normal plan steps.
- If the plan has open step items and the user request is actionable, continue with the next incomplete step after the read.
- Split a step if it requires multiple independent validations.
- If a step expands materially during execution, update `plan.md` before continuing.
- After each completed step or interrupt, report any assumptions made or decisions taken without user input.
- Do not wait for a second prompt just because startup or summary is complete.
- Stop after startup only when the user asked for status, planning, brainstorming, or clarification.

---

## Interrupting and Resuming Work

If a new issue or concern needs immediate attention mid-work, the agent should update `plan.md` before switching context.

- Add an entry under `## Interrupts` in `plan.md`.
- Record which step is being paused in a `**Pauses:** Step <N> [R-NN]` line.
- If the interrupt came from an issue, regression, blocker, or missed instruction, log it in `issues.md` and update `lessons-learned.md` before moving on.
- Complete the interrupt using normal acceptance criteria.
- When the interrupt is complete, resume the paused step automatically before continuing with later plan steps.

Completed interrupt entries stay in `plan.md` until milestone rotation so the interruption history is preserved.

---

## Conventions File

`conventions.md` is yours. The agent reads it and follows it strictly, but will not modify it without your instruction. Populate it before the agent starts writing code. Useful things to include:

- Language version and required tooling
- Formatter / linter settings
- Links to internal wikis or style guides
- Rules specific to this project (e.g., "all migrations must be reversible")

---

## Keeping context.md Useful

The agent maintains `context.md` as a file map. You can seed the **Do Not Touch** table with paths it should never modify, such as generated files, vendored dependencies, or locked configs. Format:

```markdown
## Do Not Touch
| Path | Reason |
|---|---|
| `generated/` | Auto-generated, do not hand-edit |
```

Keep the Overview section to 3 sentences. If it grows longer, trim it — that content belongs in a README, not a map.

---

## Changelog Rotation

When `changelog.md` gets large (~200+ rows), load the rotation procedure:

- Claude Code: `@.agent/rotate_changelog.md` then ask the agent to run it.
- Other agents: *"Read `.agent/rotate_changelog.md` and execute the rotation procedure."*

Archived changelogs land in `.agent/archive/` and are committed to git. They are not loaded at init.

---

## Milestone Completion

When a plan milestone completes, the agent will automatically:
- Append a summary to `.agent/milestones.md`
- Archive `plan.md` to `.agent/archive/`
- Reset `plan.md` for the next milestone

You do not need to do anything. Check `.agent/milestones.md` for a human-readable history of what shipped.

---

## Platform Notes

### Claude Code
Place `agents.md` at the repo root as `CLAUDE.md`, or reference it with `@agents.md`. Use `@.agent/<file>` to load specific memory files explicitly.

### Cursor
Place `agents.md` content in `.cursor/rules` or reference as `@agents.md` depending on your Cursor version.

### Other agents
Point the agent at `agents.md` as its system instruction source. Instruct it to read `.agent/` at session start.

---

## .gitignore Recommendations

Commit everything in `.agent/` by default — that's the point. The only optional exclusion is `scratch.md` if you don't want session noise in history:

```gitignore
# Optional: exclude session scratch notes
.agent/scratch.md
```

Keep `archive/` committed. It's your long-term audit trail.

---

## Estimated Context Cost

At steady state, `.agent/` adds roughly 3,000–8,000 tokens per session. On a 200K context model, this is under 5%. The main growth vector is `changelog.md`; rotate it when it exceeds ~200 rows to keep costs stable.
