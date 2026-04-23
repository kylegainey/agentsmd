# Agent Files Template

This folder is the portable project bootstrap package.

- Copy `AGENTS.md` to the target repo root.
- Copy `agent-files/.agent/` to the target repo root as `./.agent/`.
- Files in this package are copied to the target directory.
- Existing project tracking files are never overwritten.
- Boilerplate files can be refreshed even if they already exist.

## Quick start (new repo)

```bash
mkdir -p <new-repo>/.agent
cp agent-files/AGENTS.md <new-repo>/AGENTS.md
cp -R agent-files/.agent/. <new-repo>/.agent/
```

Run:

```bash
./bootstrap.sh <new-repo>
```

Preview only:

```bash
./bootstrap.sh --dry-run <new-repo>
```

## File behavior

### Always overwritten

- `AGENTS.md`
- `.agent/core.md`
- `.agent/README.md`
- `.agent/rotate_changelog.md`

### Dry run

- `./bootstrap.sh --dry-run <target>` prints every decision with
  `copy`, `overwrite`, and `skip` outcomes and performs no writes.

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
