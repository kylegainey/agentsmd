# Changelog Rotation Procedure

Load this file only when `changelog.md` exceeds ~200 rows. Do not load it at init.

## When to Invoke

- User requests it, or
- `changelog.md` table body exceeds ~200 rows

## Procedure

1. Read the current milestone from `plan.md` (`MILESTONE:`). If it is unset, use the current date (`YYYY-MM-DD`).

2. Create `.agent/archive/` if it does not exist.

3. Copy the full contents of `changelog.md` to `.agent/archive/changelog-<milestone>.md`.

4. Replace `changelog.md` with a header and one summary entry:

```markdown
# Changelog

> Entries prior to this milestone archived in `.agent/archive/changelog-<milestone>.md`

| Timestamp (UTC) | Commit | What | Why | Files |
|---|---|---|---|---|
| <now> | <hash or —> | Changelog rotated | Archive: changelog-<milestone>.md | `.agent/changelog.md` |
```

5. Append a rotation entry to the new `changelog.md` that confirms the archive location.

6. Verify the archive file is readable and complete before considering rotation done.

## Notes

- Never delete the archive file.
- The archive file is not loaded at init and does not count toward active context.
- If git is in use, commit the rotation as its own commit with message: `chore: rotate changelog to archive/<milestone>`.
