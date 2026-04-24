# Contributing to EKC

Thank you for contributing to **Everything Kimi Code (EKC)**.

---

## How to Contribute

1. Fork the repository
2. Create a branch for your change (`git checkout -b feature/my-feature`)
3. Follow the templates in `templates/`
4. Validate your changes locally
5. Submit a Pull Request with a clear description

---

## Repository Layout

```
everything-kimi-code/
├── agents/          # Source-of-truth for agents (.md + .yaml)
├── skills/          # Source-of-truth for skills (SKILL.md in subdirs)
├── scripts/         # Installers and utilities
├── templates/       # agent-template.md, skill-template.md
├── docs/            # Documentation
├── .kimi/skills/    # Generated runtime — DO NOT EDIT, DO NOT COMMIT
```

**`skills/` is the source-of-truth.** All edits must happen there.

**`.kimi/skills/` is generated runtime content.** It is created by the install scripts and is ignored by Git. Never edit files inside `.kimi/skills/` directly.

---

## Editing a Skill

1. Edit the skill in `skills/<name>/SKILL.md`
2. Run the install script to copy the change to `.kimi/skills/`
3. Restart Kimi CLI to pick up the change
4. Test the skill manually

### Windows

```powershell
.\scripts\install-project.ps1 -Force
```

### Linux / macOS / WSL

```bash
./scripts/install-project.sh --force
```

---

## Editing a Flow Skill

Flow skills are skills with `type: flow` that execute interactively following a Mermaid or D2 diagram.

### Required elements

- `type: flow` in the YAML frontmatter
- A Mermaid (` ```mermaid `) or D2 (` ```d2 `) diagram block
- `BEGIN` and `END` nodes in the diagram

### Allowed syntax

- Decision diamonds: `{Condition?}`
- Branching edges: `B -->|Yes| C`
- Loopback edges: `B -->|No| B`
- Plain text labels: `B[Do something]`

### Forbidden syntax

**Do not use `<br/>` inside Mermaid node labels.** Kimi CLI 1.39.0 silently rejects flow skills containing `<br/>` tags in Mermaid labels.

Use ` - ` (space-hyphen-space) instead:

```mermaid
# Bad — flow will not be recognized
B[Identify Language<br/>Detect the language]

# Good — flow works correctly
B[Identify Language - Detect the language]
```

### Validation workflow for flow skills

After editing a flow skill, run the validation script and test manually:

```powershell
# 1. Install to runtime
.\scripts\install-project.ps1 -Force

# 2. Validate
.\scripts\validate-project-install.ps1

# 3. Start Kimi CLI and test the flow
kimi
# Then type: /flow:<name>
```

---

## No Symlink Policy

Symlinks are **explicitly prohibited** in EKC. The install scripts use file copy only. This avoids cross-platform issues between Windows, macOS, and Linux.

---

## What to Commit and What to Ignore

| Path | Action | Reason |
|------|--------|--------|
| `skills/<name>/SKILL.md` | Commit | Source-of-truth |
| `agents/` | Commit | Source-of-truth |
| `scripts/` | Commit | Installers and utilities |
| `.kimi/skills/` | Ignore | Generated runtime copies |

Before committing, verify that `.kimi/skills/` does not appear in `git status`:

```bash
git status --short
```

If `.kimi/skills/` appears, check that `.gitignore` contains:

```
.kimi/skills/
```

---

## Validation Checklist Before Commit

Run this checklist before every commit that touches skills or flows:

1. **Check Git status**
   ```bash
   git status --short
   ```
   Confirm `.kimi/skills/` does not appear.

2. **Run the install script**
   ```powershell
   .\scripts\install-project.ps1 -Force
   ```
   or
   ```bash
   ./scripts/install-project.sh --force
   ```

3. **Run the validator**
   ```powershell
   .\scripts\validate-project-install.ps1
   ```
   or
   ```bash
   ./scripts/validate-project-install.sh
   ```
   Confirm all flow skills pass.

4. **For flow skill changes: manual test**
   ```bash
   kimi
   # Type: /flow:<name>
   ```
   Confirm the flow appears in autocomplete and executes.

5. **Check for forbidden `<br/>` tags**
   ```bash
   grep -r "<br" skills/*/SKILL.md
   ```
   For flow skills, this must return empty.

6. **Review your diff**
   ```bash
   git diff
   ```
   Confirm only intended files are changed.

---

## Commit Hygiene

Use conventional commit prefixes:

| Prefix | Use for |
|--------|---------|
| `feat:` | New skill, new agent, new capability |
| `fix:` | Bug fix in skill, agent, or script |
| `docs:` | README, CONTRIBUTING, or inline documentation |
| `refactor:` | Restructure without behavior change |
| `chore:` | Scripts, templates, maintenance |

Examples:

```
feat: add python-security skill
fix: remove <br/> from feature-dev flow
docs: update install instructions in README
```

Keep commits focused. One logical change per commit.

---

## Contribution Guidelines

### Agents

- Must include `.md` (system prompt) + `.yaml` (config)
- System prompt in English
- Clear description of when to use
- Minimum tools documented

### Skills

- Must include `SKILL.md` with valid YAML frontmatter
- Description in English
- Examples of usage
- Keep under 500 lines when possible

### Code

- Follow existing code style
- Add tests when applicable
- Update documentation

---

## Code of Conduct

Be respectful and constructive. We welcome contributors from all backgrounds and experience levels.
