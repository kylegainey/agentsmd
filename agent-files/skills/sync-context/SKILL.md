---
name: sync-context
description: Survey the project and reconcile `.agent/context.md` so its Overview, Entry Points, File Map, Key Agent Files, and Do Not Touch sections match reality. Use when the user asks to "sync context", "refresh context.md", or "update context", and proactively when context.md looks stale — e.g. File Map references files that don't exist, top-level dirs aren't listed, AGENTS.md/CLAUDE.md were just changed, or after a large refactor.
---

# sync-context

Reconcile `.agent/context.md` with the actual repository state. The user must approve the diff before any write.

## Hard rules

1. **Never write `.agent/context.md` without explicit user approval in this turn.** "Looks good" or "apply" or equivalent is required. Silence ≠ approval.
2. **Preserve hand-curated content.** Auto-rebuild only the structured sections listed below. Leave `Key Relationships` and any custom sections intact, verbatim. If the user has added prose under a structured heading (beyond table rows / bulleted lists), keep it.
3. **Diff-first.** Always show the user a unified diff of the proposal before they approve. No "trust me" updates.
4. **Bail out early** if `.agent/` is missing — point the user at `bootstrap.sh` and stop.

## Inputs to read

1. `.agent/context.md` — current state (canonical baseline; create from skeleton if missing).
2. `README.md` (any case) at repo root — for Overview synthesis.
3. Package manifests at repo root: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, `Makefile`, `composer.json`. Use whichever exist.
4. `.gitignore` — for Do Not Touch heuristics.
5. `.agent/*.md` — first heading + first non-empty paragraph of each.
6. Top-level directory listing. Skip: `.git`, `node_modules`, `dist`, `build`, `target`, `.venv`, `venv`, `__pycache__`, `.pytest_cache`, `.cache`, `.next`, `.turbo`, `coverage`, `.idea`, `.vscode`.

## Section rules

### Overview (3 sentences max)

Synthesize from README + manifest `description` fields:

1. What this project does (one sentence).
2. What it explicitly does not do, if scope is bounded.
3. Key boundary or constraint (e.g. "ships as a CLI", "library only, no UI").

If none of those sources exist, leave the existing Overview alone and flag in your summary.

### Entry Points table

Columns: `Purpose | Path`. Sources, in priority order:

- `package.json` `bin` field (each entry → row).
- `package.json` `scripts` keys when they look like CLI/dev entry points (`start`, `dev`, `serve`, `build`, top-level `cli`/`server`).
- `pyproject.toml` `[project.scripts]`.
- `Makefile` top-level targets (`^[a-zA-Z][a-zA-Z0-9_-]*:` — skip `.PHONY`, internal targets prefixed `_`).
- Repo-root files matching `main.*`, `cli.*`, `server.*`, `app.*`, `index.*`, `bootstrap.sh`, `run.sh`.
- `bin/*` directory contents.

One row per distinct entry point. Path is repo-relative.

### File Map table

Columns: `Path | Purpose | Owned By | Consumed By`.

- One row per top-level directory (after the skip list above).
- One row per notable repo-root file: `README.md`, `LICENSE`, manifest files, `bootstrap.sh`, `Dockerfile`, etc.
- Always include `.agent/` row with `Owned By: agent`, `Consumed By: agent`.
- `Purpose`: one short phrase. Derive from (in order): explicit comment in README, manifest description, top-level doc inside the dir, package name, otherwise observed file types ("TypeScript source", "shell scripts").
- `Owned By` / `Consumed By`: leave blank when not obviously inferable. Do not invent ownership.

### Key Agent Files

Bulleted list. One bullet per `.agent/*.md` file (alphabetical):

- `.agent/<name>.md`: <one-line purpose taken from the file's first heading or intro line>.

If the file has standard agent-files purpose (core.md, current.md, plan.md, etc.), use the canonical phrasing from `agent-files/.agent/README.md` if present.

### Do Not Touch table

Columns: `Path | Reason`. Sources:

- `.gitignore` lines matching: `*.env*`, `secrets/`, `*.key`, `*.pem`, `credentials*`, `*token*`, `private*`.
- Generated/cache dirs from `.gitignore` (only if present): `dist/`, `build/`, `node_modules/`, `__pycache__/`, `.cache/`.
- Anything currently in the existing Do Not Touch table (preserve user-curated entries).

If `.gitignore` is missing or yields nothing, leave the table empty (header rows only).

## Workflow

1. Read all inputs.
2. If `.agent/` is missing, stop and tell the user to run `bootstrap.sh` first.
3. If `.agent/context.md` is missing, start from the canonical skeleton (Overview, Entry Points, File Map, Key Agent Files, Key Relationships, Do Not Touch).
4. Build the proposed file content in memory by:
   - Replacing the contents of each structured section per the rules above.
   - Copying verbatim: `Key Relationships`, any custom sections, any prose blocks under structured headings that aren't tables/bullets.
5. Run `diff -u .agent/context.md <(printf '%s' "$proposed")` (or equivalent) and post the diff in the chat as a fenced ```diff block.
6. Provide a one-line summary of what changed (e.g. "Added 2 entry points, updated 3 File Map rows, no changes to Overview"). If nothing meaningful changed, say so and stop without writing.
7. End your message with: **"Reply `apply` to write this, or describe edits."**
8. Do not call Write or Edit until the user replies with apply / yes / go / equivalent confirmation. If they ask for changes, revise and re-diff.
9. On approval, write the proposed content to `.agent/context.md`.

## Notes

- `context.md` lives in `.agent/`, so the `plan-gate` hook does not block edits to it. The `changelog-append` hook only targets `.agent/changelog.md` and is irrelevant here.
- The user authored the original AGENTS.md rule "do not overwrite tracking files unless explicitly instructed" — the explicit instruction is the user's `apply` confirmation in step 7.
- If you discover something that probably belongs in another `.agent/` file (a new convention, an issue, a decision), mention it in your summary but do **not** edit any file other than `context.md` from this skill.
