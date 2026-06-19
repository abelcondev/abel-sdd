# [Dev] Renombrar agentes del SDD

Project: `sdd/projects/renombrar-agentes-sdd/`
Estado: `dev/done`

## Context

Implementación del renombre de los 4 agentes del framework SDD.

## Technical Decisions

### D1: Nombres nuevos

- **Elegido**:
  - `leader` → `orchestrator`
  - `spec_author` → `specifier`
  - `implementer` → `developer`
  - `reviewer` → `auditor`
- **Alternativas descartadas**: conservar nombres antiguos (menos descriptivos).
- **Razón**: Mayor claridad para nuevos usuarios.
- **Impacto**: `.claude/agents/`, `AGENTS.md`, `CLAUDE.md`, `sdd/*.md`, `sdd/projects/`.

## Impact Analysis

| Módulo | Acción | Contrato |
|---|---|---|
| `.claude/agents/*.md` | renombrar | Nuevos nombres de archivos |
| `AGENTS.md` | modificar | Referencias a nuevos roles |
| `CLAUDE.md` | modificar | Rol por defecto = orchestrator |
| `sdd/workflow.md` | modificar | Referencias a agentes |
| `sdd/testing.md` | modificar | Referencias a developer/auditor |
| `sdd/delivery.md` | modificar | Referencias a auditor |
| `sdd/projects/` | modificar | Actualizar specs históricos si es necesario |
| `init.sh` | modificar | Verificar nombres de archivos |

## Implementation Plan

1. Renombrar archivos en `.claude/agents/`.
2. Actualizar contenido de cada prompt para usar nuevo nombre.
3. Actualizar `AGENTS.md`.
4. Actualizar `CLAUDE.md`.
5. Actualizar `sdd/workflow.md`, `sdd/testing.md`, `sdd/delivery.md`.
6. Actualizar `sdd/projects/` si hay referencias a roles antiguos.
7. Actualizar `init.sh`.
8. Correr `./init.sh`.

## Test Plan

| Requisito | Test | Tipo |
|---|---|---|
| R1 | Existe `.claude/agents/orchestrator.md` | unitario |
| R2 | No quedan strings `leader`, `spec_author`, etc. en docs | unitario |
| R3 | `init.sh` pasa | unitario |

## Dependencies

- blockedBy: [Design] `renombrar-agentes-sdd`

## Notas de progreso

- 2026-06-19: Renombre completado. Archivos `.claude/agents/*.md` renombrados, contenido de prompts actualizado y referencias en docs/scripts migradas. `./init.sh` pasa con `[OK] Harness SDD listo`. Las únicas ocurrencias restantes de los nombres viejos están en el spec de esta misma feature ([Product] y [Dev]), que las conservan como registro del mapeo de renombre.

## Review: renombrar-agentes-sdd/renombrar-agentes-sdd

### Veredicto: ✅ Aprobado

### Hallazgos

1. **Archivos renombrados** ✅
   - `.claude/agents/leader.md` → `.claude/agents/orchestrator.md`
   - `.claude/agents/spec_author.md` → `.claude/agents/specifier.md`
   - `.claude/agents/implementer.md` → `.claude/agents/developer.md`
   - `.claude/agents/reviewer.md` → `.claude/agents/auditor.md`

2. **Contenido de prompts actualizado** ✅
   - `orchestrator.md`: se identifica como Orchestrator y referencia a `specifier`, `developer` y `auditor`.
   - `specifier.md`: se identifica como Specifier.
   - `developer.md`: se identifica como Developer.
   - `auditor.md`: se identifica como Auditor.

3. **Docs y scripts sin referencias viejas** ✅
   - `AGENTS.md`, `CLAUDE.md`, `sdd/workflow.md`, `sdd/testing.md`, `sdd/delivery.md`, `sdd/security.md`, `sdd/quality-gates.md`, `README.md`, templates y specs históricos (`integrar-bdd-product`, `mejoras-framework-sdd`) usan los nuevos nombres.
   - `init.sh` valida la existencia de `orchestrator.md`, `specifier.md`, `developer.md` y `auditor.md`.
   - `scripts/sdd-worktree.sh`, `scripts/sdd-move.sh` e `install.sh` no contienen referencias a los nombres viejos.

4. **init.sh pasa en verde** ✅
   - Output: `[OK] Harness SDD listo`.
   - Se detecta exactamente una Issue `[Dev]` en `implementing/` o `review/` (`renombrar-agentes-sdd`).

5. **Commits correctos** ✅
   - `922043a` — crear project
   - `53124de` — [Product] discovery → product-ready
   - `2487ccc` — [Design] spec-needed → design-ready
   - `f8c1ec3` — [Dev] backlog → implementing
   - `852d857` — refactor(agents): renombre de archivos y contenido
   - `4de85d1` — [Dev] implementing → review
   - `195f5f6` — actualizar índice de projects activos a review

6. **Nota informativa** ⚠️
   - Las únicas ocurrencias de `leader`, `spec_author`, `implementer` y `reviewer` restantes en el worktree están en el spec de esta misma feature (`product/product-ready/renombrar-agentes-sdd.md` y `dev/review/renombrar-agentes-sdd.md`), donde se conservan intencionalmente como registro del mapeo de renombre. Esto es aceptable según el alcance.

### Trazabilidad R<n> → Test / Verificación

| Requisito | Verificación | Estado |
|-----------|--------------|--------|
| R1 [Product] | Revisión manual: `.claude/agents/orchestrator.md` existe y el prompt usa el nombre `Orchestrator`. `AGENTS.md`, `CLAUDE.md`, `sdd/workflow.md` y `README.md` referencian `orchestrator`. | ✅ |
| R2 [Product] | Revisión manual: `.claude/agents/specifier.md` existe y el prompt usa el nombre `Specifier`. Docs y scripts referencian `specifier`. | ✅ |
| R3 [Product] | Revisión manual: `.claude/agents/developer.md` existe y el prompt usa el nombre `Developer`. Docs y scripts referencian `developer`. | ✅ |
| R4 [Product] | Revisión manual: `.claude/agents/auditor.md` existe y el prompt usa el nombre `Auditor`. Docs y scripts referencian `auditor`. | ✅ |
| R1 [Dev] | Revisión manual + `init.sh`: `.claude/agents/orchestrator.md` existe. | ✅ |
| R2 [Dev] | `grep` de `leader\|spec_author\|implementer\|reviewer` en docs y scripts (`*.md`, `*.sh`) no reporta matches fuera del spec de la feature. | ✅ |
| R3 [Dev] | `./init.sh` pasa con `[OK] Harness SDD listo`. | ✅ |

### Trazabilidad TDD / Commits

| Requisito | Commit(s) relevantes | Estado |
|-----------|----------------------|--------|
| R1–R4 [Product] | `852d857` | ✅ |
| R1–R3 [Dev] | `852d857`, `195f5f6` | ✅ |

### Checklist C1–C7

- [x] **C1 — Harness completo**: todos los archivos del harness existen, incluyendo los 4 prompts renombrados; `init.sh` es ejecutable.
- [x] **C2 — Coherencia de estado**: la Issue `[Dev]` está en `dev/review/`; solo hay una Issue `[Dev]` en `implementing/` o `review/`; el project tiene `[Product]`, `[Design]` y `[Dev]`; estados válidos.
- [x] **C3 — Cumplimiento arquitectónico**: no hay código de producción nuevo; cambios consistentes en docs/scripts del framework.
- [x] **C4 — Verificación real**: `./init.sh` pasa; cada `R<n>` se verificó manualmente; no hay tests automatizados formales, lo cual es aceptable para un cambio de documentación/scripts del framework.
- [x] **C5 — Cierre limpio de sesión**: no hay archivos untracked ni cambios sin commit en el worktree; `sdd/README.md` y `sdd/workflow.md` reflejan el estado `review`.
- [x] **C6 — Cumplimiento SDD**: `[Product]` pasó por `discovery/` → `product-ready/`; `[Design]` pasó por `spec-needed/` → `designing/` → `design-ready/`; `[Dev]` pasó por `spec-needed/` → `spec-ready/` → `implementing/` → `review/`.
- [x] **C7 — Seguridad**: no aplica a este cambio de framework (sin código de producción, RBAC, PII ni secrets).

### Accionables

Ninguno. La feature está aprobada para pasar a `dev/testing/` y esperar validación humana del merge.

### Próximo paso sugerido para el Orchestrator

1. Mover esta Issue `[Dev]` a `dev/testing/`.
2. Esperar validación humana del merge.
3. Mergear el worktree `abel-sdd-renombrar-agentes-sdd` a `main`.
4. Mover la Issue a `dev/done/` y eliminar el worktree.

## Cierre

- **Resultado**: feature mergeada a `main`. Los agentes del framework SDD ahora se llaman `orchestrator`, `specifier`, `developer` y `auditor`.
- **Decisiones relevantes**: se conservaron los nombres viejos solo como registro histórico en el spec de esta feature.
- **Próximos pasos**: actualizar documentación externa o README del repo si es necesario.
