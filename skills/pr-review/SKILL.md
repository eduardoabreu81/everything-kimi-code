---
name: pr-review
description: Complete PR review workflow — orchestrates 6 specialized reviewers
type: flow
---

# PR Review Workflow

Orchestrates multiple specialized reviewers for a complete Pull Request review.

```mermaid
flowchart TD
    A([BEGIN]) --> B[Detect Changes<br/>Identify changed files via git diff]
    B --> C[Select Reviewers<br/>Choose reviewers based on file types]
    C --> D[Parallel Review<br/>Execute reviewers in parallel]
    D --> E[Collect Findings<br/>Consolidate issues, warnings and suggestions]
    E --> F{Critical issues?}
    F -->|Yes| G[Critical Report<br/>Highlight blocking issues]
    F -->|No| H[Approval Report<br/>PR approved with suggestions]
    G --> I([END])
    H --> I
```

## Reviewers by file type

| File type | Recommended reviewers |
|-----------|----------------------|
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
| Any | `code-reviewer`, `silent-failure-hunter`, `type-design-analyzer` |

## Output template

1. **Critical Issues** (blocking)
2. **Important Issues** (should be fixed)
3. **Suggestions** (optional improvements)
4. **Strengths** (what is well done)
5. **Recommended Action** (approve, request changes, etc.)
