# EKC — Everything Kimi Code

> **General Implementation Plan**  
> **Version:** 1.0  
> **Date:** 2026-04-24  
> **Status:** Foundation / Planning Phase  
> **Authors:** Eduardo + Kimi Code (EKC Founding Team)  

---

## Executive Summary

**EKC (Everything Kimi Code)** is an independent open-source ecosystem that converts, adapts, and expands the **Claude Code (ECC)** experience to the **Kimi CLI** and **Kimi VS Code Extension**.

Born from a massive migration on **2026-04-20**, EKC evolved into a standalone product maintained by the community.

**Current numbers:**
- **1 EKC main agent + 64 specialist subagents**
- **206 Skills** (202 original + 4 flow skills)
- **Kimi-Mem** (in development): complete fork of `claude-mem`

---

## Mission

> Make Kimi Code as powerful as — or more powerful than — the Claude Code ecosystem, preserving local autonomy, user privacy, and open-source extensibility.

## Objectives

1. **Functional parity:** Offer 100% of ECC agents, skills and commands adapted for Kimi
2. **Independence:** Work 100% offline/local, no proprietary cloud dependencies
3. **Extensibility:** Allow any developer to create EKC-format agents, skills and plugins
4. **Persistent memory:** Implement Kimi-Mem as long-term memory system
5. **Native integration:** Transparent support for Kimi CLI and VS Code Extension
6. **Complete documentation:** Everything documented in English and Portuguese

---

## Architecture Decisions

| Decision | Rationale |
|----------|-----------|
| **Repo from scratch** (no fork of ECC) | Claude-specific architecture does not apply to Kimi |
| **English as primary language** | Universal reach |
| **Skills as primary workflow surface** | Kimi's native extension mechanism |
| **Flow skills for workflows** | Replaces ECC commands (not available in Kimi) |
| **EKC main agent with subagents** | Makes all 64 specialist subagents available via `Agent` tool |
| **Kimi-Mem: Full Path (C)** | Complete fork of claude-mem with session tracking |
| **Dual licensing:** MIT + AGPL-3.0 | Permissive for ecosystem, copyleft for kimi-mem fork |

---

## Repository Structure

```
everything-kimi-code/
├── agents/              # 1 main agent + 64 specialist subagents (.md + .yaml)
├── skills/              # 206 skills (SKILL.md in subdirectories)
├── kimi-mem/            # claude-mem fork (AGPL-3.0)
├── packages/
│   ├── ekc-cli/         # EKC CLI installer
│   └── ekc-validator/   # Validation library
├── docs/                # Documentation (en + pt-BR)
├── templates/           # Templates for agents/skills
├── scripts/             # Installers and utilities
├── tests/               # Integration tests
├── AGENTS.md            # Project context (auto-loaded by Kimi)
├── PLANO_EKC.md         # This file
├── README.md            # Main README
├── LICENSE              # MIT
├── CONTRIBUTING.md
└── CHANGELOG.md
```

---

## Roadmap

### Phase 0: Foundation ✅
- [x] Initial ECC → Kimi migration (2026-04-20)
- [x] GitHub repository created
- [x] 64 specialist subagents migrated
- [x] 202 skills migrated
- [x] EKC main agent created (`agents/ekc.yaml`)
- [x] 4 flow skills created
- [x] Base documentation

### Phase 1: CLI and Validation
- [ ] Develop `ekc-cli` (`packages/ekc-cli/`)
  - `ekc install` — interactive installer
  - `ekc update` — updater
  - `ekc doctor` — environment diagnostics
  - `ekc status` — show installed components
  - `ekc validate` — validate custom agents/skills
- [ ] Develop `ekc-validator` library
- [ ] GitHub Actions CI/CD

### Phase 2: Kimi-Mem Full
- [ ] Fork claude-mem with adapted paths
- [ ] Session tracker (replaces Claude hooks)
- [ ] Native skill + agent for Kimi
- [ ] MCP server integration
- [ ] Integration tests

### Phase 3: Documentation and Community
- [ ] Complete docs in `docs/en/` and `docs/pt-BR/`
- [ ] Tutorial: "Creating your first EKC agent"
- [ ] Tutorial: "Creating your first EKC skill"
- [ ] GitHub Pages site for documentation

### Phase 4: VS Code Extension
- [ ] Research Kimi VS Code Extension integration
- [ ] Sidebar for available agents
- [ ] Quick-picks for skills
- [ ] Kimi-Mem integration within editor

### Phase 5: Polish and Release 1.0
- [ ] Beta testing
- [ ] Performance audit
- [ ] Release v1.0
- [ ] Community announcement

---

## How to Use

### Load the EKC main agent
```bash
kimi --agent-file agents/ekc.yaml
```

### Use flow skills
```
/flow:feature-dev         → Feature development workflow
/flow:pr-review           → Complete PR review
/flow:github-code-reviewer → GitHub PR review with scoring
/flow:code-review         → Generic code review
```

### Use regular skills
```
/skill:backend-patterns
/skill:security-review
/skill:django-patterns
```

---

## License

- **Agents, Skills, CLI, docs, templates:** MIT
- **kimi-mem/:** AGPL-3.0 (claude-mem fork)

---

> **Note:** This plan is a living document. It should be updated as the project evolves and the community contributes.

*Plan created: 2026-04-24*  
*Next review: After GitHub repo stabilization*
