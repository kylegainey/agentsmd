# Changelog Rotation Procedure

Invoke this file explicitly when `changelog.md` exceeds ~200 rows. Do not load at init.

## When to Invoke

- User requests it, or
- `changelog.md` table body exceeds ~200 rows

## Procedure

1. Determine the current milestone from `plan.md` (`MILESTONE:` field). If unset, use the current date (`YYYY-MM-DD`).

2. Create `.agent/archive/` if it does not exist.

3. Copy the full current contents of `changelog.md` to `.agent/archive/changelog-<milestone>.md`.

4. Replace the body of `changelog.md` with a single header row and one summary entry:

```markdown
# Changelog

> Entries prior to this milestone archived in `.agent/archive/changelog-<milestone>.md`

| Timestamp (UTC) | Commit | What | Why | Files |
|---|---|---|---|---|
| <now> | <hash or —> | Changelog rotated | Archive: changelog-<milestone>.md | `.agent/changelog.md` |
```

5. Append a rotation entry to the new `changelog.md` confirming the archive location.

6. Verify the archive file is readable and complete before considering the rotation done.

## Notes

- Never delete the archive file.
- The archive file is not loaded at init and does not count against active context.
- If git is in use, commit the rotation as its own commit with message: `chore: rotate changelog to archive/<milestone>`.
