#!/usr/bin/env bash
#
# install.sh — Installs the SDD framework into a destination project.
#
# Interactive usage:
#   ./install.sh
#   ./install.sh <path-to-destination-project>
#
# Non-interactive usage:
#   ./install.sh --quick <path-to-destination-project>
#   ./install.sh --update <path-to-destination-project>
#
# Example:
#   ./install.sh /path/to/your-project
#   ./install.sh --update /path/to/your-project

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DIM='\033[2m'
NC='\033[0m'

log_success() { echo -e "${GREEN}✔${NC} $*"; }
log_warn()    { echo -e "${YELLOW}▲${NC} $*"; }
log_error()   { echo -e "${RED}✖${NC} $*" >&2; }
log_step()    { echo -e "${BLUE}◆${NC} $*"; }
log_dim()     { echo -e "${DIM}$*${NC}"; }

die() { log_error "$*"; exit 1; }

print_banner() {
  echo ""
  echo -e "${BLUE}        _____   _____   _____ ${NC}"
  echo -e "${BLUE}       / ____| |  __ \\ |  __ \\ ${NC}"
  echo -e "${BLUE}      | (___   | |  | || |  | |${NC}"
  echo -e "${BLUE}       \\___ \\  | |  | || |  | |${NC}"
  echo -e "${BLUE}       ____) | | |__| || |__| |${NC}"
  echo -e "${BLUE}      |_____/  |_____/ |_____/ ${NC}"
  echo ""
  echo -e "${BOLD}Install the SDD framework into a project${NC}"
  echo ""
}

show_help() {
  cat <<EOF
Usage: ./install.sh [options] [<path-to-destination-project>]

Installs the SDD framework into an existing project.

What it does:
  • Copies sdd/, scripts/, .claude/agents/, AGENTS.md, CLAUDE.md, and init.sh.
  • Does not touch the destination project's source code.
  • Ensures the destination is a Git repository, initializing one if needed.
  • Asks for the repo type (simple or monorepo).

Options:
  --quick     Do not ask; detect automatically.
  --update    Overwrite without interaction and back up AGENTS.md and CLAUDE.md.
  --help      Show this help.

Example:
  ./install.sh
  ./install.sh /path/to/your-project
  ./install.sh --quick /path/to/your-project
  ./install.sh --update /path/to/your-project
EOF
}

QUICK_MODE=false
UPDATE_MODE=false
DEST_ARG=""

for arg in "$@"; do
  case "${arg}" in
    --quick)
      QUICK_MODE=true
      ;;
    --update)
      UPDATE_MODE=true
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    -*)
      die "Unknown option: ${arg}. Use ./install.sh --help"
      ;;
    *)
      if [[ -n "${DEST_ARG}" ]]; then
        die "Only one destination directory allowed. Use ./install.sh --help"
      fi
      DEST_ARG="${arg}"
      ;;
  esac
done

# ─────────────────────────────────────────
# Interactive helpers
# ─────────────────────────────────────────

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

prompt_input() {
  local message="$1"
  local default="${2:-}"
  local input

  if [[ -n "${default}" ]]; then
    read -rp "${message} [${default}]: " input
  else
    read -rp "${message}: " input
  fi

  echo "${input:-${default}}"
}

prompt_select_index() {
  local message="$1"
  shift
  local options=("$@")
  local input
  local i

  echo "${message}"
  for i in "${!options[@]}"; do
    echo "  $((i + 1)). ${options[$i]}"
  done

  while true; do
    echo -n "  > "
    read -r input
    if [[ "${input}" =~ ^[0-9]+$ ]] && [[ "${input}" -ge 1 && "${input}" -le ${#options[@]} ]]; then
      PROMPT_SELECT_RESULT="${input}"
      return 0
    fi
    echo "  Invalid option. Choose a number between 1 and ${#options[@]}."
  done
}

# ─────────────────────────────────────────
# Detection
# ─────────────────────────────────────────

detect_git_root() {
  local dir="$1"
  if [[ -d "${dir}/.git" ]]; then
    echo "${dir}"
    return 0
  fi

  if [[ "$(git -C "${dir}" rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
    git -C "${dir}" rev-parse --show-toplevel 2>/dev/null
    return 0
  fi

  return 1
}

ensure_git_root() {
  local dir="$1"
  local git_root
  local initialized=false

  if git_root="$(detect_git_root "${dir}")"; then
    if [[ "${git_root}" == "${dir}" ]]; then
      echo "${git_root}"
      return 0
    fi
  fi

  echo -e "${YELLOW}▲${NC} No Git repository found in ${dir}. Initializing one..." >&2
  if git init "${dir}" >/dev/null 2>&1; then
    initialized=true
    git_root="${dir}"
  else
    return 1
  fi

  # Ensure a fresh repository has a 'main' branch with at least one commit,
  # so that feature worktrees can branch from it without errors.
  if [[ "${initialized}" == true ]] && ! git -C "${git_root}" rev-parse --verify HEAD >/dev/null 2>&1; then
    git -C "${git_root}" checkout -b main 2>/dev/null || true
    git -C "${git_root}" commit --allow-empty -m "chore: initial commit" >/dev/null 2>&1 || true
  fi

  echo "${git_root}"
  return 0
}

detect_monorepo_roots() {
  local dir="$1"
  local roots=()

  for candidate in packages apps apps/web apps/api src/packages; do
    if [[ -d "${dir}/${candidate}" ]]; then
      roots+=("${candidate}")
    fi
  done

  if [[ ${#roots[@]} -gt 0 ]]; then
    printf '%s\n' "${roots[@]}"
  fi
}

# ─────────────────────────────────────────
# Interactive configuration
# ─────────────────────────────────────────

configure_installation() {
  local dest_dir="$1"
  local git_root
  local detected_roots=""
  local repo_index
  local repo_label
  local install_location
  local package_dir

  print_banner

  # 1. Destination project
  log_step "Where should SDD be installed?"
  if ! git_root="$(ensure_git_root "${dest_dir}")"; then
    die "No Git repository found in ${dest_dir}. SDD requires a Git repo."
  fi
  echo -e "  ${BOLD}Git repo:${NC} ${git_root}"

  if ! prompt_confirm "  Is this directory correct?"; then
    die "Installation cancelled by the user."
  fi

  # 2. Repository type
  log_step "How do you want to organize the SDD?"
  prompt_select_index "  Choose a repository type:" \
    "Simple repo — single project at the root" \
    "Monorepo — SDD at the root, features may cross packages"
  repo_index="${PROMPT_SELECT_RESULT}"

  case "${repo_index}" in
    1) repo_label="Simple repo" ;;
    2) repo_label="Monorepo at root" ;;
  esac

  install_location="${git_root}"

  if [[ "${repo_index}" == "2" ]]; then
    detected_roots="$(detect_monorepo_roots "${git_root}" | tr '\n' ' ' | sed 's/ $//')"

    if [[ -n "${detected_roots}" ]]; then
      echo -e "  ${BOLD}Detected package folders:${NC} ${detected_roots}"
      if ! prompt_confirm "  Are they correct?"; then
        detected_roots="$(prompt_input "  Enter the package folders separated by spaces" "")"
      fi
    else
      detected_roots="$(prompt_input "  No package folders detected. Enter the folders separated by spaces" "packages")"
    fi
  fi

  # 3. Design
  log_step "Design tool"
  echo "  SDD uses Pencil as the default design tool."
  echo "  Make sure you have the Pencil MCP enabled in your editor/IDE"
  echo "  so the designer agent can interact with the artboards."

  # 4. Summary
  echo ""
  echo -e "${BOLD}Installation summary${NC}"
  echo -e "  ${BOLD}Destination:${NC} ${install_location}"
  echo -e "  ${BOLD}Repo type:${NC}   ${repo_label}"
  if [[ -n "${detected_roots}" ]]; then
    echo -e "  ${BOLD}Packages:${NC}    ${detected_roots}"
  fi
  echo -e "  ${BOLD}Design:${NC}      Pencil (check MCP)"
  echo ""

  if ! prompt_confirm "  Do you confirm the installation?"; then
    die "Installation cancelled by the user."
  fi

  INSTALL_LOCATION="${install_location}"
}

quick_configure() {
  local dest_dir="$1"
  local git_root
  local detected_roots

  git_root="$(ensure_git_root "${dest_dir}")" || die "No Git repository found in ${dest_dir}."
  INSTALL_LOCATION="${git_root}"

  detected_roots="$(detect_monorepo_roots "${git_root}" | tr '\n' ' ' | sed 's/ $//')"

  print_banner
  echo -e "${BOLD}Quick mode${NC}"
  echo -e "  ${BOLD}Destination:${NC} ${INSTALL_LOCATION}"
  echo -e "  ${BOLD}Type:${NC}        $([[ -n ${detected_roots} ]] && echo "Monorepo (${detected_roots})" || echo "Simple repo")"
  echo -e "  ${BOLD}Design:${NC}      Pencil (check MCP)"
  echo ""
}

# ─────────────────────────────────────────
# Installation
# ─────────────────────────────────────────

perform_install() {
  local dest_dir="$1"

  log_step "Installing SDD in ${dest_dir}..."

  CUSTOM_FILES=(
    "AGENTS.md"
    "CLAUDE.md"
  )

  if [[ "${UPDATE_MODE}" == true ]]; then
    for file in "${CUSTOM_FILES[@]}"; do
      if [[ -f "${dest_dir}/${file}" ]]; then
        backup="${dest_dir}/${file}.backup-$(date +%Y%m%d-%H%M%S)"
        cp "${dest_dir}/${file}" "${backup}"
        log_success "Backup created: ${backup}"
      fi
    done
  else
    for file in "${CUSTOM_FILES[@]}"; do
      if [[ -f "${dest_dir}/${file}" ]]; then
        log_warn "${file} already exists in ${dest_dir}."
      fi
    done

    if [[ -d "${dest_dir}/sdd" ]]; then
      log_warn "sdd/ already exists in ${dest_dir}."
      if ! prompt_confirm "  Overwrite?" "n"; then
        echo ""
        log_warn "Installation cancelled."
        exit 0
      fi
    fi
  fi

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
    dst="${dest_dir}/${item}"

    if [[ ! -e "${src}" ]]; then
      log_warn "${src} does not exist, skipping."
      continue
    fi

    if [[ -e "${dst}" ]]; then
      rm -rf "${dst}"
    fi

    cp -R "${src}" "${dst}"
    log_success "Copied ${item}"
  done

  chmod +x "${dest_dir}/init.sh"
  chmod +x "${dest_dir}/scripts/"*.sh 2>/dev/null || true
}

# ─────────────────────────────────────────
# Main
# ─────────────────────────────────────────

if [[ -n "${DEST_ARG}" ]]; then
  DEST_DIR="${DEST_ARG}"
else
  DEST_DIR="$(pwd)"
fi

if [[ ! -d "${DEST_DIR}" ]]; then
  die "Destination directory does not exist: ${DEST_DIR}"
fi

DEST_DIR="$(cd "${DEST_DIR}" && pwd)"

if [[ "${DEST_DIR}" == "${SCRIPT_DIR}" ]]; then
  die "Destination directory cannot be the same abel-sdd repo."
fi

if [[ "${QUICK_MODE}" == true ]]; then
  quick_configure "${DEST_DIR}"
else
  configure_installation "${DEST_DIR}"
fi

perform_install "${INSTALL_LOCATION}"

echo ""
log_success "Installation completed."
echo ""
echo -e "${BOLD}Next steps in the destination project:${NC}"
echo "  1. cd ${INSTALL_LOCATION}"
echo "  2. Fill out sdd/architecture.md with the project stack."
echo "  3. Fill out sdd/conventions.md with the project style and naming."
echo "  4. Verify that the Pencil MCP is enabled in your editor/IDE."
echo "  5. Run ./init.sh to verify the harness."
echo "  6. Create the first feature: ./scripts/sdd-worktree.sh create <feature-slug>"
echo ""

if prompt_confirm "  Do you want to run ./init.sh now?"; then
  (
    cd "${INSTALL_LOCATION}"
    ./init.sh
  )
fi
