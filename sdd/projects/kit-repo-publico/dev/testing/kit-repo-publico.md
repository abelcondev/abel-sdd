# [Dev] Kit básico de repo público

Project: `sdd/projects/kit-repo-publico/`
Estado: `dev/testing`

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

## Review

**Auditor:** auditor  
**Fecha:** 2026-06-19  
**Veredicto:** ✅ Aprobado para pasar a `dev/testing/`

### Hallazgos

- `README.md` reescrito con badge de CI, instalación, uso rápido, estructura, roles, flujo y licencia.
- `.github/workflows/ci.yml` existe y ejecuta `./init.sh` en `push` y `pull_request` a `main`.
- `CONTRIBUTING.md` existe con guía de cambios, ejecución local de `./init.sh` y convención de commits.
- `CHANGELOG.md` existe con formato Keep a Changelog y versión `[0.1.0]`.
- `.github/PULL_REQUEST_TEMPLATE.md` existe con checklist mínima.
- `.gitignore` cubre worktrees hermanos, logs de `init.sh`, entornos e IDEs.
- `./init.sh` pasa sin errores: `[OK] Harness SDD listo`.
- `git status --short` no reporta archivos untracked.
- Historial de commits atómico con Conventional Commits y scope `sdd`/`github`/`readme`/`gitignore`.
- La Issue `[Design]` está en `design/design-ready/` y el spec funcional es adecuado para una feature de documentación/repo sin UI visual.

### Observaciones (no bloqueantes)

- Los checkboxes de Acceptance Criteria en la Issue `[Product]` quedaron sin marcar. Recomendación: marcarlos como parte del cierre de la feature.
- No hay `scripts/project-checks.sh`; es válido porque el proyecto es agnóstico al stack y aún no requiere validaciones de stack específicas.

### Checklist C1–C7

#### C1 — Harness completo

- [x] `AGENTS.md` existe.
- [x] `CLAUDE.md` existe y fuerza el rol orchestrator.
- [x] `sdd/README.md` existe.
- [x] `sdd/workflow.md` existe.
- [x] `sdd/architecture.md` existe y está completado como plantilla.
- [x] `sdd/conventions.md` existe y está completado como plantilla.
- [x] `sdd/quality-gates.md` existe.
- [x] `sdd/testing.md` existe.
- [x] `sdd/security.md` existe.
- [x] `sdd/delivery.md` existe.
- [x] `.claude/agents/` tiene `orchestrator.md`, `specifier.md`, `developer.md`, `auditor.md`.
- [x] `init.sh` existe y es ejecutable.
- [x] `sdd/projects/` existe y tiene al menos un project.

#### C2 — Coherencia de estado

- [x] Máximo una Issue `[Dev]` en estado `implementing/` o `review/`.
- [x] El Project contiene al menos una Issue `[Design]` y una Issue `[Dev]`.
- [x] La Issue `[Dev]` está en `dev/backlog/` hasta que `[Design]` esté en `design/design-ready/`.
- [x] Todos los estados en `sdd/projects/` son carpetas válidas según `sdd/workflow.md`.
- [x] Si una Issue `[Design]` está en `design/designing/` o más allá, su descripción contiene un spec funcional + UI/UX completo.
- [x] Si una Issue `[Design]` está en `design/design-ready/`, su descripción contiene la sección `UI/UX Design` completa y assets del diseño (N/A: feature sin UI visual).
- [x] Si una Issue `[Dev]` está en `dev/spec-ready/` o más allá, su descripción contiene un spec técnico completo.
- [x] Si una Issue `[Dev]` está en `dev/implementing/` o más allá, existe el worktree en `<repo-principal>-<project>/`.

#### C3 — Cumplimiento arquitectónico

- [x] Nuevo código respeta el stack y convenciones definidos en `sdd/architecture.md` y `sdd/conventions.md`.
- [x] No hay tipado/estilo que contradiga las convenciones del proyecto.
- [x] No hay librerías duplicadas en funcionalidad.
- [x] No hay logs de debug ni código muerto.
- [x] Todos los textos de UI están en el idioma acordado (N/A).
- [x] RBAC respetado en rutas y componentes nuevos (N/A).
- [x] Sin eliminaciones físicas en entidades de negocio (N/A).
- [x] Audit trail presente en mutaciones críticas (N/A).
- [x] La UI implementada coincide con el diseño aprobado y la Issue `[Design]` (N/A: feature sin UI visual).

#### C4 — Verificación real

- [x] El test runner del proyecto pasa sin errores (N/A: no hay runner configurado; `init.sh` actúa como verificación).
- [x] El type checker del proyecto pasa sin errores (N/A).
- [x] El linter del proyecto pasa sin advertencias (N/A).
- [x] El build del proyecto pasa sin errores (N/A).
- [x] El audit de dependencias no reporta vulnerabilidades críticas (N/A: no hay dependencias).
- [x] Cada requisito `R<n>` tiene al menos un test que lo valida: verificados manualmente / mediante `init.sh`.

#### C5 — Cierre limpio de sesión

- [x] `init.sh` imprime el mensaje de éxito configurado.
- [x] No hay archivos untracked sospechosos.
- [ ] Si se cerró una Issue `[Dev]`, su archivo está en `dev/done/` (pendiente del merge).
- [x] Si se cerró una Issue `[Design]`, su archivo está en `design/design-ready/`.
- [ ] Si se cerró una Issue `[Dev]`, el worktree fue eliminado (pendiente del merge).
- [x] Se actualizó `sdd/README.md` con el estado actual de projects.

#### C6 — Cumplimiento SDD

- [x] La Issue `[Design]` pasó por `design/spec-needed/` → `design/designing/` → `design/design-ready/`.
- [x] La Issue `[Dev]` pasó por `dev/spec-needed/` → `dev/spec-ready/` → `dev/implementing/` antes de tocar código de producción.
- [x] El gate humano entre `spec-needed/` y `designing/` fue respetado.
- [x] El gate humano entre `designing/` y `design-ready/` fue respetado.
- [x] El gate humano entre `spec-ready/` e `implementing/` fue respetado.
- [x] La descripción de cada Issue usa el template de `sdd/workflow.md`.

#### C7 — Seguridad

- [x] RBAC validado en tests (N/A).
- [x] Inputs sanitizados y validados (N/A).
- [x] No se loggea PII.
- [x] Audit trail presente en mutaciones críticas (N/A).
- [x] Audit de dependencias sin vulnerabilidades críticas (N/A).
- [x] No hard deletes en entidades de negocio (N/A).
- [x] Secrets fuera del código.
