# [Dev] Integrar BDD con fase de Producto en el SDD

Project: `sdd/projects/integrar-bdd-product/`
Estado: `dev/spec-needed`

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
