# Delivery — Commits, PRs, merge y cierre

Este documento define cómo se entrega el trabajo: commits, pull requests, merge y cierre limpio.

---

## 1. Commits

### Formato: Conventional Commits

```text
<tipo>(<scope>): <descripción breve> — <project>/<issue>
```

Ejemplos:

```text
feat(reservas): agregar validación de cliente — login-y-dashboard-layout/reservas
test(reservas): R2 validar cliente obligatorio — login-y-dashboard-layout/reservas
fix(auth): corregir redirección post-login — login-y-dashboard-layout/login
refactor(shell): simplificar layout de admin — login-y-dashboard-layout/dashboard
chore(sdd): login [Design] spec-needed → designing
```

### Tipos comunes

| Tipo | Uso |
|---|---|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `test` | Tests (TDD: commit rojo) |
| `refactor` | Cambio interno sin cambiar comportamiento |
| `chore` | Tareas de mantenimiento, cambios de estado SDD |
| `docs` | Documentación |
| `style` | Formato, sin cambio lógico |

### Commits de estado SDD

Cuando el `leader` mueve una issue entre carpetas:

```text
chore(sdd): login [Design] spec-needed → designing
chore(sdd): reservas [Dev] implementing → review
```

### Commits TDD

En TDD, cada `R<n>` genera al menos dos commits:

```text
test(<scope>): R<n> <comportamiento esperado> — <project>/<issue>
feat(<scope>): R<n> <implementación mínima> — <project>/<issue>
```

Opcionalmente un tercero:

```text
refactor(<scope>): R<n> <mejora interna> — <project>/<issue>
```

### Reglas

- Commits pequeños y atómicos.
- Cada commit debe pasar los checks del proyecto (lint, typecheck, tests rápidos según lo definido en `sdd/architecture.md`).
- Referenciar siempre el project/issue.
- No incluir `Co-Authored-By` de asistentes de IA. El usuario es el único autor.

---

## 2. Pull Requests

### Creación

Cuando el `implementer` termina y la Issue `[Dev]` está en `dev/review/`, el `leader` puede crear el PR:

```bash
cd <repo-principal>-<project>
gh pr create \
  --title "<project>/<issue>: título del cambio" \
  --body "Closes <project>/<issue>" \
  --base main
```

> El proyecto puede usar otro forge/host; adaptar el comando.

### Body sugerido

```markdown
## Resumen
Breve descripción del cambio.

## Trazabilidad
| Requisito | Test file | Estado |
|-----------|-----------|--------|
| R1 | tests/integration/... | ✅ |
| R2 | tests/unit/... | ✅ |

## Checklist
- [ ] `init.sh` pasa en el worktree.
- [ ] Cobertura mínima alcanzada.
- [ ] No se agregaron dependencias sin justificar.

Closes <project>/<issue>
```

---

## 3. Merge

El merge **NO es automático**. Requiere:

1. Veredicto ✅ del `reviewer`.
2. Aprobación explícita del humano (gate humano 4).
3. `init.sh` verde en el worktree.
4. Audit de dependencias sin vulnerabilidades críticas (para features críticas).

Solo entonces el `leader` mergea el PR y mueve el archivo de la Issue a `dev/done/`.

---

## 4. Cierre de Issue `[Dev]`

Cuando una Issue `[Dev]` llega a `dev/done/`, el `leader`:

1. Elimina el worktree:
   ```bash
   ./scripts/sdd-worktree.sh remove <project>
   ```
2. Actualiza `sdd/README.md` con el estado actual de projects.
3. Agrega una sección `## Cierre` al final del archivo de la Issue `[Dev]`:
   ```markdown
   ## Cierre

   - **Resultado**: feature mergeada a `main`.
   - **Decisiones relevantes**: resumen de `D<n>` que impactaron arquitectura.
   - **Próximos pasos**: issues derivadas o deuda técnica.
   ```
4. Documenta cualquier decisión o patrón relevante en `sdd/decisions/`.

---

## 5. Cierre de sesión

Antes de declarar una sesión cerrada:

1. Correr `init.sh`. Debe imprimir el mensaje de éxito configurado.
2. Si se terminó una Issue `[Dev]`, asegurar que su archivo esté en `dev/done/`.
3. Si se cerró una Issue `[Design]`, asegurar que su archivo esté en `design/design-ready/`.
4. Actualizar `sdd/README.md` con el estado actual de projects.
5. Documentar decisiones, convenciones o descubrimientos relevantes.
6. Asegurar que no haya archivos untracked sospechosos.

---

## 6. Anti-patrones de delivery

- Mergear sin aprobación del reviewer y del humano.
- Marcar `done` sin `init.sh` verde.
- Commits gigantes que mezclan múltiples features.
- PRs sin descripción ni trazabilidad.
- Dejar worktrees huérfanos después de mergear.
