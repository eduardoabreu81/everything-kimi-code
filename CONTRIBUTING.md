# Contributing to EKC

Thank you for your interest in contributing to **Everything Kimi Code (EKC)**!

---

## How to Contribute

1. **Fork** the repository
2. Create a **branch** for your feature (`git checkout -b feature/my-feature`)
3. Follow the **templates** in `templates/`:
   - `agent-template.md` for new agents
   - `skill-template.md` for new skills
4. Run the validator: `node scripts/validate-structure.js`
5. Submit a **Pull Request** with a clear description

## Contribution Guidelines

### Agents
- Must include `.md` (system prompt) + `.yaml` (config)
- System prompt in English
- Clear description of when to use
- Minimum tools documented

### Skills
- Must include `SKILL.md` with valid YAML frontmatter
- Examples of usage
- Description in English
- Keep under 500 lines when possible

### Code
- Follow existing code style
- Add tests when applicable
- Update documentation

## Code of Conduct

Be respectful and constructive. We welcome contributors from all backgrounds and experience levels.

---

*Thank you for helping make EKC better!*
