# [Design] Mejoras del framework SDD

Project: `sdd/projects/mejoras-framework-sdd/`
Estado: "design/designing"

## Context

El framework SDD fue recién extraído y contiene plantillas vacías, scripts con oportunidades de robustez, y ausencia de automatización. Esta feature aplica 7 mejoras identificadas para hacer el framework más completo, robusto y fácil de adoptar.

## Requirements

### R1: Completar plantillas del framework

CUANDO un proyecto adopta el SDD, DEBE encontrar ejemplos o guías claras en `sdd/architecture.md` y `sdd/conventions.md` para completar sus propias decisiones.

### R2: Robustecer los scripts de trabajo

CUANDO se usa `sdd-worktree.sh`, `sdd-move.sh` o `install.sh`, el sistema DEBE validar argumentos, detectar errores comunes y evitar sobreescrituras no deseadas.

### R3: Agregar automatización y quality gates

CUANDO se corre `init.sh`, el sistema DEBE validar el estado SDD (proyectos, issues, concurrencia) además de la existencia de archivos.

### R4: Mejorar templates de issues

CUANDO se crea una Issue `[Design]` o `[Dev]`, el template DEBE incluir secciones para review, trazabilidad y metadatos útiles.

### R5: Mejorar la experiencia de instalación

CUANDO se instala el SDD en un proyecto destino, `install.sh` DEBE verificar prerequisitos y ofrecer una forma de actualizar sin perder customizaciones.

### R6: Agregar documentación adicional

CUANDO un usuario consulta el framework, DEBE encontrar ADRs de decisiones clave, guía de troubleshooting y ejemplos de primer uso.

### R7: Fortalecer la integración con agentes

CUANDO los agentes `spec_author`, `implementer` y `reviewer` operan, sus prompts DEBEN recordar regles clave como evitar `Co-Authored-By` y manejar cambios en `init.sh`.

## Acceptance Criteria

- [ ] `sdd/architecture.md` y `sdd/conventions.md` contienen ejemplos completos o secciones guía.
- [ ] Los scripts validan slugs, estados, repositorios destino y evitan sobreescrituras silenciosas.
- [ ] `init.sh` detecta múltiples issues en `implementing/`/`review/` y projects sin `[Design]`/`[Dev]`.
- [ ] Los templates incluyen secciones de `Review` y `Changelog`.
- [ ] `install.sh` verifica que el destino sea un repo Git y ofrece modo de actualización controlada.
- [ ] Existen ADRs iniciales y guía de troubleshooting.
- [ ] Los prompts de agentes refuerzan reglas de commits y manejo de cambios en el harness.
- [ ] `./init.sh` pasa en verde al finalizar.

## UI/UX Design

No aplica. Esta feature es de tooling, documentación y automatización del framework. No introduce componentes visuales.

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Cambios en scripts rompan flujo existente | alto | Mantener compatibilidad de comandos y validar con `init.sh` |
| Sobreescribir customizaciones del proyecto destino | alto | `install.sh` debe preguntar o hacer backup de archivos modificados |
| Complejizar el framework inicial | medio | Agregar mejoras de forma incremental y documentada |

## Dependencies

- Bloquea a: `[Dev] mejoras-framework-sdd`
