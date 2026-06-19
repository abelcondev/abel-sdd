# [Product] Renombrar agentes del SDD

Project: `sdd/projects/renombrar-agentes-sdd/`
Estado: `product/product-ready`

## Context

Los nombres actuales de los agentes (`leader`, `spec_author`, `implementer`, `reviewer`) son funcionales pero poco descriptivos para nuevos usuarios. Queremos nombres que reflejen mejor la responsabilidad de cada rol.

## Product Goals

- Hacer más explícito qué hace cada agente.
- Reducir confusión entre los roles.
- Mantener la compatibilidad del flujo SDD.

## Requirements

### R1: Renombrar leader a orchestrator

CUANDO un usuario lee la documentación, el agente `leader` DEBE llamarse `orchestrator`.

### R2: Renombrar spec_author a specifier

CUANDO un usuario lee la documentación, el agente `spec_author` DEBE llamarse `specifier`.

### R3: Renombrar implementer a developer

CUANDO un usuario lee la documentación, el agente `implementer` DEBE llamarse `developer`.

### R4: Renombrar reviewer a auditor

CUANDO un usuario lee la documentación, el agente `reviewer` DEBE llamarse `auditor`.

## Acceptance Criteria

- [ ] Los archivos en `.claude/agents/` usan los nuevos nombres.
- [ ] Todos los docs (`AGENTS.md`, `CLAUDE.md`, `sdd/*.md`) referencian los nuevos nombres.
- [ ] Los prompts internos de cada agente usan su nuevo nombre.
- [ ] `init.sh` pasa en verde.

## BDD Scenarios

### Scenario: Documentación usa nuevos nombres

```gherkin
Given un usuario abre AGENTS.md
When busca los roles del SDD
Then ve orchestrator, specifier, developer y auditor
And no ve leader, spec_author, implementer ni reviewer
```

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Referencias antiguas queden sueltas | alto | Buscar globalmente todos los nombres viejos |
| Agentes de sesiones previas no reconozcan nuevos nombres | bajo | Los nombres son internos al framework; las sesiones futuras usarán los nuevos |

## Dependencies

- Bloquea a: `[Design] renombrar-agentes-sdd`
