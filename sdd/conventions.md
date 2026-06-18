# Conventions — Estilo, nombres y errores

> **Plantilla**. Este documento debe ser completado por cada proyecto que adopte el SDD. Define el estilo de código, naming y convenciones del proyecto.

## Lenguaje y estilo

- **Lenguaje principal**: *(completar)*
- **Modo estricto / linter**: *(completar)*
- **Formateador**: *(completar)*

## Naming

| Elemento | Convención | Ejemplo |
|---|---|---|
| Archivos | *(completar)* | `user-menu.ts` |
| Componentes / clases | *(completar)* | `Button` |
| Funciones | *(completar)* | `sendNotification()` |
| Constantes | *(completar)* | `MAX_RETRY_COUNT` |
| Tipos / interfaces | *(completar)* | `UserProfile` |
| Módulos de dominio | *(completar)* | `modules/sales/` |

## Imports

Definir el orden de imports del proyecto. Ejemplo:

1. Librerías externas.
2. Alias del proyecto.
3. Imports relativos locales.

## Errores

- Usar excepciones nombradas o resultados tipados. No devolver `null` para errores de dominio.
- En UI, mostrar mensajes de error en el idioma acordado por el proyecto.
- No loggear datos sensibles (PII).

## UI y copy

- **Idioma de la UI**: *(completar)*
- **Formato de fechas, números y horas**: *(completar)*
- **Breakpoints / responsive**: *(completar)*

## Referencias

- Para estrategia de testing y TDD: `sdd/testing.md`.
- Para seguridad, RBAC y PII: `sdd/security.md`.
- Para quality gates y Definition of Done: `sdd/quality-gates.md`.
