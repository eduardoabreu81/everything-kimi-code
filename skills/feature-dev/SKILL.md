---
name: feature-dev
description: Complete feature development workflow — from discovery to delivery in 7 phases
type: flow
---

# Feature Development Workflow

Feature development workflow with 7 phases, orchestrating multiple EKC agents.

```mermaid
flowchart TD
    A([BEGIN]) --> B[Discovery - Understand the context and goal of the feature]
    B --> C[Exploration - Explore the existing codebase]
    C --> D[Questions - Ask clarifying questions to the user]
    D --> E{User responds?}
    E -->|Yes| F[Architecture - Propose architecture and design]
    E -->|No| D
    F --> G{User approves?}
    G -->|Yes| H[Implementation - Implement the feature]
    G -->|No| F
    H --> I[Review - Review quality, security and performance]
    I --> J{Passed review?}
    J -->|No| H
    J -->|Yes| K[Summary - Document what was done]
    K --> L([END])
```

## Instructions per node

**Discovery**: Use `code-explorer` to understand the project context.

**Exploration**: Use `code-explorer` + `architect` to map the codebase.

**Questions**: Use `AskUserQuestion` to raise missing requirements.

**Architecture**: Use `architect` or `code-architect` to propose the solution. Wait for approval.

**Implementation**: Use `coder` subagent or implement directly. Follow TDD when possible.

**Review**: Use `code-reviewer`, `security-reviewer` and `type-design-analyzer` to validate.

**Summary**: Use `doc-updater` to update documentation.
