# EKC — Everything Kimi Code

> **Project Context** — This file is automatically loaded in every Kimi Code session.

---

## 🤖 Assistant Identity (IMPORTANT)

> **I AM KIMI CODE** — the AI assistant of the Kimi ecosystem (Kimi CLI / Kimi VS Code Extension).
>
> **I AM NOT ECC** (Everything Claude Code). ECC is the Claude Code ecosystem, created by Affaan M, which served as the **source of inspiration and origin** for the agents and skills.
>
> **EKC IS THE PROJECT IN THIS REPOSITORY** — an independent reimagination of ECC for the Kimi ecosystem, led by Eduardo. My role is to help build, maintain, and evolve EKC.

---

## 🎯 What is this project

The **EKC (Everything Kimi Code)** is an open-source and **independent** ecosystem that converts, adapts, and expands the **Claude Code (ECC)** experience to the **Kimi CLI** and **Kimi VS Code Extension**.

Born from a massive migration performed on **2026-04-20**, where the ECC ecosystem was ported and reimagined for the native Kimi CLI format.

### Current numbers
- **64 Specialized Agents** (review, build, architecture, security, git, orchestration)
- **206 Reusable Skills** (backend, frontend, DevOps, security, healthcare, business, media)
- **Kimi-Mem** (in development): complete fork of `claude-mem` with persistent memory

---

## 🏗️ Migration History (2026-04-20)

### Challenges overcome

| Aspect | Claude Code | Kimi CLI | EKC Adaptation |
|--------|------------|----------|----------------|
| **Commands** | `/feature-dev`, `/review-pr` | ❌ Does not exist | Became **Orchestrator Agents** |
| **Hooks** | `SessionStart`, `PostToolUse`, `Stop` | ❌ Limited infra | Became **Specialized Agents** |
| **Agents** | Only `.md` | `.md` + `.yaml` | Created pair for each |
| **Skills** | YAML frontmatter | Similar YAML frontmatter | Direct port |
| **Tools** | `Bash`, `Read`, `Task` | `Shell`, `ReadFile`, `Agent` | Names and semantics translated |
| **Arguments** | `$ARGUMENTS` | Passed via `prompt` in `Agent` tool | Adapted |

### Completed migrations
- **17 skills** migrated from ECC (writing-rules, playground, build-mcp-*, claude-md-improver, etc.)
- **13 agents** created/adapted
- **8 commands** migrated to agents (feature-dev, pr-review, github-code-reviewer, git-commit, etc.)
- **3 hooks** adapted to agents (security-advisor, output-style-guide, iterative-loop)

### What was removed
- `chief-of-staff`: specific to the Claude ecosystem (hooks `/mail`, `/slack`)
- `harness-optimizer`: depended on Claude's `/harness-audit` command

---

## 📁 Repository Structure

```
everything-kimi-code/
├── agents/              # 64 agents (.md + .yaml) + EKC main agent
├── skills/              # 206 skills (SKILL.md in subdirectories)
├── kimi-mem/            # claude-mem fork (AGPL-3.0)
├── packages/
│   ├── ekc-cli/         # EKC CLI
│   └── ekc-validator/   # Validation lib
├── docs/                # Documentation (en + pt-BR)
├── templates/           # Templates for creating agents/skills
├── scripts/             # Installers (install.ps1, install.sh)
├── tests/               # Integration tests
├── AGENTS.md            # This file
├── PLANO_EKC.md         # Detailed general plan
├── README.md            # Main README
├── LICENSE              # License
└── CONTRIBUTING.md
```

---

## 📊 Current Status (Foundation Phase)

### ✅ Completed
- [x] Initial ECC → Kimi migration (2026-04-20)
- [x] GitHub repository creation (`eduardoabreu81/everything-kimi-code`)
- [x] Local clone at `C:\Users\Eduardo\OneDrive\Documentos\GitHub\everything-kimi-code`
- [x] General plan written (`PLANO_EKC.md`)
- [x] Decision: **NO fork** of `affaan-m/everything-claude-code`
- [x] EKC main agent created (`agents/ekc/ekc.yaml`) with 64 subagents
- [x] 4 flow skills created (`feature-dev`, `pr-review`, `github-code-reviewer`, `code-review`)

### 🔄 In progress / Next immediate steps
- [ ] Develop `ekc-cli` (interactive installer)
- [ ] Start Kimi-Mem implementation (Path C - complete fork)

---

## 🔧 Architectural Decisions Made

1. **Repo from scratch** (no fork of original ECC) — Claude-specific architecture does not apply to Kimi
2. **English as main language** — PT-BR as secondary
3. **Skills as primary workflow surface** — commands are legacy, agents are orchestrators
4. **Kimi-Mem: Path C (Full)** — complete fork of claude-mem with automatic session tracking
5. **Dual licensing:** MIT (ecosystem) + AGPL-3.0 (kimi-mem fork)

---

## 📂 Local Reference Sources

| File | Location | Description |
|------|----------|-------------|
| Migrated agents | `C:\Users\Eduardo\.kimi\agents\` | 64 .md + .yaml files |
| Migrated skills | `C:\Users\Eduardo\.kimi\skills\` | 202 directories with SKILL.md |
| Catalog | `C:\Users\Eduardo\.kimi\AGENTS_AND_SKILLS_CATALOGO.md` | Complete documentation |
| Migration tracker | `C:\Users\Eduardo\.kimi\MIGRATION_TRACKER.md` | Log of all migrations |
| Migration plan | `C:\Users\Eduardo\.kimi\MIGRATION_PLAN.md` | Plan for 3 priority commands |
| Kimi-Mem adaptation | `C:\Users\Eduardo\.kimi\KIMI_MEM_ADAPTATION_PLAN.md` | claude-mem fork plan |
| Session plans | `C:\Users\Eduardo\.kimi\plans\` | Plans generated in previous sessions |

---

## 🚀 How to resume work

When opening this project in Kimi Code:
1. Read `PLANO_EKC.md` for complete vision
2. Check the status of `agents/` and `skills/`
3. Run `scripts/validate-structure.js` when available
4. Keep `AGENTS.md` updated with new decisions

---

> **Note:** This is a living document. Update it whenever important decisions are made.

*Last updated: 2026-04-24*  
*Origin session: ECC → EKC Migration + Repo Foundation*
