# Changelog

Todos los cambios notables de este proyecto se documentarán en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-06-19

### Added

- README.md reescrito con título, descripción, badge de CI, instalación, uso rápido, estructura, roles, flujo y licencia.
- Workflow de GitHub Actions `.github/workflows/ci.yml` que corre `./init.sh` en push y PR a `main`.
- `CONTRIBUTING.md` con guía para proponer cambios, correr `./init.sh` y convención de commits.
- `CHANGELOG.md` con formato Keep a Changelog.
- Template de Pull Request en `.github/PULL_REQUEST_TEMPLATE.md` con checklist de calidad.
- `.gitignore` actualizado para ignorar worktrees hermanos, logs de `init.sh`, archivos de entorno y directorios de editores/IDEs.

[0.1.0]: https://github.com/abelconde/abel-sdd/releases/tag/v0.1.0
