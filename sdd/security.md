# Security — Seguridad en el SDD

La seguridad no es un paso extra: es una dimensión que se revisa en cada feature.

---

## 1. Principios

1. **Mínimo privilegio**: un rol solo accede a lo que necesita.
2. **Defensa en profundidad**: validar en cliente, servidor y base de datos.
3. **Datos sensibles por defecto**: asumir que cualquier dato puede ser sensible hasta demostrar lo contrario.
4. **No hard deletes**: las entidades de negocio usan estados terminales (`cancelado`, `anulado`, `inactivo`).
5. **Audit trail**: toda mutación crítica registra quién, cuándo y qué cambió.

---

## 2. Checklist de seguridad por feature

Toda Issue `[Dev]` debe considerar estos ítems. Si aplica, debe documentarse en el spec técnico.

### Auth y permisos

- [ ] ¿La ruta o función verifica autenticación?
- [ ] ¿Se valida el rol del usuario antes de ejecutar la acción?
- [ ] ¿Un usuario puede ver/modificar datos de otro usuario?
- [ ] ¿Las acciones críticas requieren rol explícito (no "cualquier usuario logueado")?

### Datos

- [ ] ¿Se sanitizan inputs del usuario?
- [ ] ¿Se validan tipos y rangos en el servidor/edge?
- [ ] ¿No se loggea PII (documentos de identidad, datos de pago, emails, teléfonos)?
- [ ] ¿Los errores no filtran información interna (stack traces, IDs de DB)?

### Dependencias

- [ ] ¿Se corrió el audit de dependencias antes de mergear?
- [ ] ¿Las nuevas dependencias son necesarias y mantenidas?
- [ ] ¿No se agregan librerías duplicadas en funcionalidad?

### Infraestructura

- [ ] ¿Los secrets solo viven en variables de entorno y nunca en el código?
- [ ] ¿El archivo de entorno del worktree no se commitea?
- [ ] ¿No hay endpoints expuestos sin autorización?

---

## 3. Gates de seguridad por riesgo

### Features críticas

Las features que tocan **pagos, auth, datos personales u operaciones financieras** tienen gates adicionales:

- Cobertura de tests del 100% en flujos críticos.
- Review de seguridad explícito en el checklist.
- Audit trail obligatorio.
- No se mergean sin aprobación humana adicional.

### Features estándar

- Checklist de seguridad completado en el spec técnico.
- Audit de dependencias sin vulnerabilidades críticas.
- RBAC verificado en tests de integración.

---

## 4. PII y datos sensibles

### Qué se considera PII

- Nombres completos.
- Documentos de identidad / pasaportes.
- Datos de pago (tarjetas, cuentas).
- Emails y teléfonos (en contextos que permitan identificación).
- Cualquier otro dato que el proyecto defina como sensible.

### Reglas

- No loggear PII en consola ni en servicios de terceros.
- No exponer PII en URLs ni en respuestas de API sin necesidad.
- Implementar eliminación lógica, no física, salvo requerimiento legal explícito.
- Respetar derechos de acceso, rectificación y cancelación.

---

## 5. RBAC

Cada proyecto define sus roles en `sdd/architecture.md`. Cada feature debe documentar:

```markdown
## Permisos

| Acción | Admin | Operator | Viewer |
|---|---|---|---|
| Crear recurso | ✅ | ✅ | ❌ |
| Ver todos los recursos | ✅ | ❌ | ❌ |
| Ver mis recursos | ✅ | ✅ | ✅ |
```

Y cada test de integración debe validar al menos un caso de acceso denegado.

---

## 6. Dependencias y vulnerabilidades

### Antes de agregar una dependencia

1. Justificarla en una `D<n>` del spec técnico.
2. Verificar que no duplique funcionalidad existente.
3. Revisar fecha de último release, issues abiertos y licencia.

### Antes de mergear

```bash
<audit-de-dependencias>
```

> El proyecto completa con su package manager.

Si hay vulnerabilidades críticas, se resuelven antes del merge. Si no se pueden resolver, se documenta en `## Riesgos` de la Issue `[Dev]`.

---

## 7. Secrets y entornos

- El archivo de entorno se copia/manualiza al crear un worktree.
- El archivo de entorno real nunca se commitea (debe estar en `.gitignore`).
- No hardcodear API keys, tokens ni credenciales.
- Para tests, usar valores de fixture en lugar de secrets reales.

---

## 8. Cumplimiento normativo

El proyecto debe adaptar esta sección a las regulaciones que le apliquen (ej. GDPR, Ley de Protección de Datos Personales del país de operación, etc.).

Principios generales:

- Consentimiento explícito para datos personales.
- Derecho de acceso, rectificación y cancelación.
- Eliminación lógica, no física.
- Registro de tratamiento alineado con el audit trail.

---

## 9. Reporte de incidentes

Si se descubre una vulnerabilidad o fuga de datos durante una feature:

1. Detener el avance de la Issue `[Dev]` y moverla a `dev/blocked/`.
2. Documentar el incidente en la sección `## Riesgos` de la Issue.
3. Notificar al humano antes de continuar.
4. No mergear hasta que el riesgo esté mitigado.

---

## 10. Checklist final de seguridad (C7)

El `reviewer` verifica estos ítems antes de aprobar una feature crítica:

- [ ] RBAC validado en tests.
- [ ] Inputs sanitizados y validados.
- [ ] No se loggea PII.
- [ ] Audit trail presente en mutaciones críticas.
- [ ] Audit de dependencias sin vulnerabilidades críticas.
- [ ] No hard deletes en entidades de negocio.
- [ ] Secrets fuera del código.
