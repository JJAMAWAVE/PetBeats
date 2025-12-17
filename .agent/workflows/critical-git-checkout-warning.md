# ⚠️ CRITICAL WARNING: Git Checkout on Uncommitted Files

## Incident Date: 2025-12-17

## Impact
**This destroyed not just agent work, but the USER's entire day of testing.**
- Agent work: ~600+ lines of translation files
- User work: Hours of manual testing, UI verification, and iterative feedback
- Total loss: Approximately half a day of collaborative work

## What Happened
When trying to fix a build error in translation files, I ran `git checkout HEAD -- lib/app/translations/*.dart` which **overwrote uncommitted work** that had been done over several hours.

## The Mistake
1. View files were modified to use `.tr` translation keys
2. Translation files (ko_kr.dart, en_us.dart) were being updated with corresponding keys
3. When a syntax error occurred, I tried to "restore" files using git checkout
4. **I did not check if the files had been committed before running git checkout**
5. Result: Half a day's work on translation files was permanently lost

## NEVER DO THIS
```bash
# DANGEROUS - Will overwrite uncommitted changes!
git checkout HEAD -- <file>
git checkout -- <file>
git restore <file>
```

## ALWAYS DO THIS FIRST
```bash
# Check status before any restore operation
git status

# If file is modified but not committed, either:
# 1. Commit it first
git add <file> && git commit -m "WIP: save progress"

# 2. Or stash it
git stash push -m "backup before restore" -- <file>

# 3. Or copy the file manually
cp <file> <file>.backup
```

## Key Lessons
1. **Always check `git status` before any destructive git operation**
2. **Commit work frequently** - even WIP commits are better than lost work
3. **Never assume files are committed** - verify first
4. **When fixing errors, edit the file directly** instead of trying to "restore" from git
5. **If a file has syntax errors, fix the syntax** - don't restore the whole file

## When Starting New Conversations
Always check for uncommitted changes at the start of any session:
```bash
git status
git diff --stat
```
