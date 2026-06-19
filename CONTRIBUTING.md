# Contribuir a abel-sdd

¡Gracias por interesarte en mejorar el framework! Seguimos un flujo ligero basado en issues y pull requests.

## Cómo proponer cambios

1. **Abrí un issue** (o usá el flujo SDD local con `sdd/projects/`) describiendo el problema o mejora.
2. **Forká el repo** o creá una rama/feature con `scripts/sdd-worktree.sh` si tenés permisos.
3. **Hacé tus cambios** de forma atómica y documentada.
4. **Abrí un Pull Request** usando el template que aparece automáticamente.
5. **Asegurate de que el CI pase** antes de pedir review.

## Cómo correr `./init.sh` localmente

Antes de enviar un PR, verificá que el harness SDD esté listo:

```bash
./init.sh
```

Si todo está bien, verás:

```text
[OK] Harness SDD listo
```

Si falla, corregí los errores reportados y volvé a ejecutarlo.

## Convención de commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

- `docs(<scope>): ...` — cambios en documentación.
- `chore(<scope>): ...` — tareas de mantenimiento, estado del SDD, scripts, etc.
- `feat(<scope>): ...` — nueva funcionalidad.
- `fix(<scope>): ...` — corrección de errores.
- `test(<scope>): ...` — tests.
- `refactor(<scope>): ...` — refactor sin cambios de comportamiento.

Para cambios relacionados con el flujo SDD local usamos el scope `sdd`:

```text
chore(sdd): mover login [Dev] implementing → review
docs(readme): agregar badge de CI — kit-repo-publico/kit-repo-publico
```

Mantené los commits atómicos y con mensajes claros en español (idioma principal del proyecto).
