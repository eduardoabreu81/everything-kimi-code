# EKC — Everything Kimi Code

**EKC (Everything Kimi Code)** is an open-source ecosystem that adapts and expands the **Claude Code (ECC)** experience for the **Kimi CLI**.

It provides a collection of specialist agents, reusable skills, and interactive workflow flows designed to work with Kimi CLI's native tooling.

### What's Included

- **1 EKC main agent + 64 specialist subagents** — code review, architecture, build, security, Git, and orchestration
- **206 reusable skills** — backend, frontend, DevOps, security, healthcare, business, media, and more
- **4 flow skills** — interactive workflows: feature development, code review, PR review, and GitHub code review
- **Kimi-Mem (in development)** — fork of `claude-mem` with persistent memory and semantic search
- **Project-level install scripts** — copy-based installation of skills to `.kimi/skills/`

### Current Status

The foundation phase is complete:
- 64 subagents migrated and structured for Kimi CLI
- 206 skills migrated and organized
- 4 flow skills created and validated
- Project-level install scripts implemented (PowerShell + Bash)

Next: `ekc-cli` interactive installer, `ekc-validator` library, and Kimi-Mem implementation.

### Requirements

- **Kimi CLI** `1.39.0` or later
- **Git** (for cloning and updates)
- **PowerShell** (Windows) or **Bash** (Linux/macOS/WSL)

### Repository Structure

```
everything-kimi-code/
├── agents/              # 1 main agent + 64 specialist subagents (.md + .yaml)
├── skills/              # 206 skills (SKILL.md in subdirectories) — source of truth
├── kimi-mem/            # Fork of claude-mem (AGPL-3.0)
├── packages/
│   ├── ekc-cli/         # CLI installer (planned)
│   └── ekc-validator/   # Validation library (planned)
├── docs/                # Documentation (en + pt-BR)
├── templates/           # Templates for creating agents/skills
├── scripts/             # Installers and utilities
└── tests/               # Integration tests
```

**Important:** `skills/` is the source-of-truth directory. It contains the canonical, versioned skill definitions. Do not edit files inside `.kimi/skills/` directly.

### Installation

EKC uses a **copy-based project-level installation**. Skills are copied from `skills/` (versioned) to `.kimi/skills/` (runtime), which is the directory where Kimi CLI discovers project-level skills.

**No symlinks are used.** Symlinks are explicitly prohibited in EKC to avoid cross-platform issues.

#### Windows (PowerShell)

```powershell
# Install: copy skills/ → .kimi/skills/
.\scripts\install-project.ps1

# Validate the installation
.\scripts\validate-project-install.ps1

# Clean (removes .kimi/skills/)
.\scripts\clean-project-install.ps1 -Yes
```

#### Linux / macOS / WSL (Bash)

```bash
# Install: copy skills/ → .kimi/skills/
./scripts/install-project.sh

# Validate the installation
./scripts/validate-project-install.sh

# Clean (removes .kimi/skills/)
./scripts/clean-project-install.sh --yes
```

#### Install Options

| Flag | PowerShell | Bash | Description |
|------|-----------|------|-------------|
| Force overwrite | `-Force` | `--force` | Overwrite existing skills without prompting |
| Dry run | `-DryRun` | `--dry-run` | Show what would be copied without copying |
| Quiet | `-Quiet` | `--quiet` | Suppress non-error output |

### How to Use Skills

After installation, start Kimi CLI inside the project directory:

```bash
kimi
```

Kimi CLI discovers project-level skills in `.kimi/skills/`. Use them with:

```
/skill:<name>       # Load a skill for context
/flow:<name>        # Execute a flow skill interactively
```

**Difference between `/skill` and `/flow`:**
- `/skill:<name>` loads the `SKILL.md` content into context as a regular skill.
- `/flow:<name>` executes the skill as an interactive flow, following the Mermaid/D2 diagram from `BEGIN` to `END`.

### Flow Skills

EKC provides 4 flow skills for interactive workflows:

| Flow | Command | Description |
|------|---------|-------------|
| Feature Development | `/flow:feature-dev` | Complete feature development workflow — discovery, exploration, architecture, implementation, review |
| Code Review | `/flow:code-review` | Language-detected code review with specialized reviewers |
| PR Review | `/flow:pr-review` | Complete PR review orchestrating 6 specialized reviewers |
| GitHub Code Review | `/flow:github-code-reviewer` | GitHub PR review with scoring and automated comments |

### What to Commit and What to Ignore

| Path | Status | Reason |
|------|--------|--------|
| `skills/` | **Commit** | Source of truth — canonical skill definitions |
| `agents/` | **Commit** | Agent definitions (.md + .yaml) |
| `scripts/` | **Commit** | Installers and utilities |
| `.kimi/skills/` | **Ignore** | Generated runtime copies — created by install scripts |

The file `.gitignore` already includes `.kimi/skills/`. If you see runtime copies in `git status`, verify that `.gitignore` contains:

```
.kimi/skills/
```

### Editing Skills

1. Edit the skill in `skills/<name>/SKILL.md`
2. Re-run the install script to copy changes to `.kimi/skills/`
3. Restart Kimi CLI to pick up the changes

```powershell
.\scripts\install-project.ps1 -Force
```

### Known Limitations

**Avoid `<br/>` inside Mermaid node labels for Kimi flow skills.**

Kimi CLI 1.39.0 silently rejects flow skills that contain `<br/>` tags inside Mermaid node labels. Use ` - ` (space-hyphen-space) instead:

```mermaid
# Bad — flow will not be recognized
B[Identify Language<br/>Detect the language]

# Good — flow works correctly
B[Identify Language - Detect the language]
```

Decision diamonds (`{Condition?}`) and loopback edges (`B -->|No| B`) are fully supported.

### Troubleshooting

#### `/flow` does not show EKC flows

1. Run the install script:
   ```powershell
   .\scripts\install-project.ps1
   ```
2. Validate the installation:
   ```powershell
   .\scripts\validate-project-install.ps1
   ```
3. Restart Kimi CLI:
   ```bash
   kimi
   ```

#### Flow appears as `/skill:<name>` but not as `/flow:<name>`

Check the skill file for these required elements:
- `type: flow` in the YAML frontmatter
- A Mermaid or D2 diagram block (` ```mermaid ` or ` ```d2 `)
- `BEGIN` and `END` nodes in the diagram
- No `<br/>` tags inside Mermaid labels

#### Runtime copies appear in `git status`

Check that `.gitignore` contains `.kimi/skills/`:

```bash
git check-ignore -v .kimi/skills/.ekc-installed
```

If it returns nothing, add `.kimi/skills/` to `.gitignore`.

### Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

### License

- **Agents, Skills, CLI, docs, templates:** MIT
- **kimi-mem/**: AGPL-3.0 (claude-mem fork)

See [LICENSE](LICENSE) for full details.

---

*Last updated: 2026-04-24*
