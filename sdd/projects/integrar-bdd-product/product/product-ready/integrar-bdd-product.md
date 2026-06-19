# [Product] Integrar BDD con fase de Producto en el SDD

Project: `sdd/projects/integrar-bdd-product/`
Estado: `product/product-ready`

## Context

El framework SDD actual tiene dos fases principales: `[Design]` (spec funcional + UI/UX) y `[Dev]` (spec técnico + implementación). Sin embargo, no hay un lugar explícito para capturar la voz de **producto**: el problema de negocio, los usuarios, las métricas de éxito y los escenarios de comportamiento en lenguaje compartido.

Esta feature integra **BDD (Behavior-Driven Development)** agregando una fase `[Product]` antes de `[Design]`, y manteniendo `[Design]` y `[Dev]` como gates obligatorios.

## Product Goals

- Proveer un espacio para descubrir y documentar comportamientos de producto antes de definir UI/UX.
- Generar escenarios BDD (Gherkin) que alimenten el spec de `[Design]` y el `Test Plan` de `[Dev]`.
- Mantener los gates humanos existentes: spec funcional/UI, diseño UI, spec técnico, review/merge.

## Requirements

### R1: Nueva fase [Product]

CUANDO se crea un Project, el sistema DEBE crear una carpeta `product/` con estados `discovery/` y `product-ready/`.

### R2: Issue [Product]

CUANDO se define una feature, el equipo DEBE poder escribir una Issue `[Product]` con problem statement, usuarios, features, escenarios BDD y métricas de éxito.

### R3: Bloqueo de [Design] por [Product]

CUANDO la Issue `[Product]` no está en `product/product-ready/`, la Issue `[Design]` correspondiente DEBE permanecer en `design/spec-needed/`.

### R4: Escenarios BDD alimentan [Design]

CUANDO se escribe el spec `[Design]`, el sistema DEBE incluir una sección que referencie los escenarios BDD aprobados en `[Product]`.

### R5: Escenarios BDD alimentan [Dev]

CUANDO se escribe el `Test Plan` de `[Dev]`, el sistema DEBE incluir los escenarios BDD como tests de aceptación.

### R6: Actualización de templates

CUANDO se usa el template de `[Product]`, `[Design]` o `[Dev]`, el sistema DEBE tener secciones claras para BDD y trazabilidad entre fases.

### R7: Actualización de scripts y validaciones

CUANDO se corre `init.sh`, el sistema DEBE validar que cada Project tenga al menos una Issue `[Product]`, una `[Design]` y una `[Dev]`.

## Acceptance Criteria

- [ ] Existe `sdd/templates/issue-product.md` con estructura para BDD.
- [ ] `sdd/workflow.md` documenta los estados de `[Product]` y el flujo completo.
- [ ] `scripts/sdd-worktree.sh` crea la carpeta `product/discovery/` y `product/product-ready/`.
- [ ] `scripts/sdd-move.sh` soporta estados `product/discovery` y `product/product-ready`.
- [ ] `init.sh` valida que cada project tenga `[Product]`, `[Design]` y `[Dev]`.
- [ ] Los templates de `[Design]` y `[Dev]` incluyen secciones para referenciar escenarios BDD.
- [ ] Se actualizan los prompts de agentes para reconocer `[Product]`.
- [ ] `./init.sh` pasa en verde.

## BDD Scenarios

### Scenario: Product aprueba y Design puede avanzar

```gherkin
Given una Issue [Product] en "product/product-ready/"
When el leader intenta mover la Issue [Design] a "design/designing/"
Then el movimiento es válido
```

### Scenario: Product no aprueba y Design está bloqueado

```gherkin
Given una Issue [Product] en "product/discovery/"
When el leader intenta mover la Issue [Design] a "design/designing/"
Then el sistema advierte que [Product] aún no está aprobada
```

### Scenario: Escenarios BDD llegan al Test Plan de Dev

```gherkin
Given una Issue [Product] aprobada con escenarios BDD
When se escribe el spec [Dev]
Then el Test Plan incluye los escenarios BDD como tests de aceptación
```

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Añadir una fase más ralentiza el flujo | medio | [Product] es opcional para features sin descubrimiento de negocio; el framework la recomienda pero no la obliga para features triviales |
| Confusión entre [Product] y [Design] | medio | Documentar claramente: [Product] = comportamiento/negocio; [Design] = UI/UX |
| init.sh más lento | bajo | Validaciones son O(n) sobre archivos locales |

## Dependencies

- Bloquea a: `[Design] integrar-bdd-product`
