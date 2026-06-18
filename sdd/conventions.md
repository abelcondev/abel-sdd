# Conventions — Estilo, nombres y errores

> **Plantilla**. Este documento debe ser completado por cada proyecto que adopte el SDD. Define el estilo de código, naming y convenciones del proyecto.
>
> Si estás adoptando el SDD por primera vez, leé primero el **Ejemplo** y luego la sección [Cómo completar este documento](#cómo-completar-este-documento).

---

## Lenguaje y estilo

- **Lenguaje principal**: *(completar)*
- **Modo estricto / linter**: *(completar)*
- **Formateador**: *(completar)*

### Ejemplo

- **Lenguaje principal**: TypeScript 5 con modo estricto (`strict: true`).
- **Linter**: ESLint con `eslint-plugin-svelte` y `@typescript-eslint/recommended-type-checked`.
- **Formateador**: Prettier con ancho de línea de 100 caracteres.
- **Calidad mínima**: no se mergea código con errores de TypeScript ni advertencias de lint sin justificación.

---

## Naming

| Elemento | Convención | Ejemplo |
|---|---|---|
| Archivos | *(completar)* | `user-menu.ts` |
| Componentes / clases | *(completar)* | `Button` |
| Funciones | *(completar)* | `sendNotification()` |
| Constantes | *(completar)* | `MAX_RETRY_COUNT` |
| Tipos / interfaces | *(completar)* | `UserProfile` |
| Módulos de dominio | *(completar)* | `modules/sales/` |

### Ejemplo

| Elemento | Convención | Ejemplo |
|---|---|---|
| Archivos TypeScript | kebab-case | `client-form.svelte`, `client.service.ts` |
| Componentes Svelte | PascalCase | `ClientForm.svelte` |
| Clases / tipos | PascalCase | `ClientRepository`, `CreateClientInput` |
| Funciones | camelCase, verbo primero | `createClient()`, `formatCurrency()` |
| Constantes locales | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Variables booleanas | prefijo `is`/`has`/`can` | `isLoading`, `hasPermission` |
| Módulos de dominio | kebab-case, plural | `modules/clients/`, `modules/opportunities/` |
| Archivos dentro de un módulo | `<entidad>.<rol>.ts` | `client.service.ts`, `client.repository.ts`, `client.policy.ts`, `client.types.ts` |
| Tests | `<archivo>.test.ts` junto al archivo o en `tests/unit/` | `client.service.test.ts` |
| Slugs de features | kebab-case, sin tildes, minúsculas | `login-y-dashboard-layout` |

---

## Imports

Definir el orden de imports del proyecto. Ejemplo:

1. Librerías externas.
2. Alias del proyecto.
3. Imports relativos locales.

### Ejemplo

```typescript
// 1. Librerías externas
import { z } from 'zod';
import type { PageServerLoad } from './$types';

// 2. Alias del proyecto ($lib/*)
import { db } from '$lib/server/db';
import { UnauthorizedError } from '$lib/shared/errors';

// 3. Imports relativos locales (mismo módulo)
import { clientSchema } from './client.schema';
import type { Client } from './client.types';
```

Reglas adicionales:

- Usar alias (`$lib/`) en lugar de imports relativos profundos (`../../../../../`).
- Separar imports de tipos (`import type`) de imports de valores cuando sea posible.
- No importar desde `src/` directamente; usar los alias configurados.

---

## Errores

- Usar excepciones nombradas o resultados tipados. No devolver `null` para errores de dominio.
- En UI, mostrar mensajes de error en el idioma acordado por el proyecto.
- No loggear datos sensibles (PII).

### Ejemplo

Errores de dominio nombrados:

```typescript
// $lib/shared/errors.ts
export class DomainError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'DomainError';
  }
}

export class NotFoundError extends DomainError {
  constructor(resource: string, id: string) {
    super(`${resource} no encontrado: ${id}`);
    this.name = 'NotFoundError';
  }
}

export class PermissionDeniedError extends DomainError {
  constructor(action: string) {
    super(`No tenés permiso para ${action}.`);
    this.name = 'PermissionDeniedError';
  }
}
```

Uso en servicios:

```typescript
export async function getClientById(user: User, id: string): Promise<Client> {
  const client = await clientRepository.findById(id);
  if (!client) throw new NotFoundError('Client', id);
  if (!canReadClient(user, client)) throw new PermissionDeniedError('ver este cliente');
  return client;
}
```

UI:

```svelte
{#if error instanceof PermissionDeniedError}
  <Alert variant="error">{error.message}</Alert>
{:else if error instanceof NotFoundError}
  <Alert variant="error">El cliente solicitado no existe.</Alert>
{:else}
  <Alert variant="error">Ocurrió un error inesperado. Intentá de nuevo.</Alert>
{/if}
```

---

## UI y copy

- **Idioma de la UI**: *(completar)*
- **Formato de fechas, números y horas**: *(completar)*
- **Breakpoints / responsive**: *(completar)*

### Ejemplo

- **Idioma de la UI**: español neutro (sin voseo, sin modismos regionales). Los mensajes de error deben ser claros y orientados a la acción.
- **Fechas**: `dd/MM/yyyy` para formularios; `15 jun 2025` para listados; ISO 8601 (`YYYY-MM-DDTHH:mm:ssZ`) en API.
- **Moneda**: `$ 1.234,56` (ARS, punto de miles, coma decimal).
- **Breakpoints**:
  - `sm`: 640px
  - `md`: 768px
  - `lg`: 1024px
  - `xl`: 1280px
- **Tono**: directo, sin exclamaciones excesivas, sin culpar al usuario. Ejemplo:
  - ✅ "Ingresá un correo electrónico válido."
  - ❌ "¡Oops! Parece que olvidaste tu email."

---

## Referencias

- Para estrategia de testing y TDD: `sdd/testing.md`.
- Para seguridad, RBAC y PII: `sdd/security.md`.
- Para quality gates y Definition of Done: `sdd/quality-gates.md`.

---

## Cómo completar este documento

1. Reemplazá los campos "*(completar)*" de **Lenguaje y estilo** con las herramientas reales del proyecto.
2. Adaptá la tabla de **Naming** a tu stack y convenciones existentes.
3. Definí el orden de **Imports** y los alias que usa el proyecto.
4. Elegí una estrategia de **Errores** (excepciones, resultados tipados, o ambas) y documentala con ejemplos.
5. Completá **UI y copy** con idioma, formatos y breakpoints reales.
6. Eliminá las secciones marcadas como **Ejemplo** cuando el documento esté maduro, o conservalas como referencia mientras el equipo adopta el SDD.
