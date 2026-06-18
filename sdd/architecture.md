# Architecture — Qué significa "buen trabajo"

> **Plantilla**. Este documento debe ser completado por cada proyecto que adopte el SDD. Define el stack, las capas y los estándares de calidad arquitectónica.

## Stack y capas

Completar con las decisiones del proyecto:

- **Framework**: *(ej. SvelteKit, Next.js, Django, Rails, etc.)*
- **Lenguaje**: *(ej. TypeScript, Python, Ruby, Go, etc.)*
- **Base de datos**: *(ej. PostgreSQL, SQLite, InstantDB, etc.)*
- **Autenticación**: *(ej. OAuth, OTP, JWT, sesiones, etc.)*
- **Componentes UI / estilos**: *(ej. Tailwind, Material UI, CSS modules, etc.)*
- **Package manager**: *(ej. bun, npm, pnpm, poetry, etc.)*
- **Herramienta de diseño visual**: *(ej. Figma, Pencil, Sketch, etc.)*

## Organización del código

Describir la estructura de carpetas del proyecto. Ejemplo:

```text
src/
├── lib/              # Código compartido
├── modules/          # Módulos de dominio
├── routes/           # Rutas o endpoints
└── app/              # Configuración y entry points
```

## Reglas de oro del proyecto

Definir las reglas no negociables del proyecto. Ejemplos:

1. Tipado explícito en APIs públicas.
2. Sin eliminaciones físicas en entidades de negocio; usar estados terminales.
3. RBAC en todas las rutas y funciones sensibles.
4. Audit trail en mutaciones críticas.
5. Toda la UI visible en el idioma acordado por el proyecto.

## Data flow típico

Describir el flujo de datos típico del sistema.

```text
Usuario → Route/Controller → Módulo de dominio → Persistencia
                  ↓
            Audit trail (si es crítico)
```

## Decisiones arquitectónicas vigentes

Ver `sdd/decisions/` para los ADRs. Este documento solo resume las decisiones activas.
