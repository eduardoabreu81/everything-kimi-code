---
name: github-code-reviewer
description: GitHub PR review with 5 parallel reviewers + 0-100 scoring
type: flow
---

# GitHub Code Review Workflow

Automated GitHub PR review using GitHub CLI (`gh`), with confidence scoring.

```mermaid
flowchart TD
    A([BEGIN]) --> B[Check Eligibility<br/>Verify gh CLI is installed and authenticated]
    B --> C{Eligible?}
    C -->|No| D[Abort<br/>Inform user to install gh CLI]
    C -->|Yes| E[View PR<br/>Collect PR info via gh pr view]
    E --> F[Read Context<br/>Read CLAUDE.md / AGENTS.md from project]
    F --> G[Parallel Review<br/>Execute 5 reviewers in parallel]
    G --> H[Scoring<br/>Score the PR 0-100 based on rubric]
    H --> I{Score >= 80?}
    I -->|Yes| J[Post Comment<br/>Comment approval on PR]
    I -->|No| K[Post Comment<br/>Comment with issues and score]
    J --> L([END])
    K --> L
```

## Scoring Rubric (0-100)

| Criterion | Weight |
|-----------|--------|
| Correctness | 25% |
| Code quality | 20% |
| Tests | 20% |
| Security | 15% |
| Documentation | 10% |
| Performance | 10% |

## Parallel reviewers

1. `code-reviewer` — General quality
2. `security-reviewer` — Vulnerabilities
3. `pr-test-analyzer` — Test coverage
4. `type-design-analyzer` — Type design
5. `silent-failure-hunter` — Silent failures

## PR comment format

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
