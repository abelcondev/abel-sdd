# [Dev] Mejoras del framework SDD

Project: `sdd/projects/mejoras-framework-sdd/`
Estado: "dev/rejected"

## Context

Implementación de las 7 mejoras del framework SDD aprobadas en `[Design] mejoras-framework-sdd`. El objetivo es hacer el framework más completo, robusto y fácil de adoptar sin romper el flujo existente.

## Technical Decisions

### D1: Ejemplos en plantillas vs. archivos separados

- **Elegido**: Incluir ejemplos completos dentro de `sdd/architecture.md` y `sdd/conventions.md`, marcados claramente como `Ejemplo`, y agregar una sección `## Cómo completar este documento`.
- **Alternativas descartadas**: Crear `sdd/examples/` separado porque fragmentaría la información y los usuarios no encontrarían el ejemplo al abrir la plantilla.
- **Razón**: Bajar la fricción de adopción manteniendo todo en el archivo que ya deben editar.
- **Impacto**: `sdd/architecture.md`, `sdd/conventions.md`.

### D2: Validaciones en init.sh

- **Elegido**: Extender `init.sh` con funciones de validación de estado SDD en bash puro, sin dependencias externas.
- **Alternativas descartadas**: Crear un CLI en Node/Python porque agregaría dependencias al framework.
- **Razón**: El framework debe seguir siendo agnóstico al stack y sin runtime extra.
- **Impacto**: `init.sh`.

### D3: Backup en install.sh

- **Elegido**: `install.sh` --update hará backup de archivos que puedan tener customizaciones (`AGENTS.md`, `CLAUDE.md`) antes de sobrescribir.
- **Alternativas descartadas**: Siempre preguntar interactivamente porque rompe instalaciones automáticas.
- **Razón**: Permitir CI/automatización sin perder customizaciones.
- **Impacto**: `install.sh`.

## Impact Analysis

| Módulo | Acción | Contrato expuesto |
|---|---|---|
| `sdd/architecture.md` | modificar | Plantilla con ejemplo completo |
| `sdd/conventions.md` | modificar | Plantilla con ejemplo completo |
| `init.sh` | modificar | Nuevos checks de estado SDD |
| `scripts/sdd-worktree.sh` | modificar | Validaciones adicionales |
| `scripts/sdd-move.sh` | modificar | Validación de estados válidos |
| `scripts/install.sh` | modificar | Verificación de repo Git y modo update |
| `sdd/templates/issue-design.md` | modificar | Secciones Review y Changelog |
| `sdd/templates/issue-dev.md` | modificar | Secciones Review y Changelog |
| `sdd/decisions/` | crear | ADRs iniciales |
| `sdd/troubleshooting.md` | crear | Guía de problemas comunes |
| `.claude/agents/*.md` | modificar | Reforzar reglas de commits y harness |

## Technical Notes

- Mantener compatibilidad hacia atrás en los comandos de scripts.
- No introducir dependencias de runtime (Node, Python, etc.).
- Usar `set -euo pipefail` en todos los scripts.
- Asegurar que `./init.sh` siga pasando en verde.

## Implementation Plan

1. Completar `sdd/architecture.md` con ejemplo de stack y reglas de oro.
2. Completar `sdd/conventions.md` con ejemplo de naming y estilo.
3. Robustecer `scripts/sdd-worktree.sh`, `scripts/sdd-move.sh` e `install.sh`.
4. Extender `init.sh` con validaciones de estado SDD.
5. Mejorar `sdd/templates/issue-design.md` e `issue-dev.md`.
6. Crear ADRs iniciales y `sdd/troubleshooting.md`.
7. Actualizar prompts de agentes en `.claude/agents/`.
8. Correr `./init.sh` y verificar que pase.

## Test Plan

| Requisito | Test de aceptación | Tipo | Prioridad |
|---|---|---|---|
| R1 | `architecture.md` y `conventions.md` contienen secciones de ejemplo | unitario | obligatorio |
| R2 | `install.sh` rechaza destino no-Git y `sdd-move.sh` rechaza estado inválido | unitario | obligatorio |
| R3 | `init.sh` detecta múltiples issues en implementing/review | unitario | obligatorio |
| R4 | Los templates incluyen secciones `Review` y `Changelog` | unitario | obligatorio |
| R5 | `install.sh --update` respalda `AGENTS.md` y `CLAUDE.md` | unitario | obligatorio |
| R6 | Existen ADRs y `sdd/troubleshooting.md` | unitario | obligatorio |
| R7 | Los prompts de agentes mencionan `Co-Authored-By` y cambios en `init.sh` | unitario | obligatorio |

## Security Considerations

- [ ] RBAC: no aplica, es framework interno.
- [ ] Inputs sanitizados: validar slugs y rutas en scripts.
- [ ] No se expone PII: no aplica.
- [ ] Audit trail: los commits de estado SDD ya lo proveen.

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Cambios en scripts rompan flujo existente | alto | Validar con `init.sh` después de cada cambio |
| Plantillas con ejemplo confunden al usuario | medio | Marcar claramente como `Ejemplo` y separar de campos requeridos |

## Dependencies

- blockedBy: [Design] `mejoras-framework-sdd`

## UI Reference

No aplica.

## Review: mejoras-framework-sdd/mejoras-framework-sdd

### Veredicto: ❌ Rechazado

### Hallazgos
1. `sdd/README.md` no incluye `sdd/troubleshooting.md` ni `scripts/install.sh` en su mapa/índice del SDD, a pesar de que ambos archivos fueron creados/modificados en esta feature.
2. El índice de projects activos en `sdd/README.md` y `sdd/workflow.md` aún dice `*(ninguno)*`, sin reflejar que `mejoras-framework-sdd` está en `dev/review`.
3. `scripts/install.sh` es un wrapper que solo redirige a `install.sh` en la raíz. No está documentado en `sdd/README.md` y puede generar confusión sobre cuál instalador usar.
4. No se encontraron tests automatizados formales; las verificaciones de R1–R7 se hacen mediante revisión manual e `init.sh`, lo cual es aceptable para un framework de documentación/scripts bash pero debe quedar documentado.
5. `./init.sh` pasa en el worktree con el mensaje `[OK] Harness SDD listo`.
6. Todos los commits siguen Conventional Commits y referencian `mejoras-framework-sdd/mejoras-framework-sdd`.
7. No se detectaron secrets, logs de debug ni código muerto aparte del wrapper `scripts/install.sh`.

### Trazabilidad R<n> → Test / Verificación
| Requisito | Verificación | Estado |
|-----------|--------------|--------|
| R1 | Revisión manual: `sdd/architecture.md` y `sdd/conventions.md` contienen secciones `Ejemplo` y `Cómo completar este documento`. | ✅ |
| R2 | Revisión manual + prueba de comandos: `sdd-worktree.sh` rechaza slugs inválidos/worktrees existentes; `sdd-move.sh` rechaza estados inválidos y evita sobrescritura; `install.sh` rechaza destinos no-Git. | ✅ |
| R3 | `./init.sh` en el worktree detecta concurrencia (`implementing/`/`review/`) y projects sin `[Design]`/`[Dev]`. | ✅ |
| R4 | Revisión manual: `sdd/templates/issue-design.md` e `issue-dev.md` incluyen secciones `Review` y `Changelog`. | ✅ |
| R5 | Revisión manual: `install.sh --update` crea backups timestamped de `AGENTS.md` y `CLAUDE.md`. | ✅ |
| R6 | Revisión manual: existen `sdd/decisions/0001-uso-de-worktrees-por-feature.md`, `sdd/decisions/0002-markdown-como-fuente-de-verdad.md`, `sdd/decisions/adr-template.md` y `sdd/troubleshooting.md`. | ✅ |
| R7 | Revisión manual: `.claude/agents/leader.md`, `.claude/agents/spec_author.md`, `.claude/agents/implementer.md` y `.claude/agents/reviewer.md` refuerzan `Co-Authored-By` y cambios en `init.sh`. | ✅ |

### Trazabilidad TDD / Commits
| Requisito | Commit(s) relevantes | Estado |
|-----------|----------------------|--------|
| R1 | 6593143 | ✅ |
| R2 | a62cfa4 | ✅ |
| R3 | a47cfac | ✅ |
| R4 | 032a563 | ✅ |
| R5 | a62cfa4, e9504b1 | ✅ |
| R6 | 8f9add5 | ✅ |
| R7 | fc5b68a | ✅ |

### Checklist C1–C7
- [x] C1 — Harness completo
- [x] C2 — Coherencia de estado
- [ ] C3 — Cumplimiento arquitectónico (wrapper `scripts/install.sh` redundante / no documentado)
- [x] C4 — Verificación real (`init.sh` pasa; cada R<n> verificado manualmente)
- [ ] C5 — Cierre limpio de sesión (`sdd/README.md` y `sdd/workflow.md` no reflejan el project activo en `dev/review`)
- [x] C6 — Cumplimiento SDD
- [x] C7 — Seguridad (inputs validados, sin secrets, sin PII)

### Accionables (si fue rechazado)
1. Actualizar `sdd/README.md` para incluir `sdd/troubleshooting.md` y `scripts/install.sh` en el mapa del SDD, o eliminar el wrapper `scripts/install.sh` si no aporta valor.
2. Resolver la redundancia de `scripts/install.sh`: documentar su propósito claramente o eliminarlo y dejar únicamente `install.sh` en la raíz.
3. Actualizar el índice de projects activos en `sdd/README.md` y `sdd/workflow.md` para reflejar `mejoras-framework-sdd` en `dev/review`.
4. Volver a correr `./init.sh` después de los cambios y confirmar que sigue pasando con `[OK] Harness SDD listo`.
5. Revisar que no queden archivos untracked ni cambios sin commitear antes de mover la Issue a `dev/testing/`.
