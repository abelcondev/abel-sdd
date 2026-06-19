# abel-sdd

[![CI](https://github.com/abelcondev/abel-sdd/actions/workflows/ci.yml/badge.svg)](https://github.com/abelcondev/abel-sdd/actions/workflows/ci.yml)

> Framework de trabajo **agnóstico al stack** para diseñar, construir y entregar software con specs, gates humanos, worktrees y TDD.

## ¿Qué es?

**abel-sdd** es un flujo de trabajo basado en Markdown + Git para gobernar el desarrollo de features sin depender de un ticket system externo.

- **Markdown** como fuente de verdad de specs e issues.
- **Git** como historial de estados.
- **Worktrees** como aislamiento por feature.
- **Gates humanos** como puntos de control obligatorios.
- **TDD** como forma de construir con tests.

No impone lenguaje, framework, base de datos, package manager ni herramienta de diseño. Cada proyecto completa sus propias decisiones en `sdd/architecture.md` y `sdd/conventions.md`.

## Instalación

Descargá el framework y ejecutá el instalador:

```bash
git clone <url-del-repo> /tmp/abel-sdd
cd /tmp/abel-sdd
./install.sh /ruta/a/tu-proyecto
```

O, si ya tenés el repo local:

```bash
cd /ruta/a/abel-sdd
./install.sh /ruta/a/tu-proyecto
```

> El instalador copia `sdd/`, `scripts/`, `.claude/agents/`, `AGENTS.md`, `CLAUDE.md` e `init.sh` al proyecto destino, sin tocar su código fuente.

Luego, en el proyecto destino:

1. Completá `sdd/architecture.md` con el stack del proyecto.
2. Completá `sdd/conventions.md` con estilo, naming e idioma.
3. Opcional: creá `scripts/project-checks.sh` para agregar validaciones de tests/lint/build.
4. Corré `./init.sh` para verificar el harness.

## Uso rápido

### Crear una feature

```bash
./scripts/sdd-worktree.sh create login-y-dashboard-layout
```

Esto crea:

- Rama `feature/login-y-dashboard-layout`.
- Worktree `mi-proyecto-login-y-dashboard-layout/` junto al repo principal.
- Estructura vacía en `sdd/projects/login-y-dashboard-layout/`.

### Mover issues entre estados

```bash
./scripts/sdd-move.sh login-y-dashboard-layout login design/spec-needed design/designing
./scripts/sdd-move.sh login-y-dashboard-layout login dev/implementing dev/review
```

Esto ejecuta `git mv` y genera el commit de estado:

```text
chore(sdd): login [Design] spec-needed → designing
```

### Verificar el harness

```bash
./init.sh
```

Debe imprimir `[OK] Harness SDD listo` antes de declarar una sesión como cerrada.

## Estructura

```text
.
├── AGENTS.md              # Mapa de agentes
├── CLAUDE.md              # Prompt de orchestrator
├── init.sh                # Verifica el harness SDD
├── install.sh             # Instala el framework en un proyecto destino
├── LICENSE
├── CONTRIBUTING.md        # Guía para contribuidores
├── CHANGELOG.md           # Historial de cambios
├── .github/
│   ├── workflows/ci.yml   # CI con GitHub Actions
│   └── PULL_REQUEST_TEMPLATE.md
├── sdd/
│   ├── README.md          # Índice
│   ├── workflow.md        # Estados y flujo
│   ├── architecture.md    # Plantilla de stack
│   ├── conventions.md     # Plantilla de convenciones
│   ├── quality-gates.md   # C1–C7
│   ├── testing.md         # TDD y testing
│   ├── security.md        # Seguridad
│   ├── delivery.md        # Commits, PRs, merge
│   ├── troubleshooting.md # Guía de problemas comunes
│   ├── decisions/         # ADRs del proyecto
│   ├── templates/         # Templates de issues
│   └── projects/          # Features activas
├── scripts/
│   ├── sdd-worktree.sh    # Crea/elimina worktrees
│   └── sdd-move.sh        # Mueve issues entre estados
└── .claude/agents/        # Definiciones de roles
```

## Roles

| Rol | Qué hace | Qué NO hace |
|---|---|---|
| **Orchestrator** | Orquesta el flujo, mueve estados, cierra sesiones | Nunca edita código de producción |
| **Specifier** | Escribe specs funcionales y técnicos; entrevista al humano | No implementa código |
| **Developer** | Escribe código y tests siguiendo TDD | No salta gates ni aprueba su propio trabajo |
| **Auditor** | Audita código contra los quality gates C1–C7 | No implementa en la misma feature que revisa |
| **Humano** | Aprueba los 4 gates | No escribe código ni specs (salvo que quiera) |

## Flujo

Cada feature pasa por tres fases con gates humanos de aprobación entre ellas:

```text
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Product  │ --> │  Design  │ --> │   Dev    │
│ discovery│     │designing │     │implementing
│product-  │     │design-   │     │review ->  
│  ready   │     │  ready   │     │  testing  │
└──────────┘     └──────────┘     └──────────┘
     │                 │                 │
     └─────────────────┴─────────────────┘
              Gate humano obligatorio
```

1. **Product**: se define el problema, alcance y out-of-scope.
2. **Design**: se itera el spec funcional/UI hasta obtener aprobación.
3. **Dev**: se escribe el spec técnico, se implementa con TDD y se audita.

Ver `sdd/workflow.md` para el detalle completo de estados y transiciones.

## Licencia

MIT
