# Quality Gates — Definition of Ready / Done

La regla de oro: **executable evidence, not claims**.

Todo trabajo se demuestra con evidencia ejecutable, no con afirmaciones.

---

## 1. Definition of Ready (DoR)

Una Issue `[Dev]` está lista para pasar de `dev/spec-ready/` a `dev/implementing/` cuando:

- [ ] La Issue `[Design]` correspondiente está en `design/design-ready/`.
- [ ] El spec técnico está completo (ver `templates/issue-dev.md`).
- [ ] Las decisiones técnicas `D<n>` incluyen alternativas descartadas.
- [ ] El **Test Plan** cubre cada `R<n>` de la Issue `[Design]`.
- [ ] El **Impact Analysis** identifica módulos afectados.
- [ ] El checklist de seguridad está completado si aplica.
- [ ] No hay dependencias sin resolver.

---

## 2. Definition of Done (DoD)

Una Issue `[Dev]` está lista para pasar de `dev/review/` a `dev/testing/` cuando:

- [ ] Todos los `R<n>` están implementados y testeados.
- [ ] `init.sh` pasa en el worktree.
- [ ] Cobertura mínima alcanzada según `sdd/testing.md`.
- [ ] Trazabilidad `R<n>` → test documentada.
- [ ] No hay logs de debug ni código muerto.
- [ ] La UI implementada coincide con el diseño aprobado y `[Design]`.
- [ ] El `reviewer` emitió veredicto ✅.
- [ ] El humano aprobó el merge.

---

## 3. Quality gates obligatorios

Antes de declarar `done`, `init.sh` debe pasar. El proyecto define en `init.sh` o en su toolchain qué comandos ejecutar. Ejemplo típico:

```bash
<test-runner> --coverage    # tests con cobertura
<type-check>                # typecheck
<linter>                    # lint
<audit>                     # vulnerabilidades de dependencias
<build>                     # build
```

> El proyecto completa `sdd/architecture.md` y `sdd/conventions.md` con las herramientas concretas.

---

## 4. Niveles de verificación

### 4.1 Tests unitarios

- Happy path de cada función pública.
- Al menos un caso de error por función pública.
- Sin mocks innecesarios del filesystem ni de la red.

### 4.2 Tests de integración

- Flujos entre módulos.
- Interacción con persistencia y auth.
- Validación de RBAC.

### 4.3 Build y quality gates

Verificados por `init.sh` (ver sección 3).

### 4.4 Trazabilidad de requisitos

Cada `R<n>` de la Issue `[Design]` debe mapearse a al menos un test concreto.

Ejemplo de documentación en la sección `## Review`:

```markdown
| Requisito | Test file | Línea | Estado |
|-----------|-----------|-------|--------|
| R1 | tests/unit/clientes/crear.test.ts | 23 | ✅ |
| R2 | — | — | ❌ FALTA |
```

---

## 5. Checklist de cierre (C1–C7)

El `reviewer` verifica cada ítem antes de aprobar el paso de una Issue a `done`.

### C1 — Harness completo

- [ ] `AGENTS.md` existe.
- [ ] `CLAUDE.md` existe y fuerza el rol leader.
- [ ] `sdd/README.md` existe.
- [ ] `sdd/workflow.md` existe.
- [ ] `sdd/architecture.md` existe y está completado.
- [ ] `sdd/conventions.md` existe y está completado.
- [ ] `sdd/quality-gates.md` existe.
- [ ] `sdd/testing.md` existe.
- [ ] `sdd/security.md` existe.
- [ ] `sdd/delivery.md` existe.
- [ ] `.claude/agents/` tiene `leader.md`, `spec_author.md`, `implementer.md`, `reviewer.md`.
- [ ] `init.sh` existe y es ejecutable.
- [ ] `sdd/projects/` existe y tiene al menos un project.

### C2 — Coherencia de estado

- [ ] Máximo una Issue `[Dev]` en estado `implementing/` o `review/`.
- [ ] El Project contiene al menos una Issue `[Design]` y una Issue `[Dev]`.
- [ ] La Issue `[Dev]` está en `dev/backlog/` hasta que `[Design]` esté en `design/design-ready/`.
- [ ] Todos los estados en `sdd/projects/` son carpetas válidas según `sdd/workflow.md`.
- [ ] Si una Issue `[Design]` está en `design/designing/` o más allá, su descripción contiene un spec funcional + UI/UX completo.
- [ ] Si una Issue `[Design]` está en `design/design-ready/`, su descripción contiene la sección `UI/UX Design` completa y assets del diseño.
- [ ] Si una Issue `[Dev]` está en `dev/spec-ready/` o más allá, su descripción contiene un spec técnico completo.
- [ ] Si una Issue `[Dev]` está en `dev/implementing/` o más allá, existe el worktree en `<repo-principal>-<project>/`.

### C3 — Cumplimiento arquitectónico

- [ ] Nuevo código respeta el stack y convenciones definidos en `sdd/architecture.md` y `sdd/conventions.md`.
- [ ] No hay tipado/estilo que contradiga las convenciones del proyecto.
- [ ] No hay librerías duplicadas en funcionalidad.
- [ ] No hay logs de debug ni código muerto.
- [ ] Todos los textos de UI están en el idioma acordado.
- [ ] RBAC respetado en rutas y componentes nuevos.
- [ ] Sin eliminaciones físicas en entidades de negocio: se usan estados terminales.
- [ ] Audit trail presente en mutaciones críticas.
- [ ] La UI implementada coincide con el diseño aprobado y la Issue `[Design]`.

### C4 — Verificación real

- [ ] El test runner del proyecto pasa sin errores.
- [ ] El type checker del proyecto pasa sin errores.
- [ ] El linter del proyecto pasa sin advertencias.
- [ ] El build del proyecto pasa sin errores.
- [ ] El audit de dependencias no reporta vulnerabilidades críticas.
- [ ] Cada requisito `R<n>` tiene al menos un test que lo valida.

> El proyecto define en `sdd/architecture.md` / `sdd/conventions.md` qué comandos concretos usar.

### C5 — Cierre limpio de sesión

- [ ] `init.sh` imprime el mensaje de éxito configurado.
- [ ] No hay archivos untracked sospechosos.
- [ ] Si se cerró una Issue `[Dev]`, su archivo está en `dev/done/`.
- [ ] Si se cerró una Issue `[Design]`, su archivo está en `design/design-ready/`.
- [ ] Si se cerró una Issue `[Dev]`, el worktree fue eliminado.
- [ ] Se actualizó `sdd/README.md` con el estado actual de projects.

### C6 — Cumplimiento SDD

- [ ] La Issue `[Design]` pasó por `design/spec-needed/` → `design/designing/` → `design/design-ready/`.
- [ ] La Issue `[Dev]` pasó por `dev/spec-needed/` → `dev/spec-ready/` → `dev/implementing/` antes de tocar código de producción.
- [ ] El gate humano entre `spec-needed/` y `designing/` fue respetado.
- [ ] El gate humano entre `designing/` y `design-ready/` fue respetado.
- [ ] El gate humano entre `spec-ready/` e `implementing/` fue respetado.
- [ ] La descripción de cada Issue usa el template de `sdd/workflow.md`.

### C7 — Seguridad

- [ ] RBAC validado en tests.
- [ ] Inputs sanitizados y validados.
- [ ] No se loggea PII.
- [ ] Audit trail presente en mutaciones críticas.
- [ ] Audit de dependencias sin vulnerabilidades críticas.
- [ ] No hard deletes en entidades de negocio.
- [ ] Secrets fuera del código.

Si **cualquier** checkbox de C1–C7 queda vacío, el veredicto es **❌ Rechazado** con accionables claros.

---

## 6. Anti-patrones generales

- "Debería funcionar" sin test ejecutable.
- Test que solo verifica que no explota.
- Mocking excesivo del filesystem o de la red.
- Marcar `done` sin `init.sh` verde.
- Mergear sin aprobación del reviewer y del humano.
- Mover una Issue `[Dev]` a `implementing/` sin que `[Design]` esté en `design/design-ready/`.
- Modificar componentes base existentes sin aprobación previa.
