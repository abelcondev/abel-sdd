#!/usr/bin/env bash
# init.sh — Validación del harness SDD.
# Uso: ./init.sh
#
# Este script verifica que la estructura y archivos del SDD estén presentes.
# No ejecuta tests, lint, build ni valida herramientas del stack.
# Cada proyecto puede extender este script con sus propios checks.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

log_section() {
  echo ""
  echo "== $1 =="
}

ok() {
  echo -e "${GREEN}[OK]${NC} $1"
}

fail() {
  echo -e "${RED}[FAIL]${NC} $1"
  ERRORS=$((ERRORS + 1))
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

# Cuenta archivos .md directamente bajo un directorio.
count_md_files() {
  local dir="$1"
  if [[ ! -d "${dir}" ]]; then
    echo 0
    return
  fi
  find "${dir}" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '
}

# ─────────────────────────────────────────
# 1. Archivos del harness
# ─────────────────────────────────────────
log_section "1. Archivos del harness"

required_files=(
  "AGENTS.md"
  "CLAUDE.md"
  "init.sh"
  "sdd/README.md"
  "sdd/workflow.md"
  "sdd/architecture.md"
  "sdd/conventions.md"
  "sdd/quality-gates.md"
  "sdd/testing.md"
  "sdd/security.md"
  "sdd/delivery.md"
  ".claude/agents/leader.md"
  ".claude/agents/spec_author.md"
  ".claude/agents/implementer.md"
  ".claude/agents/reviewer.md"
)

for f in "${required_files[@]}"; do
  if [ -f "$f" ]; then
    ok "$f"
  else
    fail "Falta $f"
  fi
done

# ─────────────────────────────────────────
# 2. Configuración SDD local
# ─────────────────────────────────────────
log_section "2. Configuración SDD local"

if [ -d "sdd/projects" ]; then
  ok "sdd/projects/ existe"
else
  fail "Falta sdd/projects/"
fi

if [ -d "sdd/decisions" ]; then
  ok "sdd/decisions/ existe"
else
  warn "Falta sdd/decisions/ — crear con: mkdir -p sdd/decisions"
fi

if [ -f "feature_list.yaml" ]; then
  fail "feature_list.yaml aún existe. El flujo SDD no lo usa; eliminarlo."
else
  ok "feature_list.yaml eliminado"
fi

if [ -d "specs" ]; then
  warn "La carpeta specs/ aún existe. En el flujo SDD los specs viven en sdd/projects/."
else
  ok "Carpeta specs/ eliminada"
fi

# ─────────────────────────────────────────
# 3. Validaciones de estado SDD
# ─────────────────────────────────────────
log_section "3. Validaciones de estado SDD"

DESIGN_STATES=(spec-needed designing design-ready)
DEV_STATES=(backlog spec-needed spec-ready implementing blocked review rejected testing done cancelled)

state_is_valid() {
  local state="$1"
  local type="$2"
  local s=""

  if [[ "${type}" == "design" ]]; then
    for s in "${DESIGN_STATES[@]}"; do
      if [[ "${s}" == "${state}" ]]; then
        return 0
      fi
    done
  elif [[ "${type}" == "dev" ]]; then
    for s in "${DEV_STATES[@]}"; do
      if [[ "${s}" == "${state}" ]]; then
        return 0
      fi
    done
  fi

  return 1
}

# 3.1 Concurrencia: máximo una Issue [Dev] en implementing/ o review/.
if [ -d "sdd/projects" ]; then
  implementing_count=0
  review_count=0

  implementing_count=$(find sdd/projects -mindepth 3 -maxdepth 3 -type d -name implementing -exec find {} -maxdepth 1 -type f -name '*.md' \; 2>/dev/null | wc -l | tr -d ' ')
  review_count=$(find sdd/projects -mindepth 3 -maxdepth 3 -type d -name review -exec find {} -maxdepth 1 -type f -name '*.md' \; 2>/dev/null | wc -l | tr -d ' ')

  active_dev_count=$((implementing_count + review_count))

  if [[ "${active_dev_count}" -eq 0 ]]; then
    ok "No hay Issues [Dev] en implementing/ ni review/"
  elif [[ "${active_dev_count}" -eq 1 ]]; then
    ok "Hay exactamente una Issue [Dev] en implementing/ o review/"
  else
    fail "Hay ${active_dev_count} Issues [Dev] en implementing/ o review/. Debe haber solo una."
  fi
else
  warn "No se puede validar concurrencia: falta sdd/projects/"
fi

# 3.2 Cada project debe tener al menos una Issue [Design] y una [Dev].
# 3.3 Las carpetas de estado deben ser válidas según sdd/workflow.md.
if [ -d "sdd/projects" ]; then
  projects_found=0

  for project_dir in sdd/projects/*/; do
    [[ -d "${project_dir}" ]] || continue
    projects_found=$((projects_found + 1))

    project_name="$(basename "${project_dir}")"
    design_count=0
    dev_count=0

    if [ -d "${project_dir}/design" ]; then
      for state_dir in "${project_dir}/design"/*/; do
        [[ -d "${state_dir}" ]] || continue
        state_name="$(basename "${state_dir}")"
        if state_is_valid "${state_name}" design; then
          design_count=$((design_count + $(count_md_files "${state_dir}")))
        else
          fail "${project_name}/design/${state_name} no es un estado válido para [Design]"
        fi
      done

      # No debería haber archivos sueltos directamente en design/
      if [[ "$(count_md_files "${project_dir}/design")" -gt 0 ]]; then
        fail "${project_name}/design/ contiene archivos .md fuera de una carpeta de estado"
      fi
    fi

    if [ -d "${project_dir}/dev" ]; then
      for state_dir in "${project_dir}/dev"/*/; do
        [[ -d "${state_dir}" ]] || continue
        state_name="$(basename "${state_dir}")"
        if state_is_valid "${state_name}" dev; then
          dev_count=$((dev_count + $(count_md_files "${state_dir}")))
        else
          fail "${project_name}/dev/${state_name} no es un estado válido para [Dev]"
        fi
      done

      if [[ "$(count_md_files "${project_dir}/dev")" -gt 0 ]]; then
        fail "${project_name}/dev/ contiene archivos .md fuera de una carpeta de estado"
      fi
    fi

    if [[ "${design_count}" -eq 0 ]]; then
      fail "${project_name} no tiene ninguna Issue [Design]"
    else
      ok "${project_name}: tiene al menos una Issue [Design]"
    fi

    if [[ "${dev_count}" -eq 0 ]]; then
      fail "${project_name} no tiene ninguna Issue [Dev]"
    else
      ok "${project_name}: tiene al menos una Issue [Dev]"
    fi
  done

  if [[ "${projects_found}" -eq 0 ]]; then
    warn "No hay projects en sdd/projects/"
  fi
else
  warn "No se puede validar projects: falta sdd/projects/"
fi

# ─────────────────────────────────────────
# 4. Checks adicionales del proyecto (opcional)
# ─────────────────────────────────────────
log_section "4. Checks adicionales del proyecto"

if [ -x "./scripts/project-checks.sh" ]; then
  echo "Corriendo ./scripts/project-checks.sh..."
  if ./scripts/project-checks.sh; then
    ok "project-checks.sh pasó"
  else
    fail "project-checks.sh falló"
  fi
else
  warn "No existe ./scripts/project-checks.sh. El proyecto puede crearlo para agregar validaciones de stack (tests, lint, build, etc.)."
fi

# ─────────────────────────────────────────
# Resumen
# ─────────────────────────────────────────
echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo -e "${GREEN}[OK] Harness SDD listo${NC}"
  exit 0
else
  echo -e "${RED}[FAIL] Harness SDD NO está listo — $ERRORS error(es)${NC}"
  exit 1
fi
