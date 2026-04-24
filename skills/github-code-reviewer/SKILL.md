---
name: github-code-reviewer
description: Review de PR no GitHub com 5 revisores paralelos + scoring 0-100
 type: flow
---

# GitHub Code Review Workflow

Review automatizado de PR no GitHub usando GitHub CLI (`gh`), com scoring de confiança.

```mermaid
flowchart TD
    A([BEGIN]) --> B[Check Eligibility<br/>Verifique se gh CLI esta instalado e autenticado]
    B --> C{Elegivel?}
    C -->|Não| D[Abort<br/>Informe o usuario para instalar gh CLI]
    C -->|Sim| E[View PR<br/>Colete informacoes do PR via gh pr view]
    E --> F[Read Context<br/>Leia CLAUDE.md / AGENTS.md do projeto]
    F --> G[Parallel Review<br/>Execute 5 revisores em paralelo]
    G --> H[Scoring<br/>Pontue o PR 0-100 baseado na rubrica]
    H --> I{Score >= 80?}
    I -->|Sim| J[Post Comment<br/>Comente aprovacao no PR]
    I -->|Não| K[Post Comment<br/>Comente com issues e score]
    J --> L([END])
    K --> L
```

## Rubrica de Scoring (0-100)

| Critério | Peso |
|----------|------|
| Corretude | 25% |
| Qualidade de código | 20% |
| Testes | 20% |
| Segurança | 15% |
| Documentação | 10% |
| Performance | 10% |

## Revisores paralelos

1. `code-reviewer` — Qualidade geral
2. `security-reviewer` — Vulnerabilidades
3. `pr-test-analyzer` — Cobertura de testes
4. `type-design-analyzer` — Design de tipos
5. `silent-failure-hunter` — Falhas silenciosas

## Formato do comentário no PR

```markdown
## 🤖 EKC Code Review — Score: XX/100

### Critical Issues
- ...

### Important Issues
- ...

### Suggestions
- ...

### Strengths
- ...

**Verdict:** [APPROVE / REQUEST_CHANGES / COMMENT]
```
