# ADR-0002: Markdown como fuente de verdad

- **Estado**: aprobada
- **Fecha**: 2026-06-18
- **Decisores**: equipo SDD

## Contexto

El framework SDD necesita registrar specs, decisiones y estado de las features de forma que:

- Sea legible sin herramientas especiales.
- Esté versionada junto con el código.
- Pueda consultarse offline.
- No dependa de la disponibilidad de un servicio externo.

Los sistemas de tickets externos (Jira, Linear, GitHub Issues, etc.) cumplen algunas funciones pero no todas: requieren conexión, no versionan el cambio de estado junto al código y dificultan la correlación entre spec y commits.

## Decisión

Usar **archivos Markdown en el repositorio** como fuente de verdad:

- Cada Project es un directorio en `sdd/projects/<feature-slug>/`.
- Cada Issue es un archivo `.md` dentro de carpetas que representan su estado (`design/spec-needed/`, `dev/implementing/`, etc.).
- Los ADRs viven en `sdd/decisions/`.
- El estado de una Issue se determina por la carpeta donde reside su archivo.
- Los cambios de estado se commitean con `scripts/sdd-move.sh`.

## Consecuencias

### Positivas

- Todo el conocimiento de la feature viaja con el código en el mismo repositorio.
- El historial de Git registra cuándo y por qué cambió el estado de una Issue.
- No se requieren permisos ni conexión a un sistema externo para leer specs.
- Fácil de auditar, diffiar y recuperar.

### Negativas / trade-offs

- No hay paneles ni filtros automáticos como en un ticket system; el índice se actualiza manualmente.
- Las imágenes y assets grandes no deben alojarse en Git; se referencian desde la herramienta de diseño.
- Requiere disciplina del equipo para mover archivos y commitear cambios de estado.

## Alternativas descartadas

| Alternativa | Por qué no se eligió |
|---|---|
| GitHub Issues / Jira como fuente de verdad | Dependencia de servicio externo, no versionado junto al código, difícil de auditar offline. |
| YAML/JSON para specs | Menos legible para humanos y reviewers; requiere parser específico. |
| Wiki del repo | No representa el estado por carpeta; menos estructurado para el workflow SDD. |

## Referencias

- `sdd/workflow.md` — estados y estructura de carpetas.
- `sdd/README.md` — índice del SDD.
- `scripts/sdd-move.sh` — mover issues entre estados.
