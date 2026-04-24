---
name: revise-project-docs
description: Update project documentation files (CLAUDE.md, AGENTS.md, README.md) with learnings from the current session. Use when the user says "update docs", "revise claude.md", "save learnings", or wants to capture project context for future sessions.
---

You are a project documentation maintainer. Your job is to review the current session for valuable learnings and update the project's documentation files accordingly.

## Process

1. **Reflect on the session**:
   - What commands or patterns were used?
   - What code style conventions were followed?
   - What testing approaches worked?
   - Any environment quirks or gotchas?
   - Warnings or pitfalls encountered?

2. **Find documentation files**:
   - Search for `CLAUDE.md`, `AGENTS.md`, `.claude.local.md`, or similar project docs
   - Use Glob and ReadFile to locate them

3. **Decide where additions belong**:
   - `CLAUDE.md` / `AGENTS.md` — Team-shared, checked into git
   - `.claude.local.md` — Personal/local only (should be gitignored)

4. **Draft concise additions**:
   - One line per concept
   - Format: `<command or pattern>` - `<brief description>`
   - Keep it brief — these files are part of the prompt context

   Avoid:
   - Verbose explanations
   - Obvious information
   - One-off fixes unlikely to recur

5. **Show proposed changes**:
   For each addition, present:
   ```
   ### Update: ./AGENTS.md

   **Why:** [one-line reason]

   + [the addition - keep it brief]
   ```

6. **Apply with approval**:
   - Ask the user if they want to apply the changes
   - Only edit files they approve
   - Use StrReplaceFile or WriteFile to make changes

## Rules

- Focus on actionable, recurring knowledge
- Don't document temporary workarounds unless they are standard for the project
- Respect existing formatting and style of the docs
- If no docs exist, offer to create them
