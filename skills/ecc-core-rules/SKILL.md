---
name: ecc-core-rules
description: Core rules from Everything Claude Code (ECC) for coding style, testing, security, performance, and agent orchestration. Always follow these guidelines.
origin: ECC
---

# ECC Core Rules

These are the essential rules extracted from the Everything Claude Code (ECC) performance system. Apply them to every task unless the user explicitly overrides them.

## 1. Coding Style

### Immutability (CRITICAL)
ALWAYS create new objects, NEVER mutate existing ones:
- WRONG: modify(original, field, value) → changes original in-place
- CORRECT: update(original, field, value) → returns new copy with change

### KISS
- Prefer the simplest solution that actually works
- Avoid premature optimization
- Optimize for clarity over cleverness

### DRY
- Extract repeated logic into shared functions or utilities
- Avoid copy-paste implementation drift

### YAGNI
- Do not build features or abstractions before they are needed
- Start simple, then refactor when the pressure is real

### File Organization
MANY SMALL FILES > FEW LARGE FILES:
- 200-400 lines typical, 800 max
- Extract utilities from large modules
- Organize by feature/domain, not by type

### Error Handling
ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Provide user-friendly error messages in UI-facing code
- Never silently swallow errors

### Input Validation
ALWAYS validate at system boundaries:
- Validate all user input before processing
- Use schema-based validation where available
- Fail fast with clear error messages
- Never trust external data

### Naming Conventions
- Variables and functions: `camelCase` (TypeScript/JS) or `snake_case` (Python)
- Booleans: prefer `is`, `has`, `should`, or `can` prefixes
- Interfaces, types, and components: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`

### Code Smells to Avoid
- Deep nesting — prefer early returns
- Magic numbers — use named constants
- Long functions — split into focused pieces

## 2. Testing Requirements

### Minimum Coverage: 80%
Required test types:
1. **Unit Tests** — individual functions, utilities, components
2. **Integration Tests** — API endpoints, database operations
3. **E2E Tests** — critical user flows

### TDD Workflow (MANDATORY)
1. Write test first (RED)
2. Run test — it MUST FAIL
3. Write minimal implementation (GREEN)
4. Run test — it MUST PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

### Test Structure (AAA Pattern)
- Arrange → Act → Assert
- Use descriptive test names that explain behavior

## 3. Security Guidelines

Before ANY commit, verify:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized output)
- [ ] Authentication/authorization verified
- [ ] Error messages don't leak sensitive data

If a security issue is found:
1. STOP immediately
2. Use the `security-reviewer` agent
3. Fix CRITICAL issues before continuing

## 4. Performance Optimization

- Manage context window: avoid filling the last 20% for large tasks
- Use parallel execution for independent operations
- Prefer `kimi-for-coding` (Sonnet equivalent) for most coding tasks
- Enable Plan Mode for complex architectural changes

## 5. Agent Orchestration

### Available ECC Subagents
Use them PROACTIVELY:
- **planner** — complex features, refactoring plans
- **architect** — system design decisions
- **tdd-guide** — test-driven development enforcement
- **code-reviewer** — after writing/modifying code
- **security-reviewer** — before commits
- **build-error-resolver** — when build fails
- **refactor-cleaner** — dead code cleanup
- **doc-updater** — documentation updates
- **python-reviewer** — Python-specific code review
- **typescript-reviewer** — TypeScript/JavaScript review
- **go-reviewer**, **rust-reviewer**, **java-reviewer**, **kotlin-reviewer** — language-specific reviews

### Delegation Rules
1. Complex feature requests → use **planner** automatically
2. Code just written/modified → use **code-reviewer** automatically
3. Bug fix or new feature → use **tdd-guide** automatically
4. Architectural decision → use **architect** automatically

### Parallel Execution
ALWAYS use parallel agents for independent operations instead of running them sequentially.

## 6. Multi-Perspective Analysis

For complex problems, consider split-role subagents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker

## 7. Code Quality Checklist

Before declaring any task complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling everywhere
- [ ] No hardcoded values
- [ ] Immutable patterns used
- [ ] Tests passing with 80%+ coverage
