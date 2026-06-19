# [Product] Kit básico de repo público

Project: `sdd/projects/kit-repo-publico/`
Estado: `product/product-ready`

## Context

Antes de publicar `abel-sdd` en GitHub como template, el repo necesita documentación y automatización básica para que otros puedan entenderlo, contribuir y confiar en que funciona.

## Product Goals

- Tener un README atractivo y claro.
- Tener CI que verifique `init.sh` en cada cambio.
- Tener guías mínimas de contribución y changelog.
- Dejar `.gitignore` adecuado para un template.

## Requirements

### R1: README mejorado

CUANDO un usuario visita el repo, DEBE entender qué es `abel-sdd`, cómo instalarlo y cómo empezar en menos de 5 minutos.

### R2: CI con GitHub Actions

CUANDO se hace push o PR a `main`, el sistema DEBE correr `./init.sh` y reportar el resultado.

### R3: CONTRIBUTING.md

CUANDO alguien quiere contribuir, DEBE encontrar una guía básica de cómo proponer cambios.

### R4: CHANGELOG.md

CUANDO se publica una versión, el sistema DEBE tener un archivo que registre los cambios.

### R5: PR template

CUANDO alguien abre un PR, DEBE ver un template con checklist mínima.

### R6: .gitignore revisado

CUANDO se usa el framework, el `.gitignore` DEBE evitar commitear worktrees, logs y archivos de entorno.

## Acceptance Criteria

- [ ] README incluye badges, instalación, uso y estructura.
- [ ] Existe `.github/workflows/ci.yml` funcional.
- [ ] Existe `CONTRIBUTING.md`.
- [ ] Existe `CHANGELOG.md`.
- [ ] Existe `.github/PULL_REQUEST_TEMPLATE.md`.
- [ ] `.gitignore` cubre worktrees, logs y entornos.
- [ ] `./init.sh` pasa en verde.

## Dependencies

- Bloquea a: `[Design] kit-repo-publico`
