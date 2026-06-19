# [Design] <Título de la issue>

Project: `sdd/projects/<feature-slug>/`
Estado: `<carpeta-actual>`

## Context

Breve descripción del problema u oportunidad.

## Requirements

### R1: [título corto]

CUANDO ..., el sistema DEBE ... (notación EARS).

### R2: [título corto]

...

## Acceptance Criteria

- [ ] Criterio 1 verificable.
- [ ] Criterio 2 verificable.

## BDD Reference

- Issue [Product] aprobada: `sdd/projects/<feature-slug>/product/product-ready/<issue-product>.md`
- Escenarios relevantes para el diseño:
  - **Scenario**: [nombre] — `Given ... When ... Then ...`
  - **Scenario**: [nombre] — `Given ... When ... Then ...`

> El diseño UI/UX debe poder ejecutar los escenarios BDD aprobados en [Product]. Si un escenario no es soportable visualmente, documentar la limitación y notificar al orchestrator.

## UI/UX Design

### Layout

- Estructura de la pantalla, grid, breakpoints, espaciados.

### Colores

- Paleta, estados (default, hover, active, disabled, error, success).

### Tipografía

- Escalas, pesos y estilos.

### Componentes

- Componentes existentes a reutilizar, nuevos a crear, variantes.

### Flujos de UI

- Estados vacío, carga, error, éxito, formularios.

### Interacciones

- Transiciones, hover, focus, modales, drawers.

### Accesibilidad

- Contraste, navegación por teclado, ARIA.

### Assets de diseño

- Herramienta: *(Figma, Pencil, Sketch, etc.)*
- Archivo/Artboard: `<feature-slug>-<screen>`
- Screenshots relevantes: [links o exportaciones]

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| ... | alto/medio/bajo | ... |

## Dependencies

- Bloquea a: `[Dev] <issue-dev>`

## Changelog

| Fecha | Autor | Cambio | Motivo |
|---|---|---|---|
| YYYY-MM-DD | Nombre | Breve descripción del cambio | Por qué se hizo |

> Registrar cambios estructurales o de alcance durante el ciclo de vida de la issue.

## Review

### Veredicto: ✅ Aprobado / ❌ Rechazado

### Hallazgos
1. ...

### Accionables (si fue rechazado)
1. ...
