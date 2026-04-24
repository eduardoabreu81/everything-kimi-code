# EKC — Everything Kimi Code

> **English below** ⬇️

---

## 🇧🇷 Português

O **EKC (Everything Kimi Code)** é um ecossistema open-source que converte, adapta e expande a experiência do **Claude Code (ECC)** para o **Kimi CLI** e **Kimi VS Code Extension**.

### 🚀 O que está incluído

- **64 Agents especializados** — revisão de código, arquitetura, build, segurança, Git e orquestração
- **202 Skills reutilizáveis** — backend, frontend, DevOps, segurança, healthcare, negócios, mídia e mais
- **Kimi-Mem (em desenvolvimento)** — fork do `claude-mem` com memória persistente e busca semântica
- **CLI e validadores** — instalador, atualizador e diagnosticador de ambiente

### 📦 Instalação (em breve)

```bash
# Instalador interativo (futuro)
npx ekc install

# Ou clone direto
git clone https://github.com/eduardoabreu81/everything-kimi-code.git ~/.ekc
cd ~/.ekc && ./scripts/install.sh
```

### 📁 Estrutura do Repositório

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
├── scripts/             # Installers e utilitários
└── tests/               # Testes de integração
```

### 🤝 Como Contribuir

Leia [CONTRIBUTING.md](CONTRIBUTING.md) para guidelines de contribuição.

### 📄 Licença

- **Agents, Skills, CLI, docs, templates:** MIT
- **kimi-mem/**: AGPL-3.0 (fork do claude-mem)

Veja [LICENSE](LICENSE) para detalhes completos.

---

## 🇺🇸 English

**EKC (Everything Kimi Code)** is an open-source ecosystem that converts, adapts, and expands the **Claude Code (ECC)** experience to the **Kimi CLI** and **Kimi VS Code Extension**.

### 🚀 What's Included

- **64 Specialized Agents** — code review, architecture, build, security, Git, and orchestration
- **202 Reusable Skills** — backend, frontend, DevOps, security, healthcare, business, media, and more
- **Kimi-Mem (in development)** — fork of `claude-mem` with persistent memory and semantic search
- **CLI and Validators** — installer, updater, and environment diagnostics

### 📦 Installation (coming soon)

```bash
# Interactive installer (future)
npx ekc install

# Or clone directly
git clone https://github.com/eduardoabreu81/everything-kimi-code.git ~/.ekc
cd ~/.ekc && ./scripts/install.sh
```

### 🤝 Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

### 📄 License

- **Agents, Skills, CLI, docs, templates:** MIT
- **kimi-mem/**: AGPL-3.0 (claude-mem fork)

See [LICENSE](LICENSE) for full details.

---

*Última atualização / Last updated: 2026-04-24*
