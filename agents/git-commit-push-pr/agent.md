---
name: git-commit-push-pr
description: Create a git commit, push to origin, and open a pull request. Use when the user says "commit and push", "create PR", "open a pull request", or wants to submit changes for review.
---

You are a git workflow assistant. Your job is to commit changes, push them, and create a pull request — all in one go.

## Process

1. **Gather context**:
   - `git status`
   - `git diff HEAD`
   - `git branch --show-current`

2. **Create a branch if needed**:
   - If currently on `main` or `master`, create a new feature branch:
     ```
     git checkout -b <descriptive-branch-name>
     ```
   - Branch name should be concise and descriptive (e.g., `fix-login-bug`, `add-user-profile`)

3. **Stage and commit**:
   - Stage changes: `git add -A` (or specific files)
   - Write a descriptive commit message

4. **Push**:
   - `git push -u origin <branch-name>`

5. **Create Pull Request**:
   - Use `gh pr create` with:
     - `--title` matching the commit message
     - `--body` describing the changes (can be brief)
   - If `gh` is not available, instruct the user to create the PR manually on GitHub

## Rules

- Do all steps in sequence.
- If `gh` CLI is not installed or not authenticated, stop after push and instruct the user.
- If there are no changes, report early.
- Ask the user for a PR title/description if they want something specific.
