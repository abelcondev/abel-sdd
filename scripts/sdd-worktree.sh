#!/usr/bin/env bash
#
# sdd-worktree.sh — Gestor de worktrees para el flujo SDD.
#
# Cada feature vive en su propio worktree aislado, hermano del repo principal:
#   <repo-padre>/<repo-name>-<feature-slug>/
# con rama `feature/<feature-slug>`. Dentro del worktree se escriben los specs,
# se itera el diseño y se implementa el código.
#
# Uso:
#   ./scripts/sdd-worktree.sh create <feature-slug>
#   ./scripts/sdd-worktree.sh remove <feature-slug>
#   ./scripts/sdd-worktree.sh list
#   ./scripts/sdd-worktree.sh status <feature-slug>
#
# Ejemplo:
#   ./scripts/sdd-worktree.sh create login-y-dashboard-layout

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_NAME="$(basename "${REPO_ROOT}")"
WORKTREE_BASE="$(dirname "${REPO_ROOT}")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

die() { log_error "$*"; exit 1; }

ensure_repo_root() {
  if [[ ! -d "${REPO_ROOT}/.git" ]]; then
    die "No se encontró .git en ${REPO_ROOT}"
  fi
}

get_main_branch() {
  if git show-ref --verify --quiet refs/heads/main; then
    echo "main"
  elif git show-ref --verify --quiet refs/heads/master; then
    echo "master"
  else
    die "No se encontró rama main ni master"
  fi
}

validate_feature_slug() {
  local slug="$1"
  if [[ ! "${slug}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    die "Slug inválido. Usá kebab-case en minúsculas (ej. login-y-dashboard-layout)"
  fi
}

worktree_path_for() {
  local slug="$1"
  echo "${WORKTREE_BASE}/${REPO_NAME}-${slug}"
}

# ─── Comandos ─────────────────────────────────────────────────────────

cmd_create() {
  local feature_slug="$1"
  local branch_name="feature/${feature_slug}"
  local worktree_path="$(worktree_path_for "${feature_slug}")"
  local project_path="${worktree_path}/sdd/projects/${feature_slug}"

  validate_feature_slug "${feature_slug}"
  ensure_repo_root

  if [[ -d "${worktree_path}" ]]; then
    die "El worktree para '${feature_slug}' ya existe en ${worktree_path}"
  fi

  if git show-ref --verify --quiet "refs/heads/${branch_name}"; then
    log_warn "La rama '${branch_name}' ya existe. Se reutilizará."
  else
    local main_branch
    main_branch="$(get_main_branch)"
    log_info "Creando rama '${branch_name}' desde '${main_branch}'..."
    git branch "${branch_name}" "${main_branch}"
  fi

  log_info "Creando worktree en ${worktree_path}..."
  git worktree add "${worktree_path}" "${branch_name}"

  log_info "Creando estructura vacía del project en sdd/projects/${feature_slug}/..."
  mkdir -p "${project_path}/design"/{spec-needed,designing,design-ready}
  mkdir -p "${project_path}/dev"/{backlog,spec-needed,spec-ready,implementing,blocked,review,rejected,testing,done,cancelled}

  cat > "${project_path}/README.md" <<EOF
# ${feature_slug}

Slug: \`${feature_slug}\`

## Contexto

Breve descripción del problema u oportunidad de negocio.

## Alcance

- Funcionalidad incluida 1.
- Funcionalidad incluida 2.

## Out of scope

- Funcionalidad futura 1.

## Milestones

1. MVP: ...
2. Iteración 2: ...

## Módulos afectados

- \`<ruta-al-módulo>/\` — crear / modificar
- \`<ruta-al-módulo>/\` — reutilizar (no modificar)

## Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| ... | alto/medio/bajo | ... |

## Issues

- Design: \`sdd/projects/${feature_slug}/design/\`
- Dev: \`sdd/projects/${feature_slug}/dev/\`
EOF

  (
    cd "${worktree_path}"
    git add "sdd/projects/${feature_slug}/"
    git commit -m "chore(sdd): crear project ${feature_slug}" || true
  )

  echo ""
  log_info "Worktree listo para la feature '${feature_slug}'"
  echo "  Ruta:    ${worktree_path}"
  echo "  Rama:    ${branch_name}"
  echo "  Project: ${project_path}"
  echo ""
  log_info "Próximo paso: prepará tu entorno (dependencias, variables de entorno, etc.) y empezá el spec."
  echo ""
}

cmd_remove() {
  local feature_slug="$1"
  local branch_name="feature/${feature_slug}"
  local worktree_path="$(worktree_path_for "${feature_slug}")"

  validate_feature_slug "${feature_slug}"
  ensure_repo_root

  if [[ -d "${worktree_path}" ]]; then
    log_info "Eliminando worktree ${worktree_path}..."
    git worktree remove "${worktree_path}" 2>/dev/null || {
      log_warn "Worktree con cambios no commiteados. Forzando eliminación..."
      git worktree remove --force "${worktree_path}"
    }
  else
    log_warn "No existe worktree para '${feature_slug}'"
  fi

  if git show-ref --verify --quiet "refs/heads/${branch_name}"; then
    log_info "Eliminando rama local '${branch_name}'..."
    git branch -D "${branch_name}" 2>/dev/null || true
  fi

  # Limpia directorio residual si quedó
  if [[ -d "${worktree_path}" ]]; then
    rm -rf "${worktree_path}"
  fi

  log_info "Worktree y rama de '${feature_slug}' eliminados."
}

cmd_list() {
  ensure_repo_root

  echo "Worktrees de features activos:"
  echo "──────────────────────────────"

  local found=0
  while IFS= read -r line; do
    local path ref
    path="$(echo "$line" | awk '{print $1}')"
    ref="$(echo "$line" | awk '{print $3}')"

    local feature_slug=""
    if [[ "$path" == "${WORKTREE_BASE}/${REPO_NAME}-"* ]]; then
      feature_slug="${path#${WORKTREE_BASE}/${REPO_NAME}-}"
    fi

    if [[ -n "${feature_slug}" ]]; then
      echo "  📁 ${feature_slug}"
      echo "     Ruta: ${path}"
      echo "     Rama: ${ref}"
      found=1
    fi
  done <<< "$(git worktree list 2>/dev/null || true)"

  if [[ "$found" -eq 0 ]]; then
    echo "  (ninguno)"
  fi
}

cmd_status() {
  local feature_slug="$1"
  local worktree_path="$(worktree_path_for "${feature_slug}")"

  validate_feature_slug "${feature_slug}"
  ensure_repo_root

  if [[ ! -d "${worktree_path}" ]]; then
    die "No existe worktree para '${feature_slug}'. Crealo con: ./scripts/sdd-worktree.sh create ${feature_slug}"
  fi

  echo "Estado del worktree '${feature_slug}':"
  echo "────────────────────────────────────"
  echo "Ruta:  ${worktree_path}"
  echo "Rama:  $(cd "${worktree_path}" && git branch --show-current)"
  echo ""

  local dirty=""
  if ! (cd "${worktree_path}" && git diff --quiet && git diff --cached --quiet); then
    dirty=" (con cambios no commiteados)"
  fi
  echo "Git:   ${dirty:-limpio}"

  if [[ -x "${worktree_path}/init.sh" ]]; then
    echo ""
    echo "Corriendo ./init.sh..."
    (
      cd "${worktree_path}"
      ./init.sh >/tmp/sdd-init-${feature_slug}.log 2>&1 && \
        log_info "init.sh pasó" || \
        log_warn "init.sh falló — revisá /tmp/sdd-init-${feature_slug}.log"
    )
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────

show_help() {
  cat <<EOF
Uso: ./scripts/sdd-worktree.sh <comando> <feature-slug>

Comandos:
  create <feature-slug>   Crear rama + worktree + estructura SDD
  remove <feature-slug>   Eliminar worktree + rama
  list                    Listar worktrees de features activos
  status <feature-slug>   Mostrar estado y correr init.sh

Ejemplos:
  ./scripts/sdd-worktree.sh create login-y-dashboard-layout
  ./scripts/sdd-worktree.sh status login-y-dashboard-layout
  ./scripts/sdd-worktree.sh remove login-y-dashboard-layout

Nota:
  Los worktrees se crean como hermanos del repo principal:
    ${WORKTREE_BASE}/${REPO_NAME}-<feature-slug>
  Este script no instala dependencias ni abre un editor específico.
EOF
}

main() {
  local command="${1:-}"
  local feature_slug="${2:-}"

  case "${command}" in
    create)
      [[ -z "${feature_slug}" ]] && { show_help; exit 1; }
      cmd_create "${feature_slug}"
      ;;
    remove)
      [[ -z "${feature_slug}" ]] && { show_help; exit 1; }
      cmd_remove "${feature_slug}"
      ;;
    list)
      cmd_list
      ;;
    status)
      [[ -z "${feature_slug}" ]] && { show_help; exit 1; }
      cmd_status "${feature_slug}"
      ;;
    *)
      show_help
      exit 1
      ;;
  esac
}

main "$@"
