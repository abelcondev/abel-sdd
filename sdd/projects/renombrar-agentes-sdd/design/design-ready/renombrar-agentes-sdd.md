# [Design] Renombrar agentes del SDD

Project: `sdd/projects/renombrar-agentes-sdd/`
Estado: `design/design-ready`

## Context

Diseño de la refactorización de nombres de agentes en el framework SDD. No hay UI visual; el diseño es la estructura de archivos y documentación.

## Requirements

### R1: Archivos renombrados

CUANDO se liste `.claude/agents/`, el sistema DEBE mostrar `orchestrator.md`, `specifier.md`, `developer.md` y `auditor.md`.

### R2: Referencias actualizadas

CUANDO se busque un nombre antiguo en el repo, el sistema NO DEBE encontrar referencias en docs o scripts.

## BDD Reference

- Issue [Product]: `sdd/projects/renombrar-agentes-sdd/product/product-ready/renombrar-agentes-sdd.md`
- Escenarios:
  - Documentación usa nuevos nombres.
  - No quedan referencias antiguas.

## UI/UX Design

No aplica. Esta feature es de documentación y estructura interna.

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Quedan strings viejos en algún archivo | alto | Búsqueda global `grep -R` |

## Dependencies

- blockedBy: [Product] `renombrar-agentes-sdd`
- Bloquea a: `[Dev] renombrar-agentes-sdd`
