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
  echo -e "${BLUE}        _____   _____   _____ ${NC}"
  echo -e "${BLUE}       / ____| |  __ \\ |  __ \\ ${NC}"
  echo -e "${BLUE}      | (___   | |  | || |  | |${NC}"
  echo -e "${BLUE}       \\___ \\  | |  | || |  | |${NC}"
  echo -e "${BLUE}       ____) | | |__| || |__| |${NC}"
  echo -e "${BLUE}      |_____/  |_____/ |_____/ ${NC}"
  echo ""
  echo -e "${BOLD}One-command installer for abel-sdd${NC}"
  echo ""
}

log_success() { echo -e "${GREEN}✔${NC} $*"; }
log_warn()    { echo -e "${YELLOW}▲${NC} $*"; }

prompt_confirm() {
  local message="$1"
  local default="${2:-y}"
  local input

  while true; do
    if [[ "${default}" == "y" ]]; then
      read -rp "${message} [Y/n]: " input
      input="${input:-Y}"
    else
      read -rp "${message} [y/N]: " input
      input="${input:-N}"
    fi

    case "${input}" in
      [yY]|"yes"|"YES"|"Yes") return 0 ;;
      [nN]|"no"|"NO"|"No") return 1 ;;
      *) echo "Please answer Y or N." ;;
    esac
  done
}

main() {
  print_banner

  echo -e "${BOLD}Step 1 of 2 — Installing sdd CLI into:${NC} ${INSTALL_DIR}"
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
    echo ""
    echo -e "After that, run ${BOLD}sdd init${NC} to install the SDD framework into a project."
    echo ""
    exit 0
  fi

  echo ""
  echo -e "${BOLD}Step 2 of 2 — Install the SDD framework:${NC}"
  echo ""
  echo "  sdd init"
  echo ""

  if prompt_confirm "Run 'sdd init' now in the current directory?"; then
    sdd init
  else
    echo ""
    echo -e "Run ${BOLD}sdd init${NC} whenever you're ready to install the SDD framework."
    echo ""
  fi
}

main
