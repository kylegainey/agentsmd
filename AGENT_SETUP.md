# Agent Setup Guide

This repo uses a structured agent memory system. AI agents store all project state in `.agent/` — committed to version control alongside the code. This gives you a full audit trail, reproducible context for any agent session, and a human-readable record of every decision made.

---

## How It Works

The agent reads `.agent/` at the start of every session. It writes to these files as it works. You commit them like any other code. Any agent — or human — picking up the project later has complete context without reading the whole codebase.

The instruction file that governs agent behavior is `agents.md` at the repo root (or wherever your agent framework expects it — see [Platform Notes](#platform-notes) below).

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
| `scratch.md` | Session working notes. Cleared each session. | Agent |

On-demand (not loaded at init — invoke explicitly):

| File | Purpose |
|---|---|
| `rotate_changelog.md` | Procedure to archive changelog when it gets large. |

Milestone archives land in `.agent/archive/` automatically.

---

## Starting a New Project

1. Copy `agents.md` to your repo root (or configure your agent platform to reference it).
2. Tell the agent: *"Initialize the project memory and gather requirements."*
3. The agent will create `.agent/` with empty scaffolding and start asking questions.
4. Review `requirements.md` when done. This is your last easy edit — it freezes once planning starts.
5. Tell the agent: *"Create the plan."*
6. Review `plan.md`. Add or adjust steps if needed before giving the green light.
7. Tell the agent: *"Begin work on Step 1."*

Commit `.agent/` after initialization.

---

## Picking Up an Existing Project

1. Open your agent session.
2. Tell the agent: *"Read the project memory and tell me where we are."*
3. The agent will summarize current status from `plan.md` and `changelog.md`.
4. Resume from there.

No additional setup needed — all context is in `.agent/`.

---

## Conventions File

`conventions.md` is yours. The agent reads it and follows it strictly but will not modify it without your instruction. Populate it before the agent starts writing code. Useful things to include:

- Language version and required tooling
- Formatter / linter settings
- Links to internal wikis or style guides
- Rules specific to this project (e.g., "all migrations must be reversible")

---

## Keeping context.md Useful

The agent maintains `context.md` as a file map. You can seed the **Do Not Touch** table with paths the agent should never modify (generated files, vendored dependencies, locked configs). Format:

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

You don't need to do anything. Check `.agent/milestones.md` for a human-readable history of what's been shipped.

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

At steady state, `.agent/` adds roughly 3,000–8,000 tokens per session. On a 200K context model this is under 5%. The main growth vector is `changelog.md` — rotate it when it exceeds ~200 rows to keep costs stable.
