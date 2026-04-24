---
name: code-review
description: Code review generico com revisores especializados por linguagem
 type: flow
---

# Code Review Workflow

Revisão de código genérica que detecta a linguagem e escala revisores especializados.

```mermaid
flowchart TD
    A([BEGIN]) --> B[Identify Language<br/>Detecte a linguagem dos arquivos]
    B --> C[Select Specialist<br/>Escolha o revisor especializado]
    C --> D[Review<br/>Execute a revisao focada]
    D --> E[Cross-Cutting Checks<br/>Execute verificacoes cross-cutting]
    E --> F[Report<br/>Consolide findings]
    F --> G([END])
```

## Mapeamento linguagem → revisor

| Extensão | Revisor especializado |
|----------|----------------------|
| `.py` | `python-reviewer` |
| `.ts`, `.tsx`, `.js`, `.jsx` | `typescript-reviewer` |
| `.rs` | `rust-reviewer` |
| `.go` | `go-reviewer` |
| `.cpp`, `.h`, `.hpp`, `.c` | `cpp-reviewer` |
| `.cs` | `csharp-reviewer` |
| `.java` | `java-reviewer` |
| `.kt` | `kotlin-reviewer` |
| `.dart` | `flutter-reviewer` |
| Outros / Misto | `code-reviewer` |

## Verificações cross-cutting (sempre)

- `security-reviewer` — vulnerabilidades
- `silent-failure-hunter` — falhas silenciosas
- `type-design-analyzer` — design de tipos
- `performance-optimizer` — performance crítica

## Output

Template: Critical → Important → Suggestions → Strengths
