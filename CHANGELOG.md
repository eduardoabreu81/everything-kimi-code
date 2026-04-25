# Changelog

All notable changes to the EKC (Everything Kimi Code) project are documented in this file.

This project uses semantic versioning in the format `vX.Y.Z`:
- `X` — Major changes
- `Y` — Minor changes
- `Z` — Bug fixes and issue corrections

## [Unreleased]

## [v0.1.0] - 2026-04-24

### Added

- Global user-level install scripts for `~/.kimi/skills/` (PowerShell + Bash)
- Project-level install scripts for `.kimi/skills/` (PowerShell + Bash)
- Validation scripts for global and project installs that check directory structure, stamp files, YAML frontmatter, and flow skill integrity
- Clean scripts with stamp-file protection to prevent accidental deletion of user-managed skills
- README documentation for global install, project install, flow skills, and VS Code Extension support
- CONTRIBUTING workflow for skill editing, flow skill rules, validation checklist, and commit hygiene
- Flow skill validation for disconnected (dead) nodes and unreachable nodes in Mermaid diagrams

### Changed

- Global install is now the primary usage mode for EKC
- Project install is now positioned as local development and testing mode
- README now describes EKC as a Kimi CLI port and adaptation of Everything Claude Code
- README and CONTRIBUTING now clarify `skills/` as source-of-truth and runtime install targets as generated copies

### Fixed

- Fixed flows not appearing in Kimi CLI and VS Code Extension due to `<br/>` tags inside Mermaid node labels
- Fixed `github-code-reviewer` flow by connecting the abort node to the END node in the Mermaid diagram
- Removed incorrect README statement that the Kimi VS Code Extension does not support flow skills

### Validation

- Confirmed all 4 EKC flows appear and execute in Kimi CLI and VS Code Extension:
  - `/flow:code-review`
  - `/flow:feature-dev`
  - `/flow:github-code-reviewer`
  - `/flow:pr-review`
- Confirmed validators detect `<br/>` tags, disconnected nodes, and unreachable nodes in flow diagrams
- Confirmed global install and project install both validate successfully with zero failures

### Foundation

- Initial repository structure for `everything-kimi-code`
- 64 specialist subagents migrated from the ECC ecosystem
- 206 reusable skills migrated from the ECC ecosystem
- 4 flow skills (`feature-dev`, `pr-review`, `github-code-reviewer`, `code-review`)
- EKC main agent (`ekc.yaml`) registering all 64 subagents
- `AGENTS.md` with project context and identity
- `PLANO_EKC.md` with detailed implementation plan
- `scripts/validate-structure.js` for structure validation
- Templates for creating agents and skills
- Repo created at `eduardoabreu81/everything-kimi-code`
