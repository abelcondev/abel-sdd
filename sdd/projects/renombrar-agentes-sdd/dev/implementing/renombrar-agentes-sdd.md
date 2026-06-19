# [Dev] Renombrar agentes del SDD

Project: `sdd/projects/renombrar-agentes-sdd/`
Estado: `dev/implementing`

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
