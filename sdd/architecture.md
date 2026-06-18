# Architecture — Qué significa "buen trabajo"

> **Plantilla**. Este documento debe ser completado por cada proyecto que adopte el SDD. Define el stack, las capas y los estándares de calidad arquitectónica.
>
> Si estás adoptando el SDD por primera vez, leé primero el **Ejemplo** y luego la sección [Cómo completar este documento](#cómo-completar-este-documento).

---

## Stack y capas

Completar con las decisiones del proyecto:

- **Framework**: *(ej. SvelteKit, Next.js, Django, Rails, etc.)*
- **Lenguaje**: *(ej. TypeScript, Python, Ruby, Go, etc.)*
- **Base de datos**: *(ej. PostgreSQL, SQLite, InstantDB, etc.)*
- **Autenticación**: *(ej. OAuth, OTP, JWT, sesiones, etc.)*
- **Componentes UI / estilos**: *(ej. Tailwind, Material UI, CSS modules, etc.)*
- **Package manager**: *(ej. bun, npm, pnpm, poetry, etc.)*
- **Herramienta de diseño visual**: *(ej. Figma, Pencil, Sketch, etc.)*

### Ejemplo

> Proyecto: **Acme CRM** — SaaS multi-tenant para gestión de clientes y ventas.

| Capa | Tecnología | Responsabilidad |
|---|---|---|
| Frontend | SvelteKit 5 + TypeScript 5 | Renderizado de páginas, interacción de usuario, llamadas a API |
| Estilos | Tailwind CSS 4 + CSS variables | Diseño responsive, tokens de color/tipografía |
| Backend/API | SvelteKit endpoints (`+server.ts`) + servicios de dominio | Lógica de negocio, validación, autorización |
| Base de datos | PostgreSQL 16 + Prisma ORM | Persistencia relacional, migraciones controladas |
| Auth | Lucia (sesiones) + OAuth2 Google/SSO | Identidad, sesiones, RBAC básico |
| Colas/async | Inngest | Jobs reportados, notificaciones, integraciones |
| Almacenamiento | S3-compatible | Adjuntos de clientes, exports CSV |
| Diseño | Figma | Prototipos, artboards, componentes visuales |

---

## Organización del código

Describir la estructura de carpetas del proyecto. Ejemplo:

```text
src/
├── lib/              # Código compartido
├── modules/          # Módulos de dominio
├── routes/           # Rutas o endpoints
└── app/              # Configuración y entry points
```

### Ejemplo

```text
src/
├── app.html                      # Plantilla HTML base
├── app.d.ts                      # Tipos globales de la app
├── routes/                       # Rutas de SvelteKit
│   ├── (app)/                    # Layout autenticado
│   │   ├── dashboard/
│   │   ├── clients/
│   │   └── +layout.server.ts     # Carga de sesión y permisos
│   └── (auth)/                   # Layout público
│       ├── login/
│       └── register/
├── lib/
│   ├── server/                   # Solo backend
│   │   ├── auth/                 # Sesiones, hashing, RBAC
│   │   ├── db/                   # Cliente Prisma, esquemas
│   │   ├── modules/              # Módulos de dominio
│   │   │   ├── clients/
│   │   │   │   ├── client.service.ts
│   │   │   │   ├── client.repository.ts
│   │   │   │   ├── client.types.ts
│   │   │   │   └── client.policy.ts
│   │   │   └── opportunities/
│   │   └── jobs/                 # Jobs async (Inngest)
│   └── shared/                   # Código usado por frontend y backend
│       ├── schemas/              # Zod schemas compartidos
│       ├── errors/               # Errores de dominio nombrados
│       └── utils/                # Helpers puros
├── styles/                       # Variables, reset, utilidades extra
└── tests/                        # Tests unitarios e integración
    ├── unit/
    └── integration/
```

---

## Reglas de oro del proyecto

Definir las reglas no negociables del proyecto. Ejemplos:

1. Tipado explícito en APIs públicas.
2. Sin eliminaciones físicas en entidades de negocio; usar estados terminales.
3. RBAC en todas las rutas y funciones sensibles.
4. Audit trail en mutaciones críticas.
5. Toda la UI visible en el idioma acordado por el proyecto.

### Ejemplo

1. **Todas las APIs públicas usan Zod** para validar entradas antes de tocar lógica de negocio.
2. **No hard deletes** en entidades de negocio (`Client`, `Opportunity`, `Invoice`). Se usan estados terminales (`ARCHIVED`, `CANCELLED`).
3. **RBAC en cada ruta y función**: `requirePermission(user, 'clients:write')` antes de mutar.
4. **Audit trail** en todas las mutaciones críticas: quién, qué, cuándo, valores anteriores y nuevos.
5. **Idioma de la UI**: español neutro (configurado en `sdd/conventions.md`).
6. **Datos sensibles (PII) nunca se loggean** ni se exponen en respuestas de error.
7. **Cada feature nueva vive en su propio worktree** desde el inicio, siguiendo `sdd/workflow.md`.

---

## Data flow típico

Describir el flujo de datos típico del sistema.

```text
Usuario → Route/Controller → Módulo de dominio → Persistencia
                  ↓
            Audit trail (si es crítico)
```

### Ejemplo: Crear un cliente

```text
Usuario (formulario) ──POST /api/clients──► +server.ts
                                              │
                                              ▼
                                       Zod schema valida input
                                              │
                                              ▼
                                       client.service.create()
                                              │
                                              ├──► client.policy.assertCanCreate(user)
                                              │
                                              ├──► client.repository.insert(data)
                                              │
                                              └──► audit.log('client.created', before, after)
                                              │
                                              ▼
                                       Respuesta JSON { id, ... }
```

Flujo de lectura:

```text
Usuario ──GET /clients/[id]──► +page.server.ts
                                  │
                                  ▼
                           client.service.getById(id)
                                  │
                                  ├──► client.policy.assertCanRead(user, client)
                                  │
                                  └──► client.repository.findById(id)
                                  │
                                  ▼
                           Renderizado en SvelteKit
```

---

## Decisiones arquitectónicas vigentes

Ver `sdd/decisions/` para los ADRs. Este documento solo resume las decisiones activas.

### Ejemplo

| Decisión | Estado | ADR |
|---|---|---|
| Uso de worktrees por feature | Activa | `sdd/decisions/0001-uso-de-worktrees-por-feature.md` |
| Markdown como fuente de verdad | Activa | `sdd/decisions/0002-markdown-como-fuente-de-verdad.md` |
| SvelteKit como full-stack framework | Activa | `sdd/decisions/0003-sveltekit-fullstack.md` *(crear si aplica)* |
| PostgreSQL + Prisma como persistencia | Activa | `sdd/decisions/0004-postgres-prisma.md` *(crear si aplica)* |

---

## Cómo completar este documento

1. Reemplazá los campos "*(ej. ...)*" de la sección **Stack y capas** con las tecnologías reales del proyecto.
2. Adaptá la estructura de carpetas de **Organización del código** a tu stack.
3. Escribí al menos 5 **reglas de oro** no negociables para tu equipo.
4. Dibujá el **data flow** de una operación representativa (lectura y escritura).
5. Actualizá la tabla de **Decisiones arquitectónicas vigentes** con ADRs reales en `sdd/decisions/`.
6. Eliminá las secciones marcadas como **Ejemplo** cuando el documento esté maduro, o conservalas como referencia mientras el equipo adopta el SDD.
