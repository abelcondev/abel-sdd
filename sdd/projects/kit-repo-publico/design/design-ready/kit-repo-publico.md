# [Design] Kit básico de repo público

Project: `sdd/projects/kit-repo-publico/`
Estado: `design/design-ready`

## Context

Diseño de la documentación y estructura de archivos para publicar `abel-sdd` como repo/template público. No hay UI visual; el diseño es la organización de la información.

## Requirements

### R1: Estructura del README

CUANDO un usuario abre `README.md`, el sistema DEBE mostrar: título, badges, descripción corta, instalación, uso rápido, estructura, roles y licencia.

### R2: Estructura de CI

CUANDO se abre un PR, el sistema DEBE mostrar un check de GitHub Actions corriendo `init.sh`.

## BDD Reference

- Issue [Product]: `sdd/projects/kit-repo-publico/product/product-ready/kit-repo-publico.md`

## UI/UX Design

No aplica. Esta feature es de documentación y configuración de repo.

## Dependencies

- blockedBy: [Product] `kit-repo-publico`
- Bloquea a: `[Dev] kit-repo-publico`
