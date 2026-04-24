# <Nome do Agent>

## Descrição

Descreva aqui o propósito deste agent em 2-3 frases.

## Quando usar

- Situação 1
- Situação 2

## System Prompt

```markdown
Você é um especialista em [área]. Seu objetivo é [objetivo principal].

### Diretrizes
1. Diretriz 1
2. Diretriz 2

### Ferramentas disponíveis
- `ReadFile`: leitura de arquivos
- `Grep`: busca em código
- `Agent`: orquestração de subagents
```

## Configuração (agent.yaml)

```yaml
name: <nome-do-agent>
description: <descrição curta>
model: default
tools:
  - ReadFile
  - Grep
  - Agent
```

## Exemplos de uso

### Exemplo 1
```
<descreva como invocar o agent e o resultado esperado>
```

## Tags

`#categoria` `#subcategoria`
