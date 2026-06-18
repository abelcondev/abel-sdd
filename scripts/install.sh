#!/usr/bin/env bash
#
# scripts/install.sh — Wrapper para install.sh en la raíz del repo.
#
# Uso:
#   ./scripts/install.sh [--update] <ruta-al-proyecto-destino>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/../install.sh" "$@"
