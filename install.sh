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

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step() { echo -e "${BLUE}▶${NC} $*"; }

die() { log_error "$*"; exit 1; }

# ─────────────────────────────────────────
# i18n — CLI language (always English)
# ─────────────────────────────────────────

UI_LANGUAGE="en"

msg() {
  local key="$1"
  case "${key}" in
    help_usage)                echo "Usage: ./install.sh [options] [<path-to-destination-project>]" ;;
    help_description)          echo "Installs the SDD framework into an existing project." ;;
    help_step_1)               echo "Copies sdd/, scripts/, .claude/agents/, AGENTS.md, CLAUDE.md, and init.sh." ;;
    help_step_2)               echo "Does not touch the destination project's source code." ;;
    help_step_3)               echo "Ensures the destination is a Git repository, initializing one if needed." ;;
    help_step_4)               echo "Asks for the repo type (simple or monorepo)." ;;
    help_option_quick)         echo "Do not ask; detect automatically." ;;
    help_option_update)        echo "Overwrite without interaction and back up AGENTS.md and CLAUDE.md." ;;
    help_option_help)          echo "Show this help." ;;
    help_example)              echo "Example" ;;
    unknown_option)            echo "Unknown option" ;;
    use_help)                  echo "Use ./install.sh --help" ;;
    one_destination)           echo "Only one destination directory allowed" ;;
    dest_not_found)            echo "Destination directory does not exist" ;;
    dest_same_as_sdd)          echo "Destination directory cannot be the same abel-sdd repo" ;;
    no_git_repo)               echo "No Git repository found in" ;;
    sdd_requires_git)          echo "SDD requires a Git repo" ;;
    yes)                       echo "Y" ;;
    no)                        echo "N" ;;
    please_answer_y_n)         echo "Please answer Y or N." ;;
    invalid_option)            echo "Invalid option. Choose a number between" ;;
    and)                       echo "and" ;;
    welcome_title)             echo "SDD installer" ;;
    step_destination)          echo "1. Destination project" ;;
    git_repo_detected)         echo "Git repo detected" ;;
    is_this_correct)           echo "Is this directory correct?" ;;
    cancelled_by_user)         echo "Installation cancelled by the user" ;;
    step_repo_type)            echo "2. Repository type" ;;
    how_organize_sdd)          echo "How do you want to organize the SDD?" ;;
    repo_simple)               echo "Simple repo — single project at the root" ;;
    repo_monorepo_root)        echo "Monorepo — SDD at the root, features may cross packages" ;;
    repo_monorepo_package)     echo "Monorepo — SDD inside a specific package" ;;
    detected_package_folders)  echo "Detected package folders" ;;
    are_they_correct)          echo "Are they correct?" ;;
    enter_package_folders)     echo "Enter the package folders separated by spaces" ;;
    no_package_folders)        echo "No package folders detected. Enter the folders separated by spaces" ;;
    which_package)             echo "In which package do you want to install the SDD? (e.g. packages/web)" ;;
    package_not_found)         echo "Package does not exist in" ;;
    step_design)               echo "3. Design" ;;
    pencil_default_1)          echo "SDD uses Pencil as the default design tool." ;;
    pencil_default_2)          echo "Make sure you have the Pencil MCP enabled in your editor/IDE so the designer agent can interact with the artboards." ;;
    summary_title)             echo "Installation summary" ;;
    summary_destination)       echo "📁 Destination" ;;
    summary_repo_type)         echo "🏗️  Repo type" ;;
    summary_packages)          echo "📦 Packages" ;;
    summary_design)            echo "🎨 Design" ;;
    summary_pencil_mcp)        echo "Pencil (check MCP)" ;;
    confirm_installation)      echo "Do you confirm the installation?" ;;
    quick_mode_title)          echo "SDD installer — quick mode" ;;
    quick_mode_type)           echo "🏗️  Type" ;;
    installing)                echo "Installing SDD in" ;;
    backup_created)            echo "Backup created" ;;
    already_exists)            echo "already exists" ;;
    overwrite)                 echo "Overwrite?" ;;
    installation_cancelled)    echo "Installation cancelled" ;;
    copied)                    echo "Copied" ;;
    does_not_exist_skipping)   echo "does not exist, skipping" ;;
    team_language_prefilled)   echo "Team language pre-filled in sdd/conventions.md" ;;
    conventions_not_found)     echo "sdd/conventions.md not found; cannot pre-fill team language" ;;
    installation_completed)    echo "Installation completed" ;;
    next_steps)                echo "Next steps in the destination project" ;;
    next_step_1)               echo "cd" ;;
    next_step_2)               echo "Fill out sdd/architecture.md with the project stack." ;;
    next_step_3)               echo "Fill out sdd/conventions.md with the project style and naming." ;;
    next_step_4)               echo "Verify that the Pencil MCP is enabled in your editor/IDE." ;;
    next_step_5)               echo "Run ./init.sh to verify the harness." ;;
    next_step_6)               echo "Create the first feature" ;;
    run_init_now)              echo "Do you want to run ./init.sh now?" ;;
  esac
}

# ─────────────────────────────────────────
# CLI args
# ─────────────────────────────────────────

show_help() {
  cat <<EOF
$(msg help_usage)

$(msg help_description)

$(msg help_step_1)
$(msg help_step_2)
$(msg help_step_3)
$(msg help_step_4)

Options:
  --quick     $(msg help_option_quick)
  --update    $(msg help_option_update)
  --help      $(msg help_option_help)

$(msg help_example):
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
      die "$(msg unknown_option): ${arg}. $(msg use_help)"
      ;;
    *)
      if [[ -n "${DEST_ARG}" ]]; then
        die "$(msg one_destination). $(msg use_help)"
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
      read -rp "${message} [$(msg yes | tr '[:lower:]' '[:upper:]')/$(msg no | tr '[:upper:]' '[:lower:]')]: " input
      input="${input:-$(msg yes | tr '[:lower:]' '[:upper:]')}"
    else
      read -rp "${message} [$(msg yes | tr '[:upper:]' '[:lower:]')/$(msg no | tr '[:lower:]' '[:upper:]')]: " input
      input="${input:-$(msg no | tr '[:lower:]' '[:upper:]')}"
    fi

    case "${input}" in
      [yY]|"yes"|"YES"|"Yes"|[sS]|"si"|"SI"|"Si") return 0 ;;
      [nN]|"no"|"NO"|"No") return 1 ;;
      *) echo "$(msg please_answer_y_n)" ;;
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
    echo "  [$((i + 1))] ${options[$i]}"
  done

  while true; do
    read -rp "> " input
    if [[ "${input}" =~ ^[0-9]+$ ]] && [[ "${input}" -ge 1 && "${input}" -le ${#options[@]} ]]; then
      PROMPT_SELECT_RESULT="${input}"
      return 0
    fi
    echo "$(msg invalid_option) 1 $(msg and) ${#options[@]}."
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

  if git_root="$(detect_git_root "${dir}")"; then
    if [[ "${git_root}" == "${dir}" ]]; then
      echo "${git_root}"
      return 0
    fi
  fi

  echo "No Git repository found in ${dir}. Initializing one..." >&2
  if git init "${dir}" >/dev/null 2>&1; then
    echo "${dir}"
    return 0
  fi

  return 1
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

  echo ""
  echo "$(msg welcome_title)"
  echo "============="
  echo ""

  # 1. Destination project
  log_step "$(msg step_destination)"
  if ! git_root="$(ensure_git_root "${dest_dir}")"; then
    die "$(msg no_git_repo) ${dest_dir}. $(msg sdd_requires_git)."
  fi
  echo "   $(msg git_repo_detected): ${git_root}"

  if ! prompt_confirm "$(msg is_this_correct)" "y"; then
    die "$(msg cancelled_by_user)."
  fi

  # 2. Repository type
  log_step "$(msg step_repo_type)"
  prompt_select_index "$(msg how_organize_sdd)" \
    "$(msg repo_simple)" \
    "$(msg repo_monorepo_root)" \
    "$(msg repo_monorepo_package)"
  repo_index="${PROMPT_SELECT_RESULT}"

  case "${repo_index}" in
    1) repo_label="$(msg repo_simple)" ;;
    2) repo_label="$(msg repo_monorepo_root)" ;;
    3) repo_label="$(msg repo_monorepo_package)" ;;
  esac

  install_location="${git_root}"

  if [[ "${repo_index}" == "2" || "${repo_index}" == "3" ]]; then
    detected_roots="$(detect_monorepo_roots "${git_root}" | tr '\n' ' ' | sed 's/ $//')"

    if [[ -n "${detected_roots}" ]]; then
      echo "   $(msg detected_package_folders): ${detected_roots}"
      if ! prompt_confirm "$(msg are_they_correct)" "y"; then
        detected_roots="$(prompt_input "$(msg enter_package_folders)" "")"
      fi
    else
      detected_roots="$(prompt_input "$(msg no_package_folders)" "packages")"
    fi

    if [[ "${repo_index}" == "3" ]]; then
      package_dir="$(prompt_input "$(msg which_package)" "")"
      if [[ -z "${package_dir}" || ! -d "${git_root}/${package_dir}" ]]; then
        die "$(msg package_not_found) ${git_root}."
      fi
      install_location="${git_root}/${package_dir}"
    fi
  fi

  # 3. Design
  log_step "$(msg step_design)"
  echo "   $(msg pencil_default_1)"
  echo "   $(msg pencil_default_2)"
  echo ""

  # 4. Summary
  echo ""
  echo "$(msg summary_title)"
  echo "--------------------"
  echo "  $(msg summary_destination): ${install_location}"
  echo "  $(msg summary_repo_type): ${repo_label}"
  if [[ -n "${detected_roots}" ]]; then
    echo "  $(msg summary_packages): ${detected_roots}"
  fi
  echo "  $(msg summary_design): $(msg summary_pencil_mcp)"
  echo ""

  if ! prompt_confirm "$(msg confirm_installation)" "y"; then
    die "$(msg cancelled_by_user)."
  fi

  INSTALL_LOCATION="${install_location}"
}

quick_configure() {
  local dest_dir="$1"
  local git_root
  local detected_roots

  git_root="$(ensure_git_root "${dest_dir}")" || die "$(msg no_git_repo) ${dest_dir}."
  INSTALL_LOCATION="${git_root}"

  detected_roots="$(detect_monorepo_roots "${git_root}" | tr '\n' ' ' | sed 's/ $//')"

  echo ""
  echo "$(msg quick_mode_title)"
  echo "=========================="
  echo "  $(msg summary_destination): ${INSTALL_LOCATION}"
  echo "  $(msg quick_mode_type): $([[ -n ${detected_roots} ]] && echo "Monorepo (${detected_roots})" || echo "Simple repo")"
  echo "  $(msg summary_design): $(msg summary_pencil_mcp)"
  echo ""
}

# ─────────────────────────────────────────
# Installation
# ─────────────────────────────────────────

perform_install() {
  local dest_dir="$1"

  log_info "$(msg installing) ${dest_dir}..."

  CUSTOM_FILES=(
    "AGENTS.md"
    "CLAUDE.md"
  )

  if [[ "${UPDATE_MODE}" == true ]]; then
    for file in "${CUSTOM_FILES[@]}"; do
      if [[ -f "${dest_dir}/${file}" ]]; then
        backup="${dest_dir}/${file}.backup-$(date +%Y%m%d-%H%M%S)"
        cp "${dest_dir}/${file}" "${backup}"
        log_info "$(msg backup_created): ${backup}"
      fi
    done
  else
    for file in "${CUSTOM_FILES[@]}"; do
      if [[ -f "${dest_dir}/${file}" ]]; then
        log_warn "${file} $(msg already_exists) ${dest_dir}."
      fi
    done

    if [[ -d "${dest_dir}/sdd" ]]; then
      log_warn "sdd/ $(msg already_exists) ${dest_dir}."
      if ! prompt_confirm "$(msg overwrite)" "n"; then
        log_info "$(msg installation_cancelled)."
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
      log_warn "${src} $(msg does_not_exist_skipping)."
      continue
    fi

    if [[ -e "${dst}" ]]; then
      rm -rf "${dst}"
    fi

    cp -R "${src}" "${dst}"
    log_info "$(msg copied) ${item}"
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
  die "$(msg dest_not_found): ${DEST_DIR}"
fi

DEST_DIR="$(cd "${DEST_DIR}" && pwd)"

if [[ "${DEST_DIR}" == "${SCRIPT_DIR}" ]]; then
  die "$(msg dest_same_as_sdd)."
fi

if [[ "${QUICK_MODE}" == true ]]; then
  UI_LANGUAGE="en"
  quick_configure "${DEST_DIR}"
else
  configure_installation "${DEST_DIR}"
fi

perform_install "${INSTALL_LOCATION}"

log_info "$(msg installation_completed)."
echo ""
echo "$(msg next_steps):"
echo "  1. $(msg next_step_1) ${INSTALL_LOCATION}"
echo "  2. $(msg next_step_2)"
echo "  3. $(msg next_step_3)"
echo "  4. $(msg next_step_4)"
echo "  5. $(msg next_step_5)"
echo "  6. $(msg next_step_6): ./scripts/sdd-worktree.sh create <feature-slug>"
echo ""

if prompt_confirm "$(msg run_init_now)" "y"; then
  (
    cd "${INSTALL_LOCATION}"
    ./init.sh
  )
fi
