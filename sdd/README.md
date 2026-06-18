# SDD — Software Design & Development

Este directorio es la **fuente de verdad** del flujo SDD de este proyecto.

- Los **specs** viven en `sdd/projects/`.
- El **estado** de cada issue se representa por la **carpeta** donde está su archivo `.md`.
- El flujo SDD es **agnóstico al stack**: no impone lenguaje, framework ni herramientas. Cada proyecto completa `sdd/architecture.md` y `sdd/conventions.md` con sus propias decisiones.

---

## Mapa del SDD

| Archivo | Propósito |
|---|---|
| `sdd/README.md` | Este índice. |
| `sdd/workflow.md` | Estados, flujo de trabajo, worktrees, reglas de oro. |
| `sdd/architecture.md` | **Plantilla** para definir el stack, capas y decisiones arquitectónicas del proyecto. |
| `sdd/conventions.md` | **Plantilla** para definir estilo de código, naming y convenciones del proyecto. |
| `sdd/quality-gates.md` | Definition of Ready/Done y checklist C1–C7. |
| `sdd/testing.md` | Estrategia de testing, TDD, fixtures, cobertura. |
| `sdd/security.md` | Principios de seguridad, RBAC, PII, cumplimiento. |
| `sdd/troubleshooting.md` | Guía de problemas comunes y soluciones del framework SDD. |
| `sdd/delivery.md` | Commits, PRs, merge y cierre. |
| `sdd/decisions/` | ADRs (Architecture Decision Records) del proyecto. |
| `sdd/templates/` | Templates para projects e issues. |
| `sdd/projects/` | Projects e issues activas. |

---

## Cómo empezar

1. Completar `sdd/architecture.md` con el stack y decisiones arquitectónicas del proyecto.
2. Completar `sdd/conventions.md` con estilo, naming y convenciones del proyecto.
3. Leer `sdd/workflow.md` para entender el ciclo de vida.
4. Leer `sdd/quality-gates.md`, `sdd/testing.md` y `sdd/security.md` antes de declarar `done`.
5. Crear una feature:
   ```bash
   ./scripts/sdd-worktree.sh create <feature-slug>
   ```
6. Mover issues entre estados:
   ```bash
   ./scripts/sdd-move.sh <project> <issue> <origen> <destino>
   ```

---

## Reglas de oro (resumen)

- Una sola Issue `[Dev]` en `implementing/` o `review/` a la vez.
- `[Dev]` no avanza hasta que `[Design]` esté en `design/design-ready/`.
- Tests antes de implementación (TDD).
- `init.sh` verde antes de declarar `done`.
- `sdd/` es la fuente de verdad.

---

## Índice de projects activos

| Feature | Design | Dev | Worktree |
|---|---|---|---|
| `mejoras-framework-sdd` | `design-ready` | `review` | `/Users/abelconde/Zed/abel-sdd-mejoras-framework-sdd` |

> Para más detalle, ver `sdd/workflow.md`.
