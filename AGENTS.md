# EKC — Everything Kimi Code

> **Contexto de Projeto** — Este arquivo é carregado automaticamente em toda sessão do Kimi Code.

---

## 🤖 Identidade do Assistente (IMPORTANTE)

> **EU SOU O KIMI CODE** — o assistente de IA do ecossistema Kimi (Kimi CLI / Kimi VS Code Extension).
>
> **EU NÃO SOU O ECC** (Everything Claude Code). O ECC é o ecossistema do Claude Code, criado por Affaan M, que serviu como **fonte de inspiração e origem** dos agents e skills.
>
> **O EKC é o projeto deste repositório** — uma reimaginação independente do ECC para o ecossistema Kimi, liderado por Eduardo. Meu papel é ajudar a construir, manter e evoluir o EKC.

---

## 🎯 O que é este projeto

O **EKC (Everything Kimi Code)** é um ecossistema open-source e **independente** que converte, adapta e expande a experiência do **Claude Code (ECC)** para o **Kimi CLI** e **Kimi VS Code Extension**.

Nasceu de uma migração massiva realizada em **20/04/2026**, onde o ecossistema ECC foi portado e reimaginado para o formato nativo do Kimi CLI.

### Números atuais
- **64 Agents** especializados (revisão, build, arquitetura, segurança, git, orquestração)
- **202 Skills** reutilizáveis (backend, frontend, DevOps, segurança, healthcare, negócios, mídia)
- **Kimi-Mem** (em desenvolvimento): fork completo do `claude-mem` com memória persistente

---

## 🏗️ Histórico da Migração (20/04/2026)

### Desafios superados

| Aspecto | Claude Code | Kimi CLI | Adaptação feita |
|---------|------------|----------|-----------------|
| **Commands** | `/feature-dev`, `/review-pr` | ❌ Não existe | Viraram **Agents Orquestradores** |
| **Hooks** | `SessionStart`, `PostToolUse`, `Stop` | ❌ Infra limitada | Viraram **Agents Especializados** |
| **Agents** | Apenas `.md` | `.md` + `.yaml` | Criado par para cada um |
| **Skills** | Frontmatter YAML | Frontmatter YAML similar | Port direto |
| **Ferramentas** | `Bash`, `Read`, `Task` | `Shell`, `ReadFile`, `Agent` | Nomes e semântica traduzidos |
| **Argumentos** | `$ARGUMENTS` | Passado via `prompt` na `Agent` tool | Adaptado |

### Migrações concluídas
- **17 skills** migradas do ECC (writing-rules, playground, build-mcp-*, claude-md-improver, etc.)
- **13 agents** criados/adaptados
- **8 commands** migrados para agents (feature-dev, pr-review, github-code-reviewer, git-commit, etc.)
- **3 hooks** adaptados para agents (security-advisor, output-style-guide, iterative-loop)

### O que foi removido
- `chief-of-staff`: específico do ecossistema Claude (hooks `/mail`, `/slack`)
- `harness-optimizer`: dependia do command `/harness-audit` do Claude

---

## 📁 Estrutura do Repositório

```
everything-kimi-code/
├── agents/              # 64 agents (.md + .yaml)
├── skills/              # 202 skills (SKILL.md em subdiretórios)
├── kimi-mem/            # Fork do claude-mem (AGPL-3.0)
├── packages/
│   ├── ekc-cli/         # CLI do EKC
│   └── ekc-validator/   # Lib de validação
├── docs/                # Documentação (pt-BR + en)
├── templates/           # Templates para criar agents/skills
├── scripts/             # Installers (install.ps1, install.sh)
├── tests/               # Testes de integração
├── AGENTS.md            # Este arquivo
├── PLANO_EKC.md         # Plano geral detalhado
├── README.md            # README principal
├── LICENSE              # Licença
└── CONTRIBUTING.md
```

---

## 📊 Status Atual (Fase de Fundação)

### ✅ Concluído
- [x] Migração inicial ECC → Kimi (20/04/2026)
- [x] Criação do repositório GitHub (`eduardoabreu81/everything-kimi-code`)
- [x] Clone local em `C:\Users\Eduardo\OneDrive\Documentos\GitHub\everything-kimi-code`
- [x] Plano geral escrito (`PLANO_EKC.md`)
- [x] Decisão: **NÃO fazer fork** do `affaan-m/everything-claude-code`

### 🔄 Em andamento / Próximos passos imediatos
- [x] Copiar estrutura de agents de `C:\Users\Eduardo\.kimi\agents\` → `agents/`
- [x] Copiar estrutura de skills de `C:\Users\Eduardo\.kimi\skills\` → `skills/`
- [x] Criar `README.md` profissional (bilíngue PT/EN)
- [x] Definir licença definitiva (MIT para agents/skills, AGPL-3.0 para kimi-mem)
- [x] Criar `CONTRIBUTING.md`
- [x] Criar `CHANGELOG.md`
- [x] Commit inicial e push
- [ ] Desenvolver `ekc-cli` (instalador interativo)
- [ ] Iniciar implementação do Kimi-Mem (Caminho C - fork completo)

---

## 🔧 Decisões Arquiteturais Tomadas

1. **Repo do zero** (sem fork do ECC original) — arquitetura Claude-specific não se aplica ao Kimi
2. **PT-BR como idioma principal** — EN como secundário
3. **Skills como workflow surface principal** — commands são legado, agents são orquestradores
4. **Kimi-Mem: Caminho C (Full)** — fork completo do claude-mem com session tracking automático
5. **Licenciamento dual:** MIT (ecossistema) + AGPL-3.0 (kimi-mem fork)

---

## 📂 Fontes de Referência Locais

| Arquivo | Local | Descrição |
|---------|-------|-----------|
| Agents migrados | `C:\Users\Eduardo\.kimi\agents\` | 64 arquivos .md + .yaml |
| Skills migradas | `C:\Users\Eduardo\.kimi\skills\` | 202 diretórios com SKILL.md |
| Catálogo | `C:\Users\Eduardo\.kimi\AGENTS_AND_SKILLS_CATALOGO.md` | Documentação completa |
| Tracker de migração | `C:\Users\Eduardo\.kimi\MIGRATION_TRACKER.md` | Log de todas as migrações |
| Plano de migração | `C:\Users\Eduardo\.kimi\MIGRATION_PLAN.md` | Plano dos 3 commands prioritários |
| Adaptação Kimi-Mem | `C:\Users\Eduardo\.kimi\KIMI_MEM_ADAPTATION_PLAN.md` | Plano do fork claude-mem |
| Planos de sessão | `C:\Users\Eduardo\.kimi\plans\` | Planos gerados em sessões anteriores |

---

## 🚀 Como retomar o trabalho

Ao abrir este projeto no Kimi Code:
1. Leia `PLANO_EKC.md` para visão completa
2. Verifique o estado de `agents/` e `skills/`
3. Execute `scripts/validate-structure.js` quando disponível
4. Mantenha o `AGENTS.md` atualizado com decisões novas

---

> **Nota:** Este é um documento vivo. Atualize sempre que decisões importantes forem tomadas.

*Última atualização: 2026-04-24*  
*Sessão de origem: Retomada EKC — Estruturação completa do repo*
