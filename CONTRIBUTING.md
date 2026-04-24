# 🤝 Contribuindo com o EKC

> **English version below** ⬇️

Obrigado pelo interesse em contribuir com o **Everything Kimi Code (EKC)**!

---

## 🇧🇷 Português

### Como contribuir

1. **Fork** o repositório
2. Crie uma **branch** para sua feature (`git checkout -b feature/minha-feature`)
3. Siga os **templates** em `templates/`
4. Valide localmente (quando `ekc validate` estiver disponível)
5. Abra um **Pull Request** com descrição clara

### Critérios de aceitação

#### Agent
- Deve conter `agent.md` (system prompt) + `agent.yaml` (configuração)
- Prompt em português (PT-BR preferencial)
- Tools mínimas documentadas no `.yaml`

#### Skill
- Deve conter `SKILL.md` com frontmatter YAML válido
- Exemplos de uso e descrição em PT-BR
- Versão e nome explícitos no frontmatter

#### Kimi-Mem
- Testes de integração passando
- Documentação atualizada
- Compatível com a licença AGPL-3.0

### Código de conduta

- Seja respeitoso e construtivo
- Documente decisões arquiteturais
- Prefira português na documentação, inglês no código quando apropriado

---

## 🇺🇸 English

### How to contribute

1. **Fork** the repository
2. Create a **branch** for your feature (`git checkout -b feature/my-feature`)
3. Follow the **templates** in `templates/`
4. Validate locally (when `ekc validate` is available)
5. Open a **Pull Request** with a clear description

### Acceptance criteria

#### Agent
- Must contain `agent.md` (system prompt) + `agent.yaml` (configuration)
- Prompt in Portuguese (PT-BR preferred)
- Minimum tools documented in `.yaml`

#### Skill
- Must contain `SKILL.md` with valid YAML frontmatter
- Usage examples and description in PT-BR
- Explicit version and name in frontmatter

#### Kimi-Mem
- Integration tests passing
- Documentation updated
- Compatible with AGPL-3.0 license

### Code of conduct

- Be respectful and constructive
- Document architectural decisions
- Prefer Portuguese for documentation, English for code when appropriate
