# [Dev] <Título de la issue>

Project: `sdd/projects/<feature-slug>/`
Estado: `<carpeta-actual>`

## Context

Implementación de [<feature>], basada en el diseño aprobado en [Issue Design].

## Technical Decisions

### D1: [título]

- **Elegido**: [opción]
- **Alternativas descartadas**: [B], [C]
- **Razón**: [por qué]
- **Impacto**: [módulos afectados]

### D2: ...

## Impact Analysis

| Módulo | Acción | Contrato expuesto |
|---|---|---|
| `<ruta-al-módulo-1>/` | crear / modificar | ... |
| `<ruta-al-módulo-2>/` | reutilizar | — |

## Technical Notes

- Tablas, APIs, librerías, consideraciones.

## Implementation Plan

1. Paso 1.
2. Paso 2.
3. Paso 3.

## Test Plan

| Requisito | Test de aceptación | Tipo | Prioridad |
|---|---|---|---|
| R1 | ... | unitario / integración | obligatorio |
| R2 | ... | unitario / integración | obligatorio |

## Security Considerations

- [ ] RBAC: roles que pueden ejecutar cada acción.
- [ ] Inputs sanitizados y validados.
- [ ] No se expone PII.
- [ ] Audit trail en mutaciones críticas.

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| ... | alto/medio/bajo | ... |

## Dependencies

- blockedBy: [Design] `<issue-design>`

## UI Reference

- Diseño aprobado: `sdd/projects/<feature-slug>/design/design-ready/`
- Artboards: `<feature-slug>-<screen>`
- Screenshots: [links]
