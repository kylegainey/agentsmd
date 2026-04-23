# Copy-to-Project Template

This folder is the portable project bootstrap package.

- Copy `AGENTS.md` to the target repo root.
- Copy `copy-to-project/.agent/` to the target repo root as `./.agent/`.
- Files in this package are copied to the target directory.
- Existing project tracking files are never overwritten.
- Boilerplate files can be refreshed even if they already exist.

## Quick start (new repo)

```bash
mkdir -p <new-repo>/.agent
cp copy-to-project/AGENTS.md <new-repo>/AGENTS.md
cp -R copy-to-project/.agent/. <new-repo>/.agent/
```

Or run:

```bash
copy-to-project/bootstrap.sh <new-repo>
```

Preview only:

```bash
copy-to-project/bootstrap.sh --dry-run <new-repo>
```

## File behavior

### Always overwritten

- `AGENTS.md`
- `.agent/core.md`
- `.agent/README.md`
- `.agent/rotate_changelog.md`

### Dry run

- `copy-to-project/bootstrap.sh --dry-run <target>` prints every decision with
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
