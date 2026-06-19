# [Design] Integrar BDD con fase de Producto en el SDD

Project: `sdd/projects/integrar-bdd-product/`
Estado: `design/design-ready`

## Context

Diseño de la integración de BDD en el framework SDD. Esta Issue [Design] define cómo se visualiza, estructura y documenta la nueva fase `[Product]` y su relación con `[Design]` y `[Dev]`.

## Requirements

### R1: Estructura de carpetas para [Product]

CUANDO se crea un Project, el sistema DEBE generar `product/discovery/` y `product/product-ready/` junto con `design/` y `dev/`.

### R2: Estados de [Product]

CUANDO una Issue [Product] avanza, el sistema DEBE soportar los estados `product/discovery` → `product/product-ready`.

### R3: Template de [Product]

CUANDO se escribe una Issue [Product], el template DEBE incluir: Problem Statement, Product Goals, Requirements, Acceptance Criteria, BDD Scenarios (Gherkin), Risks y Dependencies.

### R4: Referencia BDD en [Design]

CUANDO se escribe una Issue [Design], DEBE existir una sección que referencie los escenarios BDD aprobados en [Product].

### R5: Referencia BDD en [Dev]

CUANDO se escribe una Issue [Dev], el Test Plan DEBE incluir los escenarios BDD como tests de aceptación.

## Acceptance Criteria

- [ ] El template de [Product] está definido en `sdd/templates/issue-product.md`.
- [ ] El template de [Design] incluye sección `BDD Reference`.
- [ ] El template de [Dev] incluye sección `BDD Test Plan`.
- [ ] `sdd/workflow.md` describe el flujo completo Product → Design → Dev.

## UI/UX Design

No aplica UI visual. El "diseño" es la estructura de la documentación del framework: dónde vive cada sección, cómo se muestran las fases y cómo se navega entre ellas.

### Estructura propuesta

```text
sdd/projects/<slug>/
├── README.md
├── product/
│   ├── discovery/
│   └── product-ready/
├── design/
│   ├── spec-needed/
│   ├── designing/
│   └── design-ready/
└── dev/
    ├── backlog/
    ├── spec-needed/
    ├── spec-ready/
    ├── implementing/
    ├── blocked/
    ├── review/
    ├── rejected/
    ├── testing/
    ├── done/
    └── cancelled/
```

### Navegación entre fases

- `[Product]` en `product-ready/` desbloquea `[Design]`.
- `[Design]` en `design-ready/` desbloquea `[Dev]`.
- `[Dev]` sigue el flujo existente hasta `done/`.

## Risks & Mitigations

| Riesgo | Impacto | Mitigación |
|---|---|---|
| [Product] se confunde con [Design] | medio | Documentar diferencias claras en `sdd/workflow.md` y templates |
| Más carpetas dificultan la navegación | bajo | Mantener nombres cortos y una estructura intuitiva |

## Dependencies

- blockedBy: [Product] `integrar-bdd-product`
- Bloquea a: [Dev] `integrar-bdd-product`
