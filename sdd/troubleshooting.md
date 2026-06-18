# SDD — Troubleshooting

Guía de problemas comunes al usar el framework SDD y sus scripts.

---

## Worktree

### `El worktree para '<slug>' ya existe`

**Causa**: Ya existe un directorio de worktree o una rama `feature/<slug>`.

**Solución**:

```bash
# Verificar worktrees existentes
./scripts/sdd-worktree.sh list

# Si la feature ya terminó o se abandonó, eliminarla
./scripts/sdd-worktree.sh remove <slug>

# Luego crear la nueva feature
./scripts/sdd-worktree.sh create <slug>
```

Si el directorio quedó residual por un error previo:

```bash
git worktree prune
rm -rf <repo-principal>-<slug>
git branch -D feature/<slug>
```

### `No se pudo eliminar con git worktree remove`

**Causa**: El worktree tiene procesos abiertos, archivos bloqueados o cambios no commiteados.

**Solución**:

1. Cerrar editores/terminales que usen el directorio.
2. Desde el repo principal:
   ```bash
   ./scripts/sdd-worktree.sh remove <slug>
   ```
   El script intenta eliminación forzada y limpia residuales.
3. Si persiste:
   ```bash
   git worktree remove --force <ruta-del-worktree>
   git worktree prune
   rm -rf <ruta-del-worktree>
   git branch -D feature/<slug>
   ```

---

## Slug inválido

### `Slug inválido. Usá kebab-case en minúsculas`

**Causa**: El slug contiene mayúsculas, tildes, espacios, guiones bajos o caracteres especiales.

**Solución**: Usar solo minúsculas, números y guiones. Ejemplos válidos:

- `login-y-dashboard-layout`
- `mejoras-framework-sdd`
- `reporte-de-ventas-v2`

Ejemplos inválidos:

- `LoginYDashboard` → `login-y-dashboard-layout`
- `mejoras_framework` → `mejoras-framework`
- `reporte de ventas` → `reporte-de-ventas`

---

## Mover issues entre estados

### `Estado destino inválido: '...'`

**Causa**: El estado destino no está en la lista válida para [Design] o [Dev], o se intentó cambiar de tipo.

**Solución**: Revisar `sdd/workflow.md` y usar estados válidos:

- [Design]: `design/spec-needed`, `design/designing`, `design/design-ready`
- [Dev]: `dev/backlog`, `dev/spec-needed`, `dev/spec-ready`, `dev/implementing`, `dev/blocked`, `dev/review`, `dev/rejected`, `dev/testing`, `dev/done`, `dev/cancelled`

Ejemplo correcto:

```bash
./scripts/sdd-move.sh login-y-dashboard-layout login design/spec-needed design/designing
./scripts/sdd-move.sh login-y-dashboard-layout login dev/implementing dev/review
```

### `No existe sdd/projects/<slug>/<estado>/<issue>.md`

**Causa**: La Issue no está en el estado origen indicado.

**Solución**: Verificar el estado actual con `git status` o listando la carpeta:

```bash
ls sdd/projects/<slug>/dev/*/
```

### `Ya existe sdd/projects/<slug>/<estado>/<issue>.md`

**Causa**: Ya hay un archivo con el mismo nombre en el estado destino.

**Solución**: Revisar si el movimiento ya se hizo o si hay una issue duplicada. No sobrescribir sin confirmar.

---

## `init.sh` falla

### `[FAIL] <project> no tiene ninguna Issue [Design]` / `[Dev]`

**Causa**: El project no cumple el requisito mínimo de tener al menos una Issue de cada tipo.

**Solución**: Crear los archivos correspondientes en:

- `sdd/projects/<slug>/design/spec-needed/<issue>.md`
- `sdd/projects/<slug>/dev/backlog/<issue>.md`

### `[FAIL] Hay N Issues [Dev] en implementing/ o review/`

**Causa**: Hay más de una Issue [Dev] en `dev/implementing/` o `dev/review/` simultáneamente.

**Solución**: Terminar o pausar una de las issues. Opciones:

- Mover la que no esté activa a `dev/blocked/`.
- Finalizar el review de una antes de empezar otra.

### `[FAIL] <project>/design/<carpeta> no es un estado válido`

**Causa**: Existe una carpeta dentro de `design/` o `dev/` que no está en la lista de estados válidos.

**Solución**: Renombrar o eliminar la carpeta. Ver estados válidos en `sdd/workflow.md`.

### `[FAIL] <project>/design/ contiene archivos .md fuera de una carpeta de estado`

**Causa**: Hay archivos Markdown directamente en `design/` o `dev/`, en lugar de dentro de una subcarpeta de estado.

**Solución**: Mover el archivo a la carpeta de estado correspondiente.

---

## Instalación

### `El directorio destino no es un repositorio Git`

**Causa**: Se ejecutó `install.sh` sobre un directorio que no es un repo Git.

**Solución**: Inicializar Git en el proyecto destino antes de instalar el SDD:

```bash
cd /ruta/a/tu-proyecto
git init
git commit --allow-empty -m "init"
```

Luego volver a correr `./install.sh`.

### Se sobrescribieron `AGENTS.md` o `CLAUDE.md` sin querer

**Causa**: Se corrió `./install.sh` sin `--update` y se confirmó la sobrescritura, o se usó `--update` sin revisar backups.

**Solución**: El modo `--update` crea backups con timestamp:

```bash
ls -la <destino>/AGENTS.md.backup-*
ls -la <destino>/CLAUDE.md.backup-*
```

Restaurar el backup deseado:

```bash
cp <destino>/AGENTS.md.backup-<timestamp> <destino>/AGENTS.md
cp <destino>/CLAUDE.md.backup-<timestamp> <destino>/CLAUDE.md
```

---

## Commits y git

### Cambios de estado no aparecen en `git log`

**Causa**: El movimiento se hizo con `mv` manual sin commit.

**Solución**: Usar siempre `./scripts/sdd-move.sh`, que genera el commit automáticamente. Si ya se movió manualmente:

```bash
git add sdd/projects/<slug>/
git commit -m "chore(sdd): <issue> [Dev|Design] <origen> → <destino>"
```

---

## Referencias

- Workflow y estados: `sdd/workflow.md`
- Scripts: `scripts/sdd-worktree.sh`, `scripts/sdd-move.sh`, `install.sh`
- Verificación: `init.sh`
