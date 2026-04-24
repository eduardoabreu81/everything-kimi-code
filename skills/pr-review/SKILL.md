---
name: pr-review
description: Workflow de revisao completa de PR — orquestra 6 revisores especializados
 type: flow
---

# PR Review Workflow

Orquestra múltiplos revisores especializados para uma revisão completa de Pull Request.

```mermaid
flowchart TD
    A([BEGIN]) --> B[Detect Changes<br/>Identifique arquivos alterados via git diff]
    B --> C[Select Reviewers<br/>Escolha revisores baseado nos tipos de arquivo]
    C --> D[Parallel Review<br/>Execute revisores em paralelo]
    D --> E[Collect Findings<br/>Consolide issues, warnings e sugestões]
    E --> F{Issues críticas?}
    F -->|Sim| G[Critical Report<br/>Destaque issues bloqueantes]
    F -->|Não| H[Approval Report<br/>PR aprovado com sugestões]
    G --> I([END])
    H --> I
```

## Revisores por tipo de arquivo

| Tipo de arquivo | Revisores recomendados |
|-----------------|------------------------|
| `.py` | `python-reviewer`, `pr-test-analyzer` |
| `.ts`, `.tsx`, `.js` | `typescript-reviewer`, `pr-test-analyzer` |
| `.rs` | `rust-reviewer`, `pr-test-analyzer` |
| `.go` | `go-reviewer`, `pr-test-analyzer` |
| `.cpp`, `.h` | `cpp-reviewer`, `pr-test-analyzer` |
| `.cs` | `csharp-reviewer` |
| `.java` | `java-reviewer` |
| `.kt` | `kotlin-reviewer` |
| `.sql`, migrations | `database-reviewer` |
| `.yaml`, `.json` config | `security-reviewer` |
| Qualquer | `code-reviewer`, `silent-failure-hunter`, `type-design-analyzer` |

## Template de Output

1. **Issues Críticas** (bloqueantes)
2. **Issues Importantes** (devem ser corrigidas)
3. **Sugestões** (melhorias opcionais)
4. **Pontos Fortes** (o que está bem feito)
5. **Ação Recomendada** (aprovar, requisitar changes, etc.)
