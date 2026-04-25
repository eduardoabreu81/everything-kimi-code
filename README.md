# EKC — Everything Kimi Code

EKC is a collection of agents, reusable skills, and interactive flows for the [Kimi CLI](https://moonshotai.github.io/kimi-cli/) and the Kimi Code extension for VS Code. It is a port and adaptation of the [Everything Claude Code](https://github.com/affaan-m/everything-claude-code) ecosystem, rebuilt for Kimi's tooling and conventions.

After installation, EKC adds 64 specialist subagents, 206 reusable skills, and 4 interactive workflows to your Kimi environment. These run through standard Kimi commands such as `/skill:<name>` and `/flow:<name>`, both in the terminal and inside VS Code.

EKC is not a one-to-one clone of Claude Code. Claude-specific commands, hooks, plugin behavior, `.claude` paths, and `CLAUDE.md`-specific workflows are adapted, replaced, or excluded where they do not map cleanly to Kimi.

## Who It Is For

Developers who already use Kimi for coding assistance and want ready-made workflows for:

- Code review with language-specialized reviewers
- Feature development from discovery to delivery
- GitHub PR review with scoring and automated comments
- General PR review orchestrating multiple reviewers

## Quick Start

Install globally so EKC is available in every project and in VS Code.

### Windows (PowerShell)

```powershell
git clone https://github.com/eduardoabreu81/everything-kimi-code.git
cd everything-kimi-code
.\scripts\install-global.ps1
.\scripts\validate-global-install.ps1
```

### Linux / macOS / WSL (Bash)

```bash
git clone https://github.com/eduardoabreu81/everything-kimi-code.git
cd everything-kimi-code
./scripts/install-global.sh
./scripts/validate-global-install.sh
```

After installing, reload VS Code or restart the Kimi CLI session.

## Use in VS Code

When EKC is installed globally in `~/.kimi/skills/`, the Kimi Code extension for VS Code discovers the skills automatically.

Open the Kimi chat panel and type:

```
/skill:<name>     # Load a skill into context
/flow:<name>      # Execute an interactive workflow
```

Examples:

```
/flow:feature-dev
/flow:code-review
```

## Use in Kimi CLI

In any terminal, run:

```bash
kimi
```

Then use the same commands:

```
/flow:              # Browse available flows via autocomplete
/flow:feature-dev   # Execute a specific flow
/skill:<name>       # Load a skill into context
```

## Available Flows

| Flow | Command | Description |
|------|---------|-------------|
| Feature Development | `/flow:feature-dev` | Complete workflow from discovery to delivery |
| Code Review | `/flow:code-review` | Language-detected review with specialized reviewers |
| PR Review | `/flow:pr-review` | Orchestrates 6 specialized reviewers |
| GitHub Code Review | `/flow:github-code-reviewer` | GitHub PR review with scoring and automated comments |

## Installation Modes

| Mode | Target | Purpose |
|------|--------|---------|
| **Global** | `~/.kimi/skills/` | Primary mode. Skills are available everywhere: VS Code, Kimi CLI, any project. |
| **Project** | `.kimi/skills/` | Development and testing mode. Use only when working on the EKC repository itself. |

For project-level install, see `scripts/install-project.ps1` (PowerShell) or `scripts/install-project.sh` (Bash).

## Update EKC

Existing users can update by pulling the latest changes and rerunning the global installer:

```powershell
git pull
.\scripts\install-global.ps1 -Force
.\scripts\validate-global-install.ps1
```

Or with Bash:

```bash
git pull
./scripts/install-global.sh --force
./scripts/validate-global-install.sh
```

## Uninstall

Remove the global EKC installation:

```powershell
.\scripts\clean-global-install.ps1 -Yes
```

Or with Bash:

```bash
./scripts/clean-global-install.sh --yes
```

This deletes `~/.kimi/skills/` only if it was created by EKC (protected by a stamp file).

## Known Limitations

**Mermaid node labels must not contain `<br/>` tags.**

Kimi CLI 1.39.0 silently rejects flow skills that contain `<br/>` inside Mermaid labels. Use ` - ` (space-hyphen-space) instead:

```text
# Bad — flow will not be recognized
B[Identify Language<br/>Detect the language]

# Good — flow works correctly
B[Identify Language - Detect the language]
```

**Flow diagrams must not contain disconnected (dead) nodes.**

Every node in a flow diagram must have an outgoing edge (except END) and an incoming edge (except BEGIN). A disconnected node causes the flow to be silently rejected by Kimi CLI.

**Decision diamonds and loopback edges are fully supported.**

## Project Background

EKC is a Kimi CLI port and adaptation of [Everything Claude Code](https://github.com/affaan-m/everything-claude-code). The goal is not to copy ECC one-to-one. EKC keeps the parts that map well to Kimi — agents, reusable skills, and flow-based workflows — while adapting or excluding Claude-specific surfaces that do not work the same way.

## For Contributors

If you want to add skills, fix flows, or improve scripts, read [CONTRIBUTING.md](CONTRIBUTING.md) for the full workflow, validation rules, and commit conventions.

## License

- **Agents, Skills, CLI, docs, templates:** MIT
- **kimi-mem/**: AGPL-3.0 (claude-mem fork)

See [LICENSE](LICENSE) for full details.
