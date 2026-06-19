#!/usr/bin/env bash
#
# install-cli.sh — Installs the sdd CLI into ~/.local/bin
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/abelcondev/abel-sdd/main/install-cli.sh | bash

set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
SDD_CLI_URL="https://raw.githubusercontent.com/abelcondev/abel-sdd/main/sdd-cli"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }

main() {
  log_info "Installing sdd CLI into ${INSTALL_DIR}..."

  mkdir -p "${INSTALL_DIR}"
  curl -fsSL "${SDD_CLI_URL}" -o "${INSTALL_DIR}/sdd"
  chmod +x "${INSTALL_DIR}/sdd"

  log_info "sdd CLI installed at ${INSTALL_DIR}/sdd"

  if [[ ":${PATH}:" != *":${INSTALL_DIR}:"* ]]; then
    log_warn "${INSTALL_DIR} is not in your PATH."
    echo ""
    echo "Add this line to your shell profile (~/.zshrc or ~/.bashrc):"
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    echo ""
    echo "Then reload:"
    echo "  source ~/.zshrc"
  fi

  echo ""
  echo "Run 'sdd init' from any Git repository to install the SDD framework."
}

main
