# [Dev] Integrar BDD con fase de Producto en el SDD

Project: `sdd/projects/integrar-bdd-product/`
Estado: "dev/testing"

## Context

Implementación técnica de la integración de BDD en el framework SDD. Se agrega la fase `[Product]`, se actualizan templates, scripts, workflow y agentes.

## Technical Decisions

### D1: Estados de [Product]

- **Elegido**: Dos estados: `product/discovery/` y `product/product-ready/`.
- **Alternativas descartadas**:
  - `product/spec-needed/` y `product/spec-ready/`: demasiado parecido a [Dev]; [Product] no requiere un gate técnico, solo aprobación de negocio.
  - `product/backlog/`: innecesario; [Product] es la primera fase.
- **Razón**: Simplicidad y claridad. Discovery = iteración; product-ready = aprobado.
- **Impacto**: `sdd/workflow.md`, `scripts/sdd-worktree.sh`, `scripts/sdd-move.sh`, `init.sh`.

### D2: Validación de [Product] en init.sh

- **Elegido**: `init.sh` verifica que cada project tenga al menos una Issue `[Product]`, `[Design]` y `[Dev]`.
- **Alternativas descartadas**: No validar [Product] para no romper projects existentes. Pero como esta es una nueva versión del framework, preferimos hacerlo explícito.
- **Razón**: Reforzar que [Product] es una fase de primera clase.
- **Impacto**: `init.sh`.

### D3: Templates

- **Elegido**: Crear `sdd/templates/issue-product.md` y agregar secciones BDD a `issue-design.md` e `issue-dev.md`.
- **Alternativas descartadas**: Modificar solo `issue-design.md` para incluir BDD. Pero eso mezclaría voz de producto con diseño UI.
- **Razón**: Separación clara de responsabilidades.
- **Impacto**: `sdd/templates/`.

## Impact Analysis

| Módulo | Acción | Contrato expuesto |
|---|---|---|
| `sdd/workflow.md` | modificar | Nuevos estados de [Product] y flujo |
| `sdd/README.md` | modificar | Mapa con `product/` y `sdd/templates/issue-product.md` |
| `sdd/templates/issue-product.md` | crear | Template de Issue [Product] |
| `sdd/templates/issue-design.md` | modificar | Sección BDD Reference |
| `sdd/templates/issue-dev.md` | modificar | Sección BDD Test Plan |
| `scripts/sdd-worktree.sh` | modificar | Crear `product/discovery/` y `product/product-ready/` |
| `scripts/sdd-move.sh` | modificar | Soportar estados `product/*` |
| `init.sh` | modificar | Validar [Product], [Design], [Dev] |
| `.claude/agents/leader.md` | modificar | Incluir [Product] en acciones |
| `.claude/agents/spec_author.md` | modificar | Incluir [Product] en responsabilidades |
| `sdd/decisions/` | crear | ADR sobre integración de BDD |

## Technical Notes

- Mantener compatibilidad con los comandos existentes de `sdd-move.sh`.
- Los estados de [Product] no interactúan con [Dev] directamente; solo desbloquean [Design].
- `sdd-move.sh` debe detectar el tipo de Issue por el prefijo de estado (`product/`, `design/`, `dev/`).

## Implementation Plan

1. Crear `sdd/templates/issue-product.md`.
2. Actualizar `sdd/templates/issue-design.md` con sección BDD Reference.
3. Actualizar `sdd/templates/issue-dev.md` con sección BDD Test Plan.
4. Actualizar `sdd/workflow.md` con estados y flujo de [Product].
5. Actualizar `sdd/README.md` con mapa actualizado.
6. Modificar `scripts/sdd-worktree.sh` para crear `product/`.
7. Modificar `scripts/sdd-move.sh` para soportar `product/*`.
8. Extender `init.sh` para validar [Product].
9. Actualizar `.claude/agents/leader.md` y `.claude/agents/spec_author.md`.
10. Crear ADR sobre integración de BDD.
11. Correr `./init.sh` y verificar.

## Test Plan

| Requisito | Test de aceptación | Tipo | Prioridad |
|---|---|---|---|
| R1 | `sdd-worktree.sh create` genera `product/discovery/` y `product/product-ready/` | unitario | obligatorio |
| R2 | `sdd-move.sh` acepta `product/discovery → product/product-ready` | unitario | obligatorio |
| R3 | `issue-product.md` tiene secciones de BDD | unitario | obligatorio |
| R4 | `issue-design.md` tiene BDD Reference | unitario | obligatorio |
| R5 | `issue-dev.md` tiene BDD Test Plan | unitario | obligatorio |
| R6 | `init.sh` detecta project sin [Product] | unitario | obligatorio |
| R7 | `workflow.md` describe flujo Product → Design → Dev | unitario | obligatorio |

## Security Considerations

- [ ] No aplica. Cambios en documentación y scripts del framework.

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| init.sh más estricto rompe repos antiguos | medio | Este es el framework base; los proyectos que lo adoptan lo hacen con la nueva versión |
| Scripts con más estados son más complejos | medio | Tests manuales y validación con init.sh |

## Dependencies

- blockedBy: [Design] `integrar-bdd-product`
- Bloquea a: —

## UI Reference

No aplica.

## Notas de progreso

- 2026-06-19: R2 completado — template `sdd/templates/issue-product.md` creado.
- 2026-06-19: R4/R5 completados — templates `issue-design.md` e `issue-dev.md` actualizados con BDD Reference y BDD Test Plan.
- 2026-06-19: R1 completado — `sdd/workflow.md` y `sdd/README.md` documentan la fase [Product] y el flujo Product → Design → Dev.
- 2026-06-19: R3 completado — `sdd/workflow.md` y `.claude/agents/leader.md` reflejan que [Design] no avanza hasta [Product] en `product-ready`.
- 2026-06-19: R6 completado — templates normalizados con secciones claras de BDD y trazabilidad entre fases.
- 2026-06-19: R7 completado — `scripts/sdd-worktree.sh`, `scripts/sdd-move.sh` e `init.sh` soportan y validan [Product].
- 2026-06-19: ADR-0003 creado en `sdd/decisions/0003-integracion-bdd-con-fase-product.md`.
- 2026-06-19: `.claude/agents/spec_author.md` actualizado con responsabilidades de [Product].
- 2026-06-19: `./init.sh` pasa con `[OK] Harness SDD listo`. Se migró `mejoras-framework-sdd` a [Product] para cumplir la validación.
- 2026-06-19 (rework): H1 corregido — eliminado bloque duplicado en `.claude/agents/spec_author.md`.
- 2026-06-19 (rework): H2 corregido — referencia genérica `dev/<estado>/integrar-bdd-product.md` en ADR-0003.
- 2026-06-19 (rework): H3 atendido — `scripts/sdd-move.sh` ahora advierte si [Design] avanza sin [Product] en `product-ready/` o [Dev] sin [Design] en `design-ready/`.

## Review

### Veredicto: ✅ Aprobado

La re-revisión confirma que los hallazgos H1 y H2 de la review anterior fueron corregidos, y que el actionable opcional H3 fue atendido con una advertencia no bloqueante en `sdd-move.sh`. La feature cumple los requisitos R1–R7, `init.sh` pasa sin errores, el repositorio está limpio y la trazabilidad entre `[Product]`, `[Design]` y `[Dev]` es completa.

### Hallazgos

1. **H1 — Contenido duplicado en `.claude/agents/spec_author.md`** ✅ **Resuelto**
   La sección `### Fase 1: Issue [Design]` ya no contiene el bloque duplicado de bullets. El orden ahora es: Context, Requirements, Acceptance Criteria, BDD Reference, UI/UX Design.

2. **H2 — Referencia de estado incorrecta en ADR-0003** ✅ **Resuelto**
   La sección `## Referencias` de `sdd/decisions/0003-integracion-bdd-con-fase-product.md` ahora usa la referencia genérica `dev/<estado>/integrar-bdd-product.md`, que es válida independientemente del estado actual de la Issue `[Dev]`.

3. **H3 — Advertencia de gates de fases previas en `sdd-move.sh`** ⚠️ **Atendido (no bloqueante)**
   `sdd-move.sh` ahora emite una advertencia (`[WARN]`) cuando se intenta mover una Issue `[Design]` sin que `[Product]` esté en `product-ready/`, o una Issue `[Dev]` sin que `[Design]` esté en `design-ready/`. La validación sigue siendo no bloqueante por diseño, pero refuerza el cumplimiento de las reglas de oro.

### Trazabilidad R<n> → Implementación

| Requisito | Origen | Evidencia de implementación | Estado |
|---|---|---|---|
| R1 | [Product] | `scripts/sdd-worktree.sh` crea `product/discovery/` y `product/product-ready/`; `sdd/workflow.md` sección 2 documenta la estructura | ✅ |
| R2 | [Product] | `sdd/templates/issue-product.md` incluye Context, Product Goals, Requirements, Acceptance Criteria, BDD Scenarios, Risks y Dependencies | ✅ |
| R3 | [Product] | `sdd/workflow.md` sección 5 y `.claude/agents/leader.md` reglas de oro definen que `[Design]` no avanza hasta `[Product]` en `product-ready/` | ✅ |
| R4 | [Product] | `sdd/templates/issue-design.md` sección `BDD Reference` | ✅ |
| R5 | [Product] | `sdd/templates/issue-dev.md` sección `BDD Test Plan` | ✅ |
| R6 | [Product] | Templates de [Product], [Design] y [Dev] con secciones claras de BDD y trazabilidad | ✅ |
| R7 | [Product] | `init.sh` valida que cada project tenga `[Product]`, `[Design]` y `[Dev]` | ✅ |
| R1 | [Design] | Mismo que R1 [Product] | ✅ |
| R2 | [Design] | `scripts/sdd-move.sh` soporta `product/discovery` → `product/product-ready` | ✅ |
| R3 | [Design] | `sdd/templates/issue-product.md` con secciones requeridas | ✅ |
| R4 | [Design] | `sdd/templates/issue-design.md` sección `BDD Reference` | ✅ |
| R5 | [Design] | `sdd/templates/issue-dev.md` sección `BDD Test Plan` | ✅ |
| R1 | [Dev] | `scripts/sdd-worktree.sh` crea estructura `product/` | ✅ |
| R2 | [Dev] | `scripts/sdd-move.sh` soporta movimientos `product/*` | ✅ |
| R3 | [Dev] | `sdd/templates/issue-product.md` tiene secciones BDD | ✅ |
| R4 | [Dev] | `sdd/templates/issue-design.md` tiene `BDD Reference` | ✅ |
| R5 | [Dev] | `sdd/templates/issue-dev.md` tiene `BDD Test Plan` | ✅ |
| R6 | [Dev] | `init.sh` detecta projects sin `[Product]` y falla | ✅ |
| R7 | [Dev] | `sdd/workflow.md` describe flujo Product → Design → Dev | ✅ |

### Checklist C1–C7

#### C1 — Harness completo
- [x] `AGENTS.md`, `CLAUDE.md`, `sdd/README.md`, `sdd/workflow.md`, `sdd/architecture.md`, `sdd/conventions.md`, `sdd/quality-gates.md`, `sdd/testing.md`, `sdd/security.md`, `sdd/delivery.md` existen.
- [x] `.claude/agents/` tiene `leader.md`, `spec_author.md`, `implementer.md`, `reviewer.md`.
- [x] `init.sh` existe, es ejecutable y pasa con `[OK] Harness SDD listo`.
- [x] `sdd/projects/` existe y tiene al menos un project.

#### C2 — Coherencia de estado
- [x] Máximo una Issue `[Dev]` en `implementing/` o `review/`.
- [x] Cada project tiene `[Product]`, `[Design]` y `[Dev]`.
- [x] Todos los estados en `sdd/projects/` son carpetas válidas según `sdd/workflow.md`.
- [x] La Issue `[Design]` en `design-ready/` contiene spec funcional + UI/UX completo.
- [x] La Issue `[Dev]` en `review/` tiene worktree asociado (`abel-sdd-integrar-bdd-product`).

#### C3 — Cumplimiento arquitectónico
- [x] No hay código de producción nuevo; cambios en scripts/docs del framework.
- [x] No se detectan logs de debug ni código muerto en scripts revisados.
- [x] No hay librerías duplicadas.

#### C4 — Verificación real
- [x] `init.sh` pasa (es el único harness de verificación para este repo de framework).
- [x] Cada `R<n>` de [Product], [Design] y [Dev] está cubierto por un test de aceptación manual o validación de `init.sh`.
- [x] Test runner / type checker / linter / build: no aplica a este repo de framework.

#### C5 — Cierre limpio de sesión
- [x] `init.sh` imprime mensaje de éxito.
- [x] `git status --short` no reporta archivos untracked ni modificados sin commit.
- [x] La Issue `[Dev]` se mueve a `dev/testing/` tras esta aprobación.
- [x] La Issue `[Design]` está en `design/design-ready/`.
- [x] Worktree aún no eliminado (espera validación humana del merge y cierre en `dev/done/`).
- [x] `sdd/README.md` y `sdd/workflow.md` actualizados con estado actual.

#### C6 — Cumplimiento SDD
- [x] `[Product]` pasó por `discovery/` → `product-ready/`.
- [x] `[Design]` pasó por `spec-needed/` → `designing/` → `design-ready/`.
- [x] `[Dev]` pasó por `spec-needed/` → `spec-ready/` → `implementing/` → `review/`.
- [x] Las descripciones de Issues usan los templates de `sdd/templates/`.

#### C7 — Seguridad
- [x] No aplica a este cambio de framework (sin código de producción, RBAC, PII ni secrets).

### Accionables

Ninguno. La feature está aprobada para pasar a `dev/testing/` y esperar validación humana del merge.

### Próximo paso sugerido para el Leader

1. Mover esta Issue `[Dev]` a `dev/testing/`.
2. Esperar validación humana del merge.
3. Mergear el worktree `abel-sdd-integrar-bdd-product` a `main`.
4. Mover la Issue a `dev/done/` y eliminar el worktree.
