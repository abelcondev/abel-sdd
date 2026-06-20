#!/usr/bin/env bash
#
# install-cli.sh — Installs the sdd CLI into ~/.local/bin
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/abelcondev/abel-sdd/main/install-cli.sh | bash

set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
SDD_CLI_URL="https://raw.githubusercontent.com/abelcondev/abel-sdd/main/sdd-cli"

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_banner() {
  echo ""
  echo -e "${BLUE}   _____   _____   _____ ${NC}"
  echo -e "${BLUE}  / ____| |  __ \\ |  __ \\ ${NC}"
  echo -e "${BLUE} | (___   | |  | || |  | |${NC}"
  echo -e "${BLUE}  \\___ \\  | |  | || |  | |${NC}"
  echo -e "${BLUE}  ____) | | |__| || |__| |${NC}"
  echo -e "${BLUE} |_____/  |_____/ |_____/ ${NC}"
  echo ""
  echo -e "${BOLD}One-command installer for abel-sdd${NC}"
  echo ""
}

log_success() { echo -e "${GREEN}✔${NC} $*"; }
log_warn()    { echo -e "${YELLOW}▲${NC} $*"; }

main() {
  print_banner

  echo -e "${BOLD}Installing sdd CLI into:${NC} ${INSTALL_DIR}"
  mkdir -p "${INSTALL_DIR}"
  curl -fsSL "${SDD_CLI_URL}" -o "${INSTALL_DIR}/sdd"
  chmod +x "${INSTALL_DIR}/sdd"
  log_success "sdd CLI installed at ${INSTALL_DIR}/sdd"

  if [[ ":${PATH}:" != *":${INSTALL_DIR}:"* ]]; then
    echo ""
    log_warn "${INSTALL_DIR} is not in your PATH."
    echo ""
    echo "Add this line to your shell profile (~/.zshrc or ~/.bashrc):"
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    echo ""
    echo "Then reload:"
    echo "  source ~/.zshrc"
  fi

  echo ""
  echo -e "Run ${BOLD}sdd init${NC} from any Git repository to install the SDD framework."
  echo ""
}

main
