# [Product] Mejoras del framework SDD

Project: `sdd/projects/mejoras-framework-sdd/`
Estado: "product/product-ready"

## Context

El framework SDD fue extraído como base común para proyectos nuevos, pero tenía plantillas vacías, scripts con bordes afilados y poca documentación de soporte. Esta feature prioriza las mejoras necesarias para que equipos puedan adoptar el SDD sin fricción.

## Product Goals

- Reducir el tiempo de setup de un nuevo project SDD.
- Aumentar la confianza en los scripts de trabajo mediante validaciones claras.
- Proveer ejemplos y guías dentro de las plantillas principales.
- Documentar decisiones arquitectónicas y problemas comunes.

## Requirements

### R1: Completar plantillas del framework

CUANDO un proyecto adopta el SDD, DEBE encontrar ejemplos o guías claras en `sdd/architecture.md` y `sdd/conventions.md`.

### R2: Robustecer los scripts de trabajo

CUANDO se usa `sdd-worktree.sh`, `sdd-move.sh` o `install.sh`, el sistema DEBE validar argumentos y evitar sobreescrituras.

### R3: Agregar automatización y quality gates

CUANDO se corre `init.sh`, el sistema DEBE validar el estado SDD.

### R4: Mejorar templates de issues

CUANDO se crea una Issue `[Design]` o `[Dev]`, el template DEBE incluir secciones de review y trazabilidad.

### R5: Mejorar la experiencia de instalación

CUANDO se instala el SDD, `install.sh` DEBE verificar prerequisitos y permitir actualización controlada.

### R6: Agregar documentación adicional

CUANDO un usuario consulta el framework, DEBE encontrar ADRs y guía de troubleshooting.

### R7: Fortalecer la integración con agentes

CUANDO los agentes operan, sus prompts DEBEN recordar regles clave del SDD.

## Acceptance Criteria

- [x] `sdd/architecture.md` y `sdd/conventions.md` contienen ejemplos o guías claras.
- [x] Los scripts validan slugs, estados y evitan sobreescrituras.
- [x] `init.sh` valida projects, issues y concurrencia.
- [x] Los templates incluyen secciones `Review` y `Changelog`.
- [x] `install.sh` verifica repo destino y ofrece modo update.
- [x] Existen ADRs iniciales y `sdd/troubleshooting.md`.
- [x] Los prompts de agentes refuerzan reglas de commits y harness.

## BDD Scenarios

### Scenario: init.sh detecta múltiples issues en progreso

```gherkin
Given dos Issues [Dev] en implementing/
When se corre ./init.sh
Then el harness reporta un error de concurrencia
```

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Cambios en scripts rompen flujo existente | alto | Validar con `init.sh` tras cada cambio |
| Sobreescribir customizaciones del proyecto destino | alto | Backup en `install.sh --update` |

## Dependencies

- blockedBy: —
- Bloquea a: `[Design] mejoras-framework-sdd`

## Review

### Veredicto: ✅ Aprobado

### Hallazgos
1. Producto aprobado. Se desbloquea `[Design]`.

### Accionables
1. Ninguno.
