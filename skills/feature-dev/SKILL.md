---
name: feature-dev
description: Workflow completo de desenvolvimento de features — do discovery a entrega com 7 fases
 type: flow
---

# Feature Development Workflow

Workflow de desenvolvimento de features com 7 fases, orquestrando múltiplos agents do EKC.

```mermaid
flowchart TD
    A([BEGIN]) --> B[Discovery<br/>Entenda o contexto e objetivo da feature]
    B --> C[Exploration<br/>Explore o codebase existente]
    C --> D[Questions<br/>Faça perguntas clarificadoras ao usuário]
    D --> E{Usuário responde?}
    E -->|Sim| F[Architecture<br/>Proponha a arquitetura e design]
    E -->|Não| D
    F --> G{Usuário aprova?}
    G -->|Sim| H[Implementation<br/>Implemente a feature]
    G -->|Não| F
    H --> I[Review<br/>Revise qualidade, segurança e performance]
    I --> J{Passou na review?}
    J -->|Não| H
    J -->|Sim| K[Summary<br/>Documente o que foi feito]
    K --> L([END])
```

## Instruções por nó

**Discovery**: Use `code-explorer` para entender o contexto do projeto.

**Exploration**: Use `code-explorer` + `architect` para mapear o codebase.

**Questions**: Use `AskUserQuestion` para levantar requisitos faltantes.

**Architecture**: Use `architect` ou `code-architect` para propor a solução. Aguarde aprovação.

**Implementation**: Use `coder` subagent ou implemente diretamente. Siga TDD quando possível.

**Review**: Use `code-reviewer`, `security-reviewer` e `type-design-analyzer` para validar.

**Summary**: Use `doc-updater` para atualizar documentação.
