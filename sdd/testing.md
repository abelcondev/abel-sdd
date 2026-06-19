# Testing — Estrategia, TDD y calidad ejecutable

La regla de oro: **executable evidence, not claims**.

Todo trabajo se demuestra con evidencia ejecutable, no con afirmaciones.

---

## 1. Filosofía

- Un feature no está terminado hasta que sus tests pasan.
- Los tests documentan el comportamiento esperado mejor que cualquier comentario.
- Preferir tests que fallen por la razón correcta (mensajes claros) sobre tests opacos.

---

## 2. Tipos de tests

| Tipo | Qué valida | Dónde vive | Ejemplo |
|---|---|---|---|
| **Unitario** | Lógica pura, funciones, utilidades | `tests/unit/` o equivalente | `crearReserva()` con datos válidos e inválidos |
| **Integración** | Flujos entre módulos, queries/mutations | `tests/integration/` o equivalente | Auth + crear reserva + leer reserva |
| **UI/Componente** | Comportamiento de componentes | `tests/component/` o equivalente | Formulario valida campos requeridos |
| **E2E** | Flujo completo del usuario | `tests/e2e/` o equivalente | Login → crear reserva → ver dashboard |

El proyecto define en `sdd/architecture.md` qué tipos son obligatorios y qué herramientas usa.

---

## 3. TDD — Test Driven Development

Cada `R<n>` de la Issue `[Design]` se implementa con el ciclo:

```text
Rojo  → Escribir un test que falla.
Verde → Escribir el código mínimo para que pase.
Refactor → Mejorar el código manteniendo el test verde.
```

### Reglas

1. **Nunca escribir código de producción sin un test que lo exija primero.**
2. **Un test debe fallar por una sola razón.**
3. **El código de producción debe ser el mínimo para pasar.**
4. **Refactor solo con todos los tests verdes.**

### Aplicación en el SDD

| Fase SDD | Acción TDD |
|---|---|
| `dev/spec-needed/` → `spec-ready/` | El `specifier` escribe el **Test Plan** con tests de aceptación para cada `R<n>`. |
| `dev/implementing/` | El `developer` ejecuta ciclo red-green-refactor por cada `R<n>`. |
| `dev/review/` | El `auditor` verifica que exista un test por cada `R<n>` y que los commits reflejen TDD. |
| `dev/testing/` → `done/` | `init.sh` pasa con cobertura reportada. |

### Commits TDD

```text
test(<scope>): R2 validar cliente obligatorio — login-y-dashboard-layout/reservas
feat(<scope>): R2 agregar validación de cliente obligatorio — login-y-dashboard-layout/reservas
refactor(<scope>): simplificar validación de cliente — login-y-dashboard-layout/reservas
```

---

## 4. Test Plan obligatorio

La Issue `[Dev]` debe incluir una sección `## Test Plan` derivada directamente de los `R<n>` de la Issue `[Design]`.

```markdown
## Test Plan

| Requisito | Test de aceptación | Tipo | Prioridad |
|---|---|---|---|
| R1 | Crear reserva con datos válidos devuelve reserva activa | integración | obligatorio |
| R2 | Crear reserva sin cliente lanza error de validación | unitario | obligatorio |
| R3 | Usuario sin rol admin no ve reservas de otros | integración | obligatorio |
```

Cada test debe ser:
- **Atómico**: un solo comportamiento.
- **Independiente**: no depender de otros tests.
- **Determinístico**: mismo resultado siempre.
- **Legible**: el nombre describe el comportamiento.

---

## 5. Estructura de tests

El proyecto define la estructura. Ejemplo típico:

```text
tests/
├── setup.ts                 # Config global, mocks
├── fixtures/                # Datos de prueba reutilizables
├── unit/                    # Tests unitarios
└── integration/             # Tests de integración
```

### Naming

- Tests unitarios: `<nombre-de-la-función>.test.<ext>`
- Tests de integración: `<flujo>.test.<ext>` o `<módulo>.integration.test.<ext>`
- Describe el comportamiento, no la implementación:
  - ✅ `crear reserva sin cliente lanza error de validación`
  - ❌ `test crearReserva 2`

---

## 6. Fixtures y mocks

### Fixtures

Datos de prueba centralizados y reutilizables:

```typescript
// tests/fixtures/users.ts
export const adminUser = { id: 'u-1', role: 'admin', email: 'admin@example.com' };
export const operatorUser = { id: 'u-2', role: 'operator', email: 'op@example.com' };
```

> Adaptar al lenguaje del proyecto.

### Mocks estándar

El proyecto define en `tests/setup.*` los mocks globales necesarios (navegación, entorno, storage, etc.).

### Anti-patrón

- ❌ Mockear todo el filesystem o la red sin justificación.
- ❌ Mockear la librería que estás probando.
- ❌ Compartir estado mutable entre tests.

---

## 7. Cobertura

### Umbrales mínimos

El proyecto define sus umbrales en `sdd/architecture.md` o aquí. Ejemplo:

| Tipo de módulo | Cobertura mínima |
|---|---|
| Crítico (pagos, auth, datos sensibles) | 100% |
| Dominio principal | 70% |
| Soporte/utilidades | 50% |
| UI pura | 30% |

### Cómo medir

```bash
<test-runner> --coverage
```

> El proyecto completa con su test runner.

---

## 8. Trazabilidad R<n> → Test

Cada `R<n>` debe mapear a al menos un test concreto. El auditor documenta esto en la sección `## Review` de la Issue `[Dev]`:

```markdown
| Requisito | Test file | Línea | Estado |
|-----------|-----------|-------|--------|
| R1 | tests/integration/reservas/crear.test.ts | 23 | ✅ |
| R2 | tests/unit/reservas/validar.test.ts | 41 | ✅ |
| R3 | tests/integration/reservas/rbac.test.ts | 18 | ✅ |
```

---

## 9. Quality gates de testing

Antes de declarar `done`:

- [ ] El test runner pasa sin errores.
- [ ] Se alcanza la cobertura mínima definida por el proyecto.
- [ ] Cada `R<n>` tiene al menos un test.
- [ ] Cada test de aceptación del Test Plan está escrito.
- [ ] No hay tests "tontos" que solo verifiquen que no explota.
- [ ] No hay mocks innecesarios del filesystem ni de la red.

---

## 10. Anti-patrones de testing

- "Debería funcionar" sin test ejecutable.
- Test que solo verifica que no explota.
- Mocking excesivo de la persistencia o del filesystem.
- Escribir todos los tests al final.
- Tests que dependen del orden de ejecución.
- Nombres de test que no explican el comportamiento.
