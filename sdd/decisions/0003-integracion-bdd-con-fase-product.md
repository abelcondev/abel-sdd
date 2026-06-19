# ADR-0003: Integrar BDD con una fase `[Product]` en el SDD

- **Estado**: aprobada
- **Fecha**: 2026-06-19
- **Decisores**: @orchestrator, @specifier, @developer

## Contexto

El framework SDD tenía dos fases explícitas: `[Design]` (spec funcional + UI/UX) y `[Dev]` (spec técnico + implementación). Sin embargo, no había un lugar dedicado para capturar la **voz de producto**: el problema de negocio, los usuarios, las métricas de éxito y los escenarios de comportamiento en lenguaje compartido.

Al adoptar **Behavior-Driven Development (BDD)**, necesitamos un espacio donde los equipos de producto, diseño e ingeniería acuerden comportamientos antes de definir UI/UX o código. Los escenarios Gherkin deben alimentar tanto el spec de `[Design]` como el `Test Plan` de `[Dev]`.

## Decisión

Agregamos una fase `[Product]` como **primera fase obligatoria** del flujo SDD. La fase tiene dos estados:

- `product/discovery/` — iteración de descubrimiento de producto.
- `product/product-ready/` — aprobación de producto; desbloquea `[Design]`.

La Issue `[Product]` incluye: Context, Product Goals, Requirements, Acceptance Criteria, BDD Scenarios (Gherkin), Risks & Mitigations y Dependencies.

`[Design]` no avanza hasta que `[Product]` esté en `product/product-ready/`.

## Consecuencias

### Positivas

- Trazabilidad clara entre negocio, diseño UI/UX e implementación técnica.
- Los escenarios BDD se escriben una sola vez y se reutilizan en `[Design]` (BDD Reference) y `[Dev]` (BDD Test Plan).
- Reduce el riesgo de implementar funcionalidades mal entendidas o desalineadas con el valor de negocio.
- Los templates de `[Design]` y `[Dev]` ganan secciones explícitas de BDD.

### Negativas / trade-offs

- El flujo es más largo: una fase más antes de `[Design]`.
- `init.sh` se vuelve más estricto: exige `[Product]`, `[Design]` y `[Dev]` por project.
- Los repositorios existentes deben migrar sus issues para cumplir la nueva validación.

## Alternativas descartadas

| Alternativa | Por qué no se eligió |
|---|---|
| Incluir BDD dentro de `[Design]` | Mezclaría voz de producto/negocio con UI/UX. Los escenarios BDD deberían existir antes de pensar en pantallas. |
| Estados `product/spec-needed` y `product/spec-ready` | Demasiado parecidos a `[Dev]`; `[Product]` no requiere un gate técnico, solo aprobación de negocio. |
| Fase `[Product]` opcional | Rompería la trazabilidad y haría que `init.sh` tenga casos especiales, complicando la validación. |

## Referencias

- Issue [Product]: `sdd/projects/integrar-bdd-product/product/product-ready/integrar-bdd-product.md`
- Issue [Design]: `sdd/projects/integrar-bdd-product/design/design-ready/integrar-bdd-product.md`
- Issue [Dev]: `sdd/projects/integrar-bdd-product/dev/<estado>/integrar-bdd-product.md`
- Workflow: `sdd/workflow.md`
- Template [Product]: `sdd/templates/issue-product.md`
