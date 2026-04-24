# 🧠 EKC — Everything Kimi Code

> **Plano Geral e Detalhado de Implementação**  
> **Versão:** 1.0  
> **Data:** 2026-04-24  
> **Status:** Fundação / Fase de Planejamento  
> **Autores:** Eduardo + Kimi Code (EKC Founding Team)  

---

## 📋 Sumário Executivo

O **EKC (Everything Kimi Code)** é um ecossistema open-source e independente que converte, adapta e expande a experiência do **Claude Code (ECC)** para o **Kimi CLI** e **Kimi VS Code Extension**. Trata-se de um projeto de migração massiva, documentada e estruturada, que inclui:

- **64 Agents especializados** para revisão, build, arquitetura, segurança, git e orquestração
- **202 Skills reutilizáveis** cobrindo backend, frontend, DevOps, segurança, healthcare, negócios e mídia
- **Kimi-Mem**: fork completo do `claude-mem` com memória persistente, busca semântica e MCP server nativo
- **Infraestrutura de instalação e atualização** integrada ao workflow do desenvolvedor

O EKC nasce da migração realizada em 20/04/2026 e evolui como um produto **standalone e independente** do ECC, documentado e mantido pela comunidade Kimi.

---

## 🎯 Missão

> Tornar o Kimi Code tão poderoso quanto — ou mais poderoso que — o ecossistema Claude Code, preservando a autonomia local, a privacidade do usuário e a extensibilidade open-source.

### Objetivos Específicos

1. **Paridade Funcional:** Oferecer 100% dos agents, skills e commands do ECC *adaptados e aprimorados* para o Kimi
2. **Independência:** Funcionar 100% offline/local, sem dependência de serviços cloud proprietários
3. **Extensibilidade:** Permitir que qualquer dev crie agents, skills e plugins no formato EKC
4. **Memória Persistente:** Implementar o Kimi-Mem como sistema de memória de longo prazo
5. **Integração Nativa:** Suporte transparente ao Kimi CLI e VS Code Extension
6. **Documentação Completa:** Tudo documentado em português e inglês

---

## 🏗️ Contexto e Histórico

### A Migração ECC → Kimi (20/04/2026)

O Claude Code possui um ecossistema maduro de plugins com:
- ~19 skills oficiais + ~8 skills de code-plugins
- ~14 agents oficiais + ~14 agents de code-plugins
- ~17 commands customizáveis
- ~5 hooks (SessionStart, PostToolUse, Stop, PreToolUse, UserPromptSubmit)
- Sistema de memória persistente (`claude-mem`)

O Kimi CLI, por outro lado, possui:
- Suporte nativo a agents (`.md` + `.yaml`)
- Suporte nativo a skills (diretórios com `SKILL.md`)
- Infraestrutura MCP (Model Context Protocol)
- **Não possui:** commands customizáveis nem hooks automáticos

### Desafios Técnicos Superados

| Desafio | Solução EKC |
|---------|-------------|
| Commands não existem no Kimi | Convertidos em **Agents Orquestradores** |
| Hooks não existem no Kimi | Convertidos em **Agents Especializados** + **Skills Manuais** |
| Agents no Claude são apenas `.md` | Adicionado `.yaml` com configuração de tools |
| Template engine Jinja2 quebrava com `${...}` | Escape e substituição por concatenação de strings |
| `Bash` tool no Claude | Renomeado para `Shell` no Kimi |
| `$ARGUMENTS` no Claude | Substituído por passagem via `prompt` na `Agent` tool |
| Referências a modelos Anthropic (Haiku/Sonnet) | Removidas para compatibilidade genérica |

### Resultado da Migração Inicial

- **202 skills** (171 de origem ECC + 31 community/outras)
- **64 agents** (pares `.md` + `.yaml`)
- **20 migrações documentadas** no `MIGRATION_TRACKER.md`

---

## 📦 Escopo do Projeto EKC

### Incluído no EKC

```
┌─────────────────────────────────────────────────────────────┐
│  EKC — Everything Kimi Code                                 │
├─────────────────────────────────────────────────────────────┤
│  1. AGENTS (64)                                             │
│     ├─ Code Review & Qualidade (14)                         │
│     ├─ Arquitetura & Design (7)                             │
│     ├─ Build & Debug (8)                                    │
│     ├─ Segurança (2)                                        │
│     ├─ Git Workflow (4)                                     │
│     ├─ Reviewers por Linguagem (8)                          │
│     ├─ Meta-Agents & Orquestração (8)                       │
│     ├─ Open Source (3)                                      │
│     ├─ Documentação & Output (4)                            │
│     ├─ Healthcare (1)                                       │
│     └─ Ecossistema Kimi/Claude (5)                          │
├─────────────────────────────────────────────────────────────┤
│  2. SKILLS (202)                                            │
│     ├─ Backend & APIs (33)                                  │
│     ├─ Frontend & Mobile (16)                               │
│     ├─ DevOps & Deploy (9)                                  │
│     ├─ Segurança & Compliance (12)                          │
│     ├─ Testes & Qualidade (20)                              │
│     ├─ Data & Analytics (4)                                 │
│     ├─ Ecossistema Kimi/Claude (53)                         │
│     ├─ Healthcare (5)                                       │
│     ├─ Logística & Supply Chain (8)                         │
│     ├─ Business & Marketing (20)                            │
│     ├─ AI, Media & Criação (7)                              │
│     └─ Outros (15)                                          │
├─────────────────────────────────────────────────────────────┤
│  3. KIMI-MEM (Fork Completo do claude-mem)                  │
│     ├─ Worker Service (Express HTTP API)                    │
│     ├─ SQLite + ChromaDB ( embeddings vetoriais )           │
│     ├─ MCP Server (14 tools)                                │
│     ├─ Web Viewer (localhost)                               │
│     ├─ Session Tracker (substitui hooks do Claude)          │
│     ├─ Skill kimi-mem (interface nativa)                    │
│     └─ Agent memory-orchestrator                            │
├─────────────────────────────────────────────────────────────┤
│  4. INFRAESTRUTURA                                          │
│     ├─ Instalador interativo (`npx ekc install`)            │
│     ├─ Atualizador (`ekc update`)                           │
│     ├─ Validador de estrutura (`ekc validate`)              │
│     ├─ CLI Helper (`ekc doctor`, `ekc status`)              │
│     └─ Documentação completa (docs/)                        │
└─────────────────────────────────────────────────────────────┘
```

### Excluído / Fora de Escopo

- `chief-of-staff`: Específico do ecossistema Claude (hooks `/mail`, `/slack`)
- `harness-optimizer`: Depende de command `/harness-audit` do Claude
- Integração direta com serviços Anthropic/Claude API
- LSPs (Language Server Protocols) — não aplicáveis ao Kimi CLI

---

## 🗂️ Estrutura do Repositório

```
everything-kimi-code/               # Repo principal no GitHub
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                  # Testes e validação
│   │   ├── release.yml             # Publicação de releases
│   │   └── sync-skills.yml         # Sincronização de skills
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
│
├── agents/                         # 64 agents (pares .md + .yaml)
│   ├── code-reviewer/
│   │   ├── agent.md
│   │   └── agent.yaml
│   ├── feature-dev/
│   │   ├── agent.md
│   │   └── agent.yaml
│   └── ... (62 pastas restantes)
│
├── skills/                         # 202 skills
│   ├── backend-patterns/
│   │   └── SKILL.md
│   ├── django-patterns/
│   │   └── SKILL.md
│   └── ... (200 pastas restantes)
│
├── kimi-mem/                       # Fork do claude-mem (AGPL-3.0)
│   ├── worker/                     # Serviço Express (porta 37777)
│   ├── mcp-server/                 # MCP stdio server
│   ├── web-viewer/                 # Interface web
│   ├── scripts/
│   │   ├── session-tracker.mjs     # Monitora ~/.kimi/sessions/
│   │   ├── observation-capture.mjs # Captura de contexto
│   │   └── context-injector.mjs    # Injeta memória no AGENTS.md
│   ├── package.json
│   ├── tsconfig.json
│   └── README.md
│
├── packages/
│   ├── ekc-cli/                    # CLI do EKC (Node.js/Bun)
│   │   ├── src/
│   │   ├── bin/
│   │   └── package.json
│   └── ekc-validator/              # Lib de validação de agents/skills
│       ├── src/
│       └── package.json
│
├── docs/
│   ├── pt-BR/
│   │   ├── index.md
│   │   ├── instalacao.md
│   │   ├── criando-agents.md
│   │   ├── criando-skills.md
│   │   └── kimi-mem.md
│   ├── en/
│   │   └── ... (mirror em inglês)
│   └── arquitetura/
│       ├── ecc-vs-kimi.md
│       ├── migration-guide.md
│       └── template-engine.md
│
├── templates/
│   ├── AGENTS.md                   # Template para projetos
│   ├── agent-template.md           # Template para criar novo agent
│   ├── skill-template.md           # Template para criar nova skill
│   └── plugin-manifest.json
│
├── scripts/
│   ├── install.ps1                 # Windows installer
│   ├── install.sh                  # Linux/Mac installer
│   ├── migrate-from-ecc.sh         # Migra do ECC para EKC
│   └── validate-structure.js       # Valida estrutura do repo
│
├── tests/
│   ├── agents/
│   ├── skills/
│   └── integration/
│
├── README.md
├── LICENSE                         # AGPL-3.0 (por causa do kimi-mem)
├── LICENSE-COMMERCIAL.md           # Licença dual opcional
├── CONTRIBUTING.md
├── CHANGELOG.md
└── PLANO_EKC.md                    # Este arquivo
```

---

## 🔧 Componentes Detalhados

### 1. Agents (64)

Cada agent é um par de arquivos:
- **`agent.md`**: System prompt completo em português (ou inglês quando apropriado)
- **`agent.yaml`**: Configuração de tools, modelo, e metadados

#### Categorias:

**Code Review & Qualidade (14)**
`code-reviewer`, `pr-review`, `comment-analyzer`, `pr-test-analyzer`, `silent-failure-hunter`, `type-design-analyzer`, `conversation-analyzer`, `code-simplifier`, `refactor-cleaner`, `performance-optimizer`, `a11y-architect`, `database-reviewer`, `seo-specialist`, `flutter-reviewer`

**Arquitetura & Design (7)**
`architect`, `code-architect`, `planner`, `feature-dev`, `gan-planner`, `gan-generator`, `gan-evaluator`

**Build & Debug (8)**
`build-error-resolver`, `cpp-build-resolver`, `dart-build-resolver`, `go-build-resolver`, `java-build-resolver`, `kotlin-build-resolver`, `pytorch-build-resolver`, `rust-build-resolver`

**Segurança (2)**
`security-advisor`, `security-reviewer`

**Git Workflow (4)**
`git-commit`, `git-commit-push-pr`, `git-clean-gone`, `github-code-reviewer`

**Reviewers por Linguagem (8)**
`python-reviewer`, `rust-reviewer`, `go-reviewer`, `cpp-reviewer`, `csharp-reviewer`, `java-reviewer`, `kotlin-reviewer`, `typescript-reviewer`

**Meta-Agents & Orquestração (8)**
`ecc-agents`, `loop-operator`, `iterative-loop`, `agent-creator`, `plugin-validator`, `skill-reviewer`, `agent-sdk-verifier-py`, `agent-sdk-verifier-ts`

**Open Source (3)**
`opensource-forker`, `opensource-sanitizer`, `opensource-packager`

**Documentação & Output (4)**
`doc-updater`, `docs-lookup`, `output-style-guide`, `revise-project-docs`

**Healthcare (1)**
`healthcare-reviewer`

**Ecossistema EKC (5)**
`plugin-creator`, `project-starter`, `tdd-guide`, `e2e-runner`, `code-explorer`

### 2. Skills (202)

Cada skill é um diretório com `SKILL.md` contendo:
- Frontmatter YAML com `name`, `description`, `version`
- Instruções detalhadas
- Exemplos de uso
- Referências cruzadas

### 3. Kimi-Mem (Fork Completo)

Baseado no `claude-mem` (AGPL-3.0), com as seguintes adaptações:

| Componente Original | Adaptação EKC |
|--------------------|---------------|
| Hook System (Claude) | `session-tracker.mjs` + `observation-capture.mjs` |
| `~/.claude-mem` | `~/.ekc/mem` |
| `CLAUDE_PLUGIN_ROOT` | `EKC_PLUGIN_ROOT` |
| SDKAgent (Anthropic) | API genérica ou processamento síncrico |
| `plugin/.mcp.json` | `.ekc/mcp.json` |
| Auto-capture (PostToolUse) | Parsing de `~/.kimi/sessions/*/wire.jsonl` |
| Context Injection (SessionStart) | Atualização automática de `AGENTS.md` |

**Fases de Implementação do Kimi-Mem:**
1. **Fase 1 (MVP):** MCP Bridge — registrar MCP server no Kimi (~1-2 dias)
2. **Fase 2:** Skill `kimi-mem` nativa com comandos `/kimi-mem:save`, `/kimi-mem:search` (~2-3 dias)
3. **Fase 3:** Agent `memory-orchestrator` para captura semi-automática (~1-2 dias)
4. **Fase 4:** Worker adaptation — fork completo do claude-mem (~2-3 dias)
5. **Fase 5:** Session Tracking Avançado — parsing automático de logs (~3-5 dias)
6. **Fase 6:** Polish — instalador, documentação, testes (~1-2 dias)

**Estimativa total:** 10-17 dias de desenvolvimento focado.

---

## 🗓️ Roadmap Geral do EKC

### Fase 0: Fundação (Semanas 1-2)
- [x] Migração inicial ECC → Kimi (20/04/2026)
- [ ] Criar repositório `everything-kimi-code` no GitHub
- [ ] Estruturar diretórios (`agents/`, `skills/`, `kimi-mem/`, `docs/`)
- [ ] Commit inicial com 64 agents + 202 skills
- [ ] Criar `README.md` bilíngue (PT/EN)
- [ ] Definir licenciamento (AGPL-3.0 + dual commercial opcional)
- [ ] Criar `CONTRIBUTING.md` e templates de PR/issue

### Fase 1: CLI e Validação (Semanas 2-3)
- [ ] Desenvolver `ekc-cli`:
  - `ekc install` — instalador interativo (seleciona agents/skills)
  - `ekc update` — atualiza para última versão
  - `ekc doctor` — diagnóstico de instalação
  - `ekc status` — mostra o que está instalado
  - `ekc validate` — valida estrutura de agents/skills customizados
- [ ] Desenvolver `ekc-validator` (lib reutilizável)
- [ ] CI/CD com GitHub Actions para validar PRs

### Fase 2: Kimi-Mem Full (Semanas 3-5)
- [ ] Fork do claude-mem com paths adaptados
- [ ] Implementar session tracker (substituto dos hooks)
- [ ] Criar skill e agent nativos do Kimi
- [ ] MCP server integrado
- [ ] Testes de integração

### Fase 3: Documentação e Comunidade (Semanas 4-6)
- [ ] Documentação completa em `docs/pt-BR/` e `docs/en/`
- [ ] Tutorial "Criando seu primeiro agent EKC"
- [ ] Tutorial "Criando sua primeira skill EKC"
- [ ] Vídeos/demo de uso (opcional)
- [ ] Site estático (GitHub Pages) para documentação

### Fase 4: VS Code Extension (Semanas 6-8)
- [ ] Pesquisar integração com Kimi VS Code Extension
- [ ] Criar sidebar para agents disponíveis
- [ ] Quick-picks para skills
- [ ] Integração com Kimi-Mem dentro do editor

### Fase 5: Polish e Release 1.0 (Semanas 8-10)
- [ ] Beta testing com usuários
- [ ] Performance audit (tempo de carregamento de agents/skills)
- [ ] Release v1.0
- [ ] Anúncio nas comunidades

---

## 💻 Integração com Kimi CLI e VS Code

### Kimi CLI

O Kimi CLI já carrega automaticamente:
- Agents de `~/.kimi/agents/` (ou `EKC_AGENTS_PATH`)
- Skills de `~/.kimi/skills/` (ou `EKC_SKILLS_PATH`)
- `AGENTS.md` do diretório atual

O instalador EKC irá:
1. Clonar o repo `everything-kimi-code`
2. Symlink (ou copiar) `agents/*` → `~/.kimi/agents/`
3. Symlink (ou copiar) `skills/*` → `~/.kimi/skills/`
4. Registrar o MCP do Kimi-Mem: `kimi mcp add ekc-mem stdio -- bun ...`
5. Criar/atualizar `~/.kimi/AGENTS_AND_SKILLS_CATALOGO.md`

### VS Code Extension

Pesquisar se o Kimi VS Code permite:
- Custom agents via workspace settings
- Skills via workspace folders
- Se não houver API oficial, documentar workaround via `tasks.json` + terminal integrado

---

## 📥 Instalação (Visão Futura)

### Opção 1: Instalador Interativo (Recomendado)
```bash
npx ekc install
```
Prompts interativos para selecionar quais agents/skills instalar.

### Opção 2: Instalação Completa
```bash
git clone https://github.com/eduardo/ekc.git ~/.ekc
cd ~/.ekc && ./scripts/install.sh
```

### Opção 3: Por Componente
```bash
# Apenas agents de code review
npx ekc install --agents "code-reviewer,pr-review,security-reviewer"

# Apenas skills de backend
npx ekc install --skills "django-*,springboot-*"

# Apenas kimi-mem
npx ekc install --kimi-mem
```

---

## 📄 Licenciamento

### Kimi-Mem (Fork do claude-mem)
- **AGPL-3.0** (conforme licença original do claude-mem)
- Código disponível em `kimi-mem/`
- Qualquer modificação deve ser publicada

### Agents e Skills
- **MIT** ou **Apache-2.0** (a definir)
- Maioria é conteúdo original ou adaptado do ECC (que é open)
- Skills de negócios/marketing podem ter origem diversa — auditar proveniência

### Ecossistema EKC (CLI, docs, templates)
- **MIT** (permissivo para adoção comercial)

### Dual License (Opcional Futuro)
- Oferecer licença comercial para empresas que não querem AGPL no Kimi-Mem

---

## 🤝 Governança e Contribuição

### Estrutura
- **Maintainer:** Eduardo (fundador)
- **Reviewers:** Convida devs da comunidade Kimi/Claude
- **Decision-making:** RFCs para mudanças arquiteturais

### Como Contribuir
1. Fork do repo
2. Criação seguindo templates (`templates/agent-template.md`, `templates/skill-template.md`)
3. Validação local: `npx ekc validate`
4. PR com descrição clara e testes
5. Review por pelo menos 1 maintainer

### Critérios de Aceitação
- Agent: `.md` + `.yaml`, system prompt em português (PT-BR preferencial), tools mínimas documentadas
- Skill: `SKILL.md` com frontmatter válido, exemplos de uso, descrição em PT-BR
- Kimi-Mem: testes de integração passando, documentação atualizada

---

## ⚠️ Riscos e Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Kimi CLI mudar formato de agents/skills | Média | Alto | Manter abstração no `ekc-cli`, adaptador automático |
| Claude-mem AGPL causar rejeição corporativa | Média | Médio | Oferecer dual-license, separar kimi-mem em repo próprio |
| Manutenção ficar sobrecarregada (1 pessoa) | Alta | Alto | Documentar extensivamente, recrutar maintainers cedo |
| VS Code Extension não suportar extensibilidade | Média | Médio | Focar 100% no CLI primeiro, VS Code como phase 2 |
| Overlap com plugins oficiais do Kimi | Baixa | Baixo | Diferenciar via quantidade, qualidade e memória persistente |

---

## ✅ Próximos Passos Imediatos

1. **Criar o repositório no GitHub** (`everything-kimi-code` ou `ekc`)
2. **Copiar a estrutura atual** de `C:\Users\Eduardo\.kimi\` para o repo
3. **Inicializar git** e fazer o primeiro commit
4. **Criar o `README.md`** profissional
5. **Escolher a licença** definitiva para agents/skills
6. **Começar o desenvolvimento do `ekc-cli`** (instalador)
7. **Iniciar Fase 1 do Kimi-Mem** (MCP Bridge)

---

## 🚀 Visão de Longo Prazo

- **EKC v2.0:** Marketplace de skills e agents (instalação via `npx ekc install <skill>@<version>`)
- **EKC v3.0:** Integração com outros LLMs locais (Ollama, LM Studio)
- **EKC v4.0:** IDE própria ou fork do VS Code com Kimi + EKC nativo
- **Comunidade:** 100+ contribuidores, 500+ skills, suporte a 10+ linguagens

---

> **Nota Final:** Este plano é um documento vivo. Ele deve ser atualizado conforme o projeto evolui, decisões são tomadas e a comunidade contribui. A migração do dia 20/04/2026 foi apenas o início.

---

*Plano criado em: 2026-04-24*  
*Próxima revisão: Após criação do repositório GitHub*
