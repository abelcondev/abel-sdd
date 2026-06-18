# [Dev] Mejoras del framework SDD

Project: `sdd/projects/mejoras-framework-sdd/`
Estado: "dev/review"

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
