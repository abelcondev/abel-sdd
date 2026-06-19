# SDD — Workflow, estados y ciclo de vida

Este documento define el flujo de trabajo, los estados y las reglas del SDD.

Para el índice general del SDD, ver `sdd/README.md`.

---

## 1. Entidades

- **Project**: una feature de negocio, representada por `sdd/projects/<slug>/`.
- **Issue `[Product]`**: descubrimiento de producto + escenarios BDD, archivo `.md` dentro de `sdd/projects/<slug>/product/<estado>/`. Es la primera fase y desbloquea `[Design]`.
- **Issue `[Design]`**: spec funcional + UI/UX, archivo `.md` dentro de `sdd/projects/<slug>/design/<estado>/`. Está bloqueada por `[Product]`.
- **Issue `[Dev]`**: spec técnico + implementación, archivo `.md` dentro de `sdd/projects/<slug>/dev/<estado>/`. Está bloqueada por `[Design]`.

---

## 2. Estructura

```text
sdd/
├── README.md                 # Índice del SDD
├── workflow.md               # Este documento
├── architecture.md           # Stack y decisiones arquitectónicas (a completar)
├── conventions.md            # Convenciones de código (a completar)
├── quality-gates.md          # Definition of Ready / Done
├── testing.md                # Estrategia de testing y TDD
├── security.md               # Seguridad y cumplimiento
├── delivery.md               # Commits, PRs, merge y cierre
├── decisions/                # ADRs por feature o globales
├── templates/                # Templates para projects e issues
└── projects/
    └── <feature-slug>/
        ├── README.md
        ├── product/
        │   ├── discovery/       ← iteración de descubrimiento de producto
        │   └── product-ready/   ← aprobado, desbloquea [Design]
        ├── design/
        │   ├── spec-needed/
        │   ├── designing/
        │   └── design-ready/
        └── dev/
            ├── backlog/
            ├── spec-needed/
            ├── spec-ready/
            ├── implementing/
            ├── blocked/         ← issue pausada por bloqueo
            ├── review/
            ├── rejected/        ← issue rechazada en review
            ├── testing/
            ├── done/
            └── cancelled/       ← issue descartada
```

### Convenciones de naming

| Entidad | Ruta | Título dentro del archivo |
|---|---|---|
| Project | `sdd/projects/login-y-dashboard-layout/README.md` | `Login y dashboard layout` |
| Issue Product | `sdd/projects/login-y-dashboard-layout/product/discovery/login.md` | `[Product] Login` |
| Issue Design | `sdd/projects/login-y-dashboard-layout/design/spec-needed/login.md` | `[Design] Login` |
| Issue Dev | `sdd/projects/login-y-dashboard-layout/dev/backlog/login.md` | `[Dev] Login` |

Los slugs usan kebab-case, minúsculas, sin tildes.

---

## 3. Estados

### Issue `[Product]`

```text
discovery → product-ready
```

| Carpeta | Significado |
|---|---|
| `product/discovery/` | Se descubre e itera el comportamiento de producto, usuarios y escenarios BDD. |
| `product/product-ready/` | Spec de producto aprobado. La Issue `[Design]` puede avanzar. |

### Issue `[Design]`

```text
spec-needed → designing → design-ready
```

| Carpeta | Significado |
|---|---|
| `design/spec-needed/` | Issue creada, falta el spec funcional/UI. Bloqueada hasta que `[Product]` esté en `product-ready/`. |
| `design/designing/` | Se itera el diseño visual en la herramienta de diseño del proyecto. |
| `design/design-ready/` | Diseño y spec aprobados. La Issue `[Dev]` puede avanzar. |

### Issue `[Dev]`

```text
backlog → spec-needed → spec-ready → implementing → review → testing → done
                    ↓         ↓           ↓              ↑
                blocked   blocked     blocked      rejected
                                    cancelled
```

| Carpeta | Significado |
|---|---|
| `dev/backlog/` | Issue registrada, bloqueada por `[Design]`. |
| `dev/spec-needed/` | Falta el spec técnico. |
| `dev/spec-ready/` | Spec técnico completo. Espera aprobación humana. |
| `dev/implementing/` | Developer trabajando en el worktree. |
| `dev/blocked/` | Issue pausada por bloqueo externo o decisión pendiente. |
| `dev/review/` | Código listo. Auditor verificando. |
| `dev/rejected/` | Auditor rechazó. Requiere retrabajo antes de volver a `implementing/`. |
| `dev/testing/` | Mergeado. Validación final. |
| `dev/done/` | Feature completada y verificada. |
| `dev/cancelled/` | Issue descartada. Se conserva por trazabilidad. |

### Estados transversales

- **blocked/**: puede usarse desde `spec-needed/`, `spec-ready/` o `implementing/`. Se vuelve al estado anterior cuando se desbloquea.
- **rejected/**: solo desde `review/`. Debe volver a `implementing/` con accionables claros.
- **cancelled/**: estado final para issues descartadas.

---

## 4. Cómo se modela una feature

Cada feature tiene su propio **worktree aislado** desde el inicio. Dentro del worktree se escriben los specs, se itera el diseño y se implementa el código.

1. Crear el worktree de la feature:
   ```bash
   ./scripts/sdd-worktree.sh create <feature-slug>
   ```
   Esto crea:
   - Rama `feature/<feature-slug>`.
   - Worktree en `<repo-principal>-<feature-slug>/`.
   - Estructura vacía en `sdd/projects/<feature-slug>/`.
2. Abrir el agente de coding dentro del worktree.
3. Completar `README.md` del project y crear issues como archivos `.md` dentro de las carpetas de estado. Empezar por `[Product]`.
4. Mover los archivos físicamente entre carpetas cuando cambian de estado.
5. Mergear el worktree a `main` al terminar y eliminarlo.

> El proyecto debe completar `sdd/architecture.md` y `sdd/conventions.md` para que los agentes sepan qué stack y estilo usar.

---

## 5. Workflow

1. **Idea**: el humano describe la feature. El `orchestrator` crea el worktree con `./scripts/sdd-worktree.sh create <feature-slug>`.
2. **Product Discovery** (dentro del worktree): el `specifier` entrevista al humano y escribe el spec de producto + escenarios BDD en `product/discovery/`. El `orchestrator` mueve el archivo a `product/product-ready/`.
3. **Product review** (gate 0): humano aprueba. La Issue `[Product]` queda en `product/product-ready/` y desbloquea `[Design]`.
4. **Spec Design** (dentro del worktree): el `specifier` entrevista al humano y escribe el spec funcional + UI/UX en `design/spec-needed/`, referenciando los escenarios BDD de `[Product]`. El `orchestrator` mueve el archivo a `design/designing/`.
5. **Spec review** (gate 1): humano aprueba. El `orchestrator` mueve el archivo a `design/design-ready/`.
6. **Design iteration**: se itera el diseño visual en la herramienta de diseño del proyecto.
7. **Design review** (gate 2): humano aprueba diseño. La Issue `[Design]` queda en `design/design-ready/`.
8. **Spec Dev** (dentro del worktree): el `specifier` escribe el spec técnico + Test Plan en `dev/spec-needed/`, incluyendo los escenarios BDD como tests de aceptación. El `orchestrator` mueve el archivo a `dev/spec-ready/`.
9. **Spec technical review** (gate 3): humano aprueba. El `orchestrator` mueve el archivo a `dev/implementing/`.
10. **Implementation** (dentro del worktree): el `developer` ejecuta TDD por cada `R<n>` y por cada escenario BDD, escribiendo código en la ubicación que el proyecto defina. Al terminar y pasar `init.sh`, el `orchestrator` mueve el archivo a `dev/review/`.
11. **Review**: el `auditor` audita contra `sdd/quality-gates.md` C1–C7. Si aprueba: mueve el archivo a `dev/testing/` y espera validación humana del merge. Si rechaza: mueve el archivo a `dev/rejected/` con accionables.
12. **Testing** (gate 4): humano valida el merge. El `orchestrator` mergea el worktree a `main`, elimina el worktree y mueve el archivo a `dev/done/`.

---

## 6. Cómo mover un issue de estado

Usar el helper:

```bash
./scripts/sdd-move.sh <project> <issue> <estado-origen> <estado-destino>
```

Ejemplo:

```bash
./scripts/sdd-move.sh login-y-dashboard-layout login design/spec-needed design/designing
./scripts/sdd-move.sh login-y-dashboard-layout login dev/implementing dev/review
```

Esto ejecuta `git mv` y genera el commit de estado automáticamente:

```text
chore(sdd): login [Design] spec-needed → designing
```

Para movimientos manuales:

```bash
git mv sdd/projects/login-y-dashboard-layout/design/spec-needed/login.md \
       sdd/projects/login-y-dashboard-layout/design/designing/login.md
```

El `orchestrator` commitea el cambio de estado:

```text
chore(sdd): login [Design] spec-needed → designing
```

---

## 7. Worktree

Cada feature vive en su propio worktree desde el inicio:

```bash
./scripts/sdd-worktree.sh create login-y-dashboard-layout
```

Crea:

- Rama: `feature/login-y-dashboard-layout`
- Worktree: `<repo-principal>-login-y-dashboard-layout/`
- Estructura vacía en `sdd/projects/login-y-dashboard-layout/`

> El script no instala dependencias ni copia archivos de entorno. Cada proyecto debe preparar su propio entorno según su stack.

Para eliminar:

```bash
./scripts/sdd-worktree.sh remove login-y-dashboard-layout
```

---

## 8. Diseño visual

El SDD asume que el proyecto usa una **herramienta de diseño visual** (Figma, Pencil, Sketch, etc.) como referencia para nuevas pantallas y componentes.

- Todo **nuevo** componente o pantalla debe existir primero en la herramienta de diseño del proyecto.
- El link al artboard se incluye en la sección `UI/UX Design` de la Issue `[Design]`.
- Los componentes base existentes en código son la **fuente de verdad funcional**; la herramienta de diseño actúa como referencia visual y documentación.
- El developer no modifica componentes base existentes sin una issue específica.

> El proyecto documenta en `sdd/conventions.md` o `sdd/architecture.md` qué herramienta de diseño usa y cómo se sincroniza con el código.

---

## 9. Versionado del spec

- **Ediciones menores**: editar el archivo directamente.
- **Cambios estructurales**: agregar una sección `## Changelog` al final del issue con fecha, qué cambió y por qué.
- **Cambios durante implementación**: requieren re-aprobación humana. Si `[Design]` cambia mientras `[Dev]` está en `implementing/` o más allá, el `orchestrator` debe mover `[Dev]` a `backlog/` o `spec-needed/`.

---

## 10. Gates humanos

1. **Producto / BDD** (`discovery/` → `product-ready/`).
2. **Spec funcional/UI** (`spec-needed/` → `designing/`).
3. **Diseño UI** (`designing/` → `design-ready/`).
4. **Spec técnico** (`spec-needed/` → `spec-ready/` → `implementing/`).
5. **Review/merge** (`review/` → `testing/`).

---

## 11. Reglas de oro

- Una sola Issue `[Dev]` en `implementing/` o `review/` a la vez.
- `[Dev]` no avanza hasta que `[Design]` esté en `design/design-ready/`.
- `[Design]` no avanza hasta que `[Product]` esté en `product/product-ready/`.
- `[Design]` se considera cerrada cuando llega a `design/design-ready/`.
- `[Product]` se considera cerrada cuando llega a `product/product-ready/`.
- Producto antes de diseño, diseño antes de código.
- Tests antes de implementación (TDD).
- `sdd/` es la fuente de verdad; no hay `feature_list.yaml` ni carpeta `specs/` fuera de `sdd/`.
- Todo cambio importante se registra en `sdd/projects/` o en `sdd/decisions/`.
- Dejar el repo limpio al cerrar: sin archivos temporales ni branches huérfanos.

---

## 12. Índice de projects activos

| Feature | Product | Design | Dev | Worktree |
|---|---|---|---|---|
| `renombrar-agentes-sdd` | `product-ready` | `design-ready` | `review` | `abel-sdd-renombrar-agentes-sdd` |

> Este índice se actualiza manualmente.
