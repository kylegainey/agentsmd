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

## Source

This package is maintained in the `project-setup` bootstrap repository.
