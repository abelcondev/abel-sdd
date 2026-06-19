# [Dev] Kit básico de repo público

Project: `sdd/projects/kit-repo-publico/`
Estado: `dev/implementing`

## Context

Implementación del kit básico de repo público para `abel-sdd`.

## Technical Decisions

### D1: GitHub Actions para CI

- **Elegido**: Workflow simple en `.github/workflows/ci.yml` que corre `./init.sh`.
- **Alternativas descartadas**: Travis, CircleCI — GitHub Actions es nativo y gratuito para repos públicos.
- **Razón**: Menor fricción para contribuidores.
- **Impacto**: `.github/workflows/ci.yml`.

### D2: Badges en README

- **Elegido**: Badge de CI con GitHub Actions.
- **Razón**: Visibilidad inmediata del estado del framework.
- **Impacto**: `README.md`.

## Impact Analysis

| Módulo | Acción | Contrato |
|---|---|---|
| `README.md` | modificar | Documentación pública |
| `.github/workflows/ci.yml` | crear | CI |
| `CONTRIBUTING.md` | crear | Guía de contribución |
| `CHANGELOG.md` | crear | Historial de cambios |
| `.github/PULL_REQUEST_TEMPLATE.md` | crear | Template de PR |
| `.gitignore` | modificar | Exclusiones de template |

## Implementation Plan

1. Reescribir `README.md` con estructura clara y badge de CI.
2. Crear `.github/workflows/ci.yml`.
3. Crear `CONTRIBUTING.md`.
4. Crear `CHANGELOG.md`.
5. Crear `.github/PULL_REQUEST_TEMPLATE.md`.
6. Revisar y actualizar `.gitignore`.
7. Correr `./init.sh`.

## Test Plan

| Requisito | Test | Tipo |
|---|---|---|
| R1 | README renderiza bien en Markdown | manual |
| R2 | CI corre `./init.sh` | manual |
| R3–R5 | Archivos existen y tienen contenido | unitario |
| R6 | `.gitignore` ignora worktrees y logs | unitario |

## Dependencies

- blockedBy: [Design] `kit-repo-publico`

## Notas de progreso

- 2026-06-19: README.md reescrito con badge de CI, secciones completas y diagrama de flujo.
- 2026-06-19: Creados `.github/workflows/ci.yml`, `CONTRIBUTING.md`, `CHANGELOG.md` y `.github/PULL_REQUEST_TEMPLATE.md`.
- 2026-06-19: `.gitignore` actualizado con worktrees hermanos, logs de init, entornos e IDEs.
- 2026-06-19: Commits atómicos realizados. `./init.sh` pasa: `[OK] Harness SDD listo`.
