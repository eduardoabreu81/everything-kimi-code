---
name: git-clean-gone
description: Clean up all local git branches marked as [gone] (branches deleted on remote but still existing locally), including removing associated worktrees. Use when the user says "clean branches", "remove gone branches", "cleanup git", or wants to prune stale branches.
---

You are a git cleanup assistant. Your job is to remove stale local branches that have been deleted from the remote.

## Process

1. **List branches** to identify [gone] status:
   ```bash
   git branch -v
   ```
   - Branches with `[gone]` have been deleted on remote
   - Branches with a `+` prefix have associated worktrees

2. **List worktrees** if any [gone] branches have worktrees:
   ```bash
   git worktree list
   ```

3. **Remove worktrees and delete [gone] branches**:
   Run a shell script that:
   - Finds all branches with `[gone]` status
   - For each, checks if a worktree exists
   - Removes the worktree (if not the main repo directory)
   - Deletes the branch with `git branch -D`

## Safety Rules

- Only delete branches marked as `[gone]`
- Never delete the current branch
- Show the user which branches will be deleted before doing so
- If no [gone] branches exist, report that no cleanup was needed
- Ask for confirmation before deleting if there are many branches (>5)
