#!/usr/bin/env bash
# =============================================================================
# Unified install dispatcher
#
# Software and dotfiles are kept SEPARATE:
#   macOS         -> install-software.sh (packages), THEN install-dotfiles.sh
#   Omarchy/Arch  -> install-omarchy.sh  (Omarchy already ships most software,
#                    so software + config stay in one script there)
#
# Usage (from the repo root):
#   ./scripts/install.sh                  # auto-detect, full setup
#   ./scripts/install.sh mac              # macOS: software + dotfiles (in order)
#   ./scripts/install.sh mac software     # macOS: software only
#   ./scripts/install.sh mac dotfiles     # macOS: dotfiles only
#   ./scripts/install.sh omarchy          # Omarchy / Arch Linux
# =============================================================================
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." &>/dev/null && pwd)"

detect_os() {
  case "$(uname -s)" in
    Darwin)
      echo "mac"
      ;;
    Linux)
      if [[ -f /etc/arch-release ]] || grep -qi "arch" /etc/os-release 2>/dev/null; then
        echo "omarchy"
      else
        echo "unsupported-linux"
      fi
      ;;
    *)
      echo "unsupported"
      ;;
  esac
}

TARGET="${1:-}"
PART="${2:-all}"
if [[ -z "$TARGET" ]]; then
  TARGET="$(detect_os)"
fi

case "$TARGET" in
  mac|macos|darwin)
    cd "$REPO_ROOT"
    case "$PART" in
      software)
        bash "$SCRIPT_DIR/install-software.sh"
        ;;
      dotfiles)
        bash "$SCRIPT_DIR/install-dotfiles.sh"
        ;;
      all|"")
        echo "=== macOS — software first, then dotfiles ==="
        bash "$SCRIPT_DIR/install-software.sh"
        bash "$SCRIPT_DIR/install-dotfiles.sh"
        ;;
      *)
        echo "ERROR: unknown part '$PART' (expected: software | dotfiles)" >&2
        exit 1
        ;;
    esac
    ;;
  omarchy|arch|linux)
    echo "=== Detected Omarchy/Arch Linux — running install-omarchy.sh ==="
    cd "$REPO_ROOT"
    exec bash "$SCRIPT_DIR/install-omarchy.sh"
    ;;
  unsupported-linux)
    echo "ERROR: Unsupported Linux distro. This repo targets Omarchy/Arch Linux." >&2
    echo "       Pass 'omarchy' explicitly to force, or run the sub-script directly." >&2
    exit 1
    ;;
  *)
    echo "ERROR: Unsupported OS ($TARGET). Expected macOS or Omarchy/Arch Linux." >&2
    exit 1
    ;;
esac
