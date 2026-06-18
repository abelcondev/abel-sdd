# AGENTS.md — Mapa para Agentes del SDD

Este archivo es el **punto de entrada** para cualquier agente que trabaje en un proyecto que use el SDD.

NO es una biblia de reglas: es un **mapa**. Lee solo lo que necesites cuando lo necesites.

---

## 1. Before starting (obligatorio)

En cada sesión, el agente leader DEBE:

1. **Leer `CLAUDE.md`** — fuerza el rol leader.
2. **Leer `sdd/README.md`** — entiende el flujo SDD.
3. **Consultar `sdd/projects/`** — estado actual de features e issues.
4. **Correr `init.sh` bajo demanda** — cuando el usuario lo pida, antes de declarar `done`, o cuando haya cambios que justifiquen verificar el entorno. No ejecutarlo automáticamente al inicio de cada sesión.

---

## 2. Mapa del repositorio

| Ruta/Archivo | Contenido | ¿Cuándo leerlo? |
|---|---|---|
| `CLAUDE.md` | Forzador de rol leader + stack mínimo | Siempre al inicio |
| `AGENTS.md` | Este archivo — mapa y hard rules | Siempre al inicio |
| `sdd/README.md` | Índice del SDD | Antes de cualquier trabajo |
| `sdd/workflow.md` | Estados, flujo de trabajo, worktrees, reglas de oro | Antes de cualquier trabajo |
| `sdd/architecture.md` | **Plantilla** de stack y decisiones arquitectónicas | Antes de implementar |
| `sdd/conventions.md` | **Plantilla** de estilo, naming e idioma | Antes de escribir código |
| `sdd/quality-gates.md` | Definition of Ready/Done, checklist C1–C7 | Antes de declarar done |
| `sdd/testing.md` | Estrategia de testing, TDD, fixtures, cobertura | Antes de escribir tests |
| `sdd/security.md` | Seguridad, RBAC, PII, cumplimiento | Antes de implementar features con datos sensibles |
| `sdd/delivery.md` | Commits, PRs, merge y cierre | Antes de entregar |
| `sdd/decisions/` | ADRs (Architecture Decision Records) | Cuando se toman decisiones arquitectónicas |
| `scripts/sdd-worktree.sh` | Gestor de worktrees | Al crear una feature |
| `scripts/sdd-move.sh` | Mover issues entre estados | Al cambiar estado |
| `.claude/agents/` | Definiciones de roles | Nunca editar directamente |
| `sdd/projects/` | Projects, issues y specs locales | Fuente de verdad del flujo SDD |

---

## 3. Hard rules

Reglas no negociables:

- **Cada feature es un Project en `sdd/projects/<slug>/`**, con al menos una Issue `[Design]` y una Issue `[Dev]`.
- **Cada feature vive en su propio worktree** desde el inicio: `<repo-principal>-<feature-slug>/`.
- **Una sola Issue `[Dev]` en `Implementing` o `Review` a la vez**.
- **No declarar `done` sin `init.sh` verde**.
- **No saltear gates humanos**:
  1. `Spec Needed` → `Designing` (aprobación del spec funcional/UI).
  2. `Designing` → `Design Ready` (aprobación del diseño UI).
  3. `Spec Ready` → `Implementing` (aprobación del spec técnico).
  4. `Review` → `Testing` (aprobación del review/merge).
- **Issue `[Design]` se considera cerrada cuando llega a `Design Ready`**.
- **Issue `[Dev]` no avanza hasta que Issue `[Design]` esté en `Design Ready`**.
- **Tests antes de implementación (TDD)**. Cada `R<n>` genera al menos un test rojo antes del código.
- **No editar código de producción directamente desde el leader**. El leader orquesta; el implementer escribe código.
- **Todo cambio importante se registra**, no solo en el chat: en `sdd/projects/` (estado, descripción de Issue/Project), o en `sdd/decisions/` cuando afecta la arquitectura.
- **`sdd/` es la fuente de verdad** para estado, specs y tareas. No hay `feature_list.yaml` ni `specs/` local.
- **Ninguna Issue `[Dev]` con UI pasa a `Implementing` sin diseño aprobado en `[Design]`**.
- **Dejar el repo limpio al cerrar**. Sin archivos temporales ni branches huérfanos.

---

## 4. Workflow SDD local

`sdd/` es la fuente de verdad. Ver `sdd/workflow.md` para el detalle completo.

### Entidades

```text
sdd/projects/<feature-slug>/ = Feature (ej. "login-y-dashboard-layout")
  ├── README.md = contexto, alcance y out-of-scope de la feature
  ├── design/
  │   ├── spec-needed/   = issues con spec funcional/UI pendiente
  │   ├── designing/     = issues iterando diseño UI
  │   └── design-ready/  = issues aprobadas
  └── dev/
      ├── backlog/       = issues bloqueadas por [Design]
      ├── spec-needed/   = issues con spec técnico pendiente
      ├── spec-ready/    = issues con spec técnico completo (espera aprobación)
      ├── implementing/  = issues en implementación
      ├── blocked/       = issues pausadas por bloqueo externo
      ├── review/        = issues en review
      ├── rejected/      = issues rechazadas en review (retrabajo)
      ├── testing/       = issues mergeadas, en validación final
      ├── done/          = issues completadas
      └── cancelled/     = issues descartadas
```

### Estados

**Issue `[Design]`**:

```text
spec-needed → designing → design-ready
```

| Estado | Significado |
|---|---|
| `spec-needed` | Issue creada. Falta escribir el spec funcional + UI/UX. |
| `designing` | Se itera el diseño UI en la herramienta de diseño del proyecto. |
| `design-ready` | Diseño UI aprobado. La Issue `[Dev]` puede avanzar. |

**Issue `[Dev]`**:

```text
backlog → spec-needed → spec-ready → implementing → review → testing → done
                    ↓         ↓           ↓              ↑
                blocked   blocked     blocked      rejected
                                    cancelled
```

| Estado | Significado |
|---|---|
| `backlog` | Issue creada, bloqueada por `[Design]`. |
| `spec-needed` | Falta escribir el spec técnico + plan de implementación + Test Plan. |
| `spec-ready` | Spec técnico completo. Espera aprobación humana. |
| `implementing` | Implementer trabajando en el worktree. |
| `blocked` | Issue pausada por bloqueo externo o decisión pendiente. |
| `review` | Código listo. Reviewer verificando. |
| `rejected` | Reviewer rechazó. Requiere retrabajo. |
| `testing` | Mergeado. Validación final. |
| `done` | Feature completada y verificada. |
| `cancelled` | Issue descartada. |

### Responsabilidades por fase

| Fase | Responsable | Acción |
|---|---|---|
| Idea | Humano/Leader | Crear worktree de feature con `./scripts/sdd-worktree.sh create <feature-slug>`. |
| Spec Design | spec_author | Entrevistar al humano con `AskUserQuestion` y escribir spec en archivo de Issue `[Design]`. |
| Spec review | Humano | Aprobar spec funcional/UI. Leader mueve el archivo a `design/designing/` con `./scripts/sdd-move.sh`. |
| Diseño UI | Humano/Agente asistido | Iterar en la herramienta de diseño del proyecto. Actualizar assets en Issue `[Design]`. |
| Design review | Humano | Aprobar diseño. Leader mueve el archivo a `design/design-ready/`. |
| Spec Dev | spec_author | Escribir spec técnico + Test Plan + Impact Analysis en archivo de Issue `[Dev]`. Leader mueve a `dev/spec-needed/` o `dev/spec-ready/`. |
| Spec technical review | Humano | Aprobar spec técnico. Leader mueve a `dev/implementing/`. |
| Implementación | implementer | Ejecutar TDD: escribir tests rojos, implementación mínima, refactor. Escribir código en el proyecto. Al terminar, leader mueve a `dev/review/`. |
| Review | reviewer | Auditar contra `sdd/quality-gates.md` C1–C7 y `sdd/security.md`. |
| Closure | Leader | Mergear el worktree a `main`, eliminar worktree, mover archivo a `dev/done/`. |

---

## 5. Session close lifecycle

Antes de declarar una sesión cerrada:

1. Correr `init.sh`. Debe imprimir `[OK] Harness SDD listo`.
2. Si se terminó una Issue `[Dev]`, asegurar que su archivo esté en `dev/done/`.
3. Si se cerró una Issue `[Design]`, asegurar que su archivo esté en `design/design-ready/`.
4. Actualizar `sdd/README.md` y `sdd/workflow.md` con el estado actual de projects.
5. Asegurar que no haya archivos untracked sospechosos.

---

## 6. If blocked

Si un agente se bloquea:

1. Re-leer los docs relevantes.
2. Mover la Issue a `dev/blocked/` con `./scripts/sdd-move.sh`.
3. Documentar el bloqueo como comentario en la Issue correspondiente de `sdd/projects/` (`[Design]` o `[Dev]`).
4. Parar la sesión. No inventar workarounds.
