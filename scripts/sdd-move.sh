#!/usr/bin/env bash
#
# sdd-move.sh — Mueve una Issue del SDD entre estados y commitea el cambio.
#
# Uso:
#   ./scripts/sdd-move.sh <feature-slug> <issue-name> <estado-origen> <estado-destino>
#
# Ejemplo:
#   ./scripts/sdd-move.sh login-y-dashboard-layout login design/spec-needed design/designing
#   ./scripts/sdd-move.sh login-y-dashboard-layout login dev/implementing dev/review

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

die() { log_error "$*"; exit 1; }

show_help() {
  cat <<EOF
Uso: ./scripts/sdd-move.sh <feature-slug> <issue> <estado-origen> <estado-destino>

Mueve un archivo de Issue entre carpetas de estado en sdd/projects/ y genera un commit.

Ejemplos:
  ./scripts/sdd-move.sh login-y-dashboard-layout login design/spec-needed design/designing
  ./scripts/sdd-move.sh login-y-dashboard-layout login dev/implementing dev/review

 Estados válidos para [Design]:
   design/spec-needed, design/designing, design/design-ready

 Estados válidos para [Dev]:
   dev/backlog, dev/spec-needed, dev/spec-ready, dev/implementing,
   dev/blocked, dev/review, dev/rejected, dev/testing, dev/done, dev/cancelled
EOF
}

validate_args() {
  if [ "$#" -ne 4 ]; then
    show_help
    exit 1
  fi
}

main() {
  local feature_slug="$1"
  local issue="$2"
  local source_state="$3"
  local target_state="$4"

  local project_path="${REPO_ROOT}/sdd/projects/${feature_slug}"
  local source_file="${project_path}/${source_state}/${issue}.md"
  local target_file="${project_path}/${target_state}/${issue}.md"

  if [ ! -f "${source_file}" ]; then
    die "No existe ${source_file}"
  fi

  if [ -f "${target_file}" ]; then
    die "Ya existe ${target_file}"
  fi

  local issue_type="Issue"
  if [[ "${source_state}" == design/* ]]; then
    issue_type="[Design]"
  elif [[ "${source_state}" == dev/* ]]; then
    issue_type="[Dev]"
  fi

  log_info "Moviendo ${issue} ${issue_type}: ${source_state} → ${target_state}"

  local source_rel="${source_file#${REPO_ROOT}/}"
  local target_rel="${target_file#${REPO_ROOT}/}"

  # git mv solo funciona bien si el archivo ya está committed.
  # Si es nuevo (solo staged o untracked), hacemos mv manual + git add.
  if git -C "${REPO_ROOT}" cat-file -e "HEAD:${source_rel}" >/dev/null 2>&1; then
    git -C "${REPO_ROOT}" mv "${source_rel}" "${target_rel}"
  else
    mkdir -p "$(dirname "${target_file}")"
    mv "${source_file}" "${target_file}"
    git -C "${REPO_ROOT}" rm --cached "${source_rel}" 2>/dev/null || true
    git -C "${REPO_ROOT}" add "${target_rel}"
  fi

  # Actualizar la línea de Estado dentro del archivo.
  # Soporta tanto comillas dobles como backticks en los templates.
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s#^Estado: [\"\`].*[\"\`]#Estado: \"${target_state}\"#" "${target_file}" || true
  else
    sed -i "s#^Estado: [\"\`].*[\"\`]#Estado: \"${target_state}\"#" "${target_file}" || true
  fi

  git -C "${REPO_ROOT}" add "${target_file}"

  # Commitear solo el cambio de esta issue, no otros archivos staged.
  local commit_msg="chore(sdd): ${issue} ${issue_type} ${source_state} → ${target_state}"
  if git -C "${REPO_ROOT}" diff --cached --quiet -- "${target_file}"; then
    log_warn "No hay cambios para commitear."
    exit 0
  fi
  git -C "${REPO_ROOT}" commit -m "${commit_msg}" -- "${target_file}" || {
    log_warn "No se pudo crear el commit automáticamente. Hacelo manualmente."
    exit 1
  }

  log_info "Commit creado: ${commit_msg}"
}

validate_args "$@"
main "$@"
