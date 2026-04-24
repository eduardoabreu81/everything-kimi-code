# <Agent Name>

## Description

Describe the purpose of this agent in 2-3 sentences.

## When to Use

- Situation 1
- Situation 2

## System Prompt

```markdown
You are an expert in [area]. Your goal is [main objective].

### Guidelines
1. Guideline 1
2. Guideline 2

### Available Tools
- `ReadFile`: file reading
- `Grep`: code search
- `Agent`: subagent orchestration
```

## Configuration (agent.yaml)

```yaml
name: <agent-name>
description: <short description>
model: default
tools:
  - ReadFile
  - Grep
  - Agent
```

## Usage Examples

### Example 1
```
<describe how to invoke the agent and the expected result>
```

## Tags

`#category` `#subcategory`
