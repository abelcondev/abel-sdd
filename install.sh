#!/usr/bin/env bash
#
# install.sh — Instala el SDD en un proyecto destino.
#
# Uso:
#   ./install.sh <ruta-al-proyecto-destino>
#   ./install.sh --update <ruta-al-proyecto-destino>
#   ./install.sh --help
#
# Ejemplo:
#   ./install.sh /ruta/a/tu-proyecto
#   ./install.sh --update /ruta/a/tu-proyecto

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
Uso: ./install.sh [--update] <ruta-al-proyecto-destino>

Instala el framework SDD en un proyecto existente.

Pasos:
  1. Copia sdd/, scripts/, .claude/agents/, AGENTS.md, CLAUDE.md e init.sh.
  2. No toca el código fuente del proyecto destino.
  3. Verifica que el destino sea un repositorio Git.
  4. Sin --update: si ya existe sdd/ en el destino, pregunta antes de sobrescribir.
  5. Con --update: sobrescribe sin preguntar, pero hace backup de AGENTS.md y CLAUDE.md.

Opciones:
  --update    Sobrescribir sin interacción y respaldar archivos sensibles.
  --help      Mostrar esta ayuda.

Ejemplos:
  ./install.sh /ruta/a/tu-proyecto
  ./install.sh --update /ruta/a/tu-proyecto
EOF
}

UPDATE_MODE=false
DEST_ARG=""

for arg in "$@"; do
  case "${arg}" in
    --update)
      UPDATE_MODE=true
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    -*)
      die "Opción desconocida: ${arg}. Usá ./install.sh --help"
      ;;
    *)
      if [[ -n "${DEST_ARG}" ]]; then
        die "Solo se permite un directorio destino. Usá ./install.sh --help"
      fi
      DEST_ARG="${arg}"
      ;;
  esac
done

if [[ -z "${DEST_ARG}" ]]; then
  show_help
  exit 1
fi

DEST_DIR="${DEST_ARG}"

if [[ ! -d "${DEST_DIR}" ]]; then
  die "El directorio destino no existe: ${DEST_DIR}"
fi

DEST_DIR="$(cd "${DEST_DIR}" && pwd)"

if [[ "${DEST_DIR}" == "${SCRIPT_DIR}" ]]; then
  die "El directorio destino no puede ser el mismo repo de abel-sdd."
fi

if [[ ! -d "${DEST_DIR}/.git" ]]; then
  die "El directorio destino no es un repositorio Git: ${DEST_DIR}"
fi

log_info "Instalando SDD en ${DEST_DIR}..."

# Archivos que pueden tener customizaciones del proyecto destino.
CUSTOM_FILES=(
  "AGENTS.md"
  "CLAUDE.md"
)

if [[ "${UPDATE_MODE}" == true ]]; then
  for file in "${CUSTOM_FILES[@]}"; do
    if [[ -f "${DEST_DIR}/${file}" ]]; then
      backup="${DEST_DIR}/${file}.backup-$(date +%Y%m%d-%H%M%S)"
      cp "${DEST_DIR}/${file}" "${backup}"
      log_info "Backup creado: ${backup}"
    fi
  done
else
  for file in "${CUSTOM_FILES[@]}"; do
    if [[ -f "${DEST_DIR}/${file}" ]]; then
      log_warn "Ya existe ${file} en el proyecto destino."
    fi
  done

  if [[ -d "${DEST_DIR}/sdd" ]]; then
    log_warn "Ya existe sdd/ en el proyecto destino."
    read -rp "¿Sobrescribir? (s/N): " confirm
    if [[ "${confirm}" != "s" && "${confirm}" != "S" ]]; then
      log_info "Instalación cancelada."
      exit 0
    fi
  fi
fi

# Copiar estructura
items=(
  "AGENTS.md"
  "CLAUDE.md"
  "init.sh"
  "sdd"
  "scripts"
  ".claude"
)

for item in "${items[@]}"; do
  src="${SCRIPT_DIR}/${item}"
  dst="${DEST_DIR}/${item}"

  if [[ ! -e "${src}" ]]; then
    log_warn "No existe ${src}, se omite."
    continue
  fi

  if [[ -e "${dst}" ]]; then
    rm -rf "${dst}"
  fi

  cp -R "${src}" "${dst}"
  log_info "Copiado ${item}"
done

# Asegurar que init.sh y scripts sean ejecutables
chmod +x "${DEST_DIR}/init.sh"
chmod +x "${DEST_DIR}/scripts/"*.sh 2>/dev/null || true

log_info "Instalación completada."
echo ""
echo "Próximos pasos en el proyecto destino:"
echo "  1. cd ${DEST_DIR}"
echo "  2. Completar sdd/architecture.md con el stack del proyecto."
echo "  3. Completar sdd/conventions.md con estilo y naming del proyecto."
echo "  4. Opcional: crear scripts/project-checks.sh para validar tests/lint/build."
echo "  5. Correr ./init.sh para verificar el harness."
echo "  6. Crear la primera feature: ./scripts/sdd-worktree.sh create <feature-slug>"
