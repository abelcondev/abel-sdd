# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Role specialization in the SDD flow: `specifier` is split into `product_manager`, `designer`, and `tech_specifier` to cover the `[Product]`, `[Design]`, and `[Dev]` phases respectively.
- `sdd/workflow.md` updated with the roles table and per-phase workflow.
- `sdd/templates/issue-product.md` enriched with User Segments, Jobs-to-be-Done, Success Metrics, and Out-of-Scope.
- `sdd/templates/issue-design.md` restructured with Functional Spec, User Flows, and Handoff to Dev separated from UI/UX Design.
- `CLAUDE.md`, `AGENTS.md`, `sdd/quality-gates.md`, `sdd/testing.md`, and `init.sh` updated to reference the new roles.

### Added

- Agents `.claude/agents/product_manager.md`, `.claude/agents/designer.md`, and `.claude/agents/tech_specifier.md`.

### Added

- `sdd-cli` one-command installer. Run `sdd init` from any Git repository to download and install the latest SDD.

### Changed

- All SDD docs, templates, agent prompts, scripts, and the PR template translated to English.
- `install.sh` is now a bilingual CLI. It no longer asks for spec language (always English); it only asks for the language used to talk to the AI.
- `sdd/decisions/` starts empty. `sdd/decisions/adr-template.md` moved to `sdd/templates/adr-template.md` so consumers copy it only when needed.
- `sdd/architecture.md` updated to reflect that ADRs are created from the template on demand.

## [0.1.0] - 2026-06-19

### Added

- README.md rewritten with title, description, CI badge, installation, quick start, structure, roles, flow, and license.
- GitHub Actions workflow `.github/workflows/ci.yml` that runs `./init.sh` on push and PR to `main`.
- `CONTRIBUTING.md` with guide to propose changes, run `./init.sh`, and commit convention.
- `CHANGELOG.md` with Keep a Changelog format.
- Pull Request template in `.github/PULL_REQUEST_TEMPLATE.md` with quality checklist.
- `.gitignore` updated to ignore sibling worktrees, `init.sh` logs, environment files, and editor/IDE directories.

[0.1.0]: https://github.com/abelconde/abel-sdd/releases/tag/v0.1.0
