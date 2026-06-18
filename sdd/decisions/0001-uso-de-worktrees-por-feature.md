# ADR-0001: Uso de worktrees por feature

- **Estado**: aprobada
- **Fecha**: 2026-06-18
- **Decisores**: equipo SDD

## Contexto

El framework SDD necesita aislar el trabajo de cada feature desde su concepción hasta su merge. Tradicionalmente los desarrolladores crean una rama local dentro del mismo repositorio y alternan entre features, lo que genera:

- Cambios accidentales en archivos de otra feature.
- Dependencias circulantes o estados intermedios que rompen `main`.
- Dificultad para correr validaciones locales sin contaminar el entorno de otras tareas.
- Revisión confusa porque el diff incluye archivos ajenos.

Necesitábamos un mecanismo que mantuviera cada feature en su propio espacio de trabajo sin perder la relación con `main` ni con el historial de Git.

## Decisión

Cada feature vive en su propio **worktree de Git** desde el inicio:

- El worktree se crea como directorio hermano del repo principal: `<repo-principal>-<feature-slug>/`.
- Se asocia a una rama `feature/<feature-slug>`.
- Dentro del worktree se escriben specs, diseño, código y se ejecutan validaciones.
- Al finalizar, el worktree se mergea a `main` y se elimina.

La creación y eliminación se automatizan con `scripts/sdd-worktree.sh`.

## Consecuencias

### Positivas

- Aislamiento completo del código y los specs de cada feature.
- Posibilidad de tener múltiples features en paralelo sin conflictos de workspace.
- El estado del repo principal permanece limpio mientras la feature avanza.
- Facilita la ejecución local de `init.sh` y checks del proyecto por feature.

### Negativas / trade-offs

- Requiere entender el concepto de worktree de Git.
- Ocupa más espacio en disco que una simple rama local.
- Los paths absolutos en scripts o configuración pueden variar entre worktree y repo principal.

## Alternativas descartadas

| Alternativa | Por qué no se eligió |
|---|---|
| Rama local dentro del mismo directorio | No aísla el workspace; el desarrollador puede modificar accidentalmente archivos de otra feature. |
| Directorio temporal fuera de Git | Pierde trazabilidad, diff y commits incrementales; obliga a copiar manualmente al final. |
| Monorepo con paquetes por feature | Añade complejidad innecesaria para equipos pequeños y medios; no resuelve el aislamiento de specs. |

## Referencias

- `sdd/workflow.md` — workflow y estados del SDD.
- `scripts/sdd-worktree.sh` — gestor de worktrees.
