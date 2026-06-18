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
# 3. Checks adicionales del proyecto (opcional)
# ─────────────────────────────────────────
log_section "3. Checks adicionales del proyecto"

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
