#!/bin/bash
# =============================================================================
# macOS — SOFTWARE installer (packages & runtimes only; NO dotfiles)
#
# Installs Homebrew, everything in software/Brewfile (formulae, casks,
# Mac App Store apps), and the language runtimes pinned in
# shell/.tool-versions via mise.
#
# Run standalone, or via scripts/install.sh (which runs this BEFORE dotfiles).
# =============================================================================
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." &>/dev/null && pwd)"

echo "=== macOS Software Setup ==="

# 1. Homebrew ----------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "-> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# 2. Formulae + casks + App Store apps (order handled by brew) ---------------
echo "-> Installing software from software/Brewfile..."
brew bundle --file="$REPO_ROOT/software/Brewfile" \
  || echo "   Some Brewfile entries failed (App Store apps need App Store sign-in) — review output above"

# Clear the quarantine flag so Alacritty launches without a Gatekeeper prompt
xattr -d com.apple.quarantine /Applications/Alacritty.app 2>/dev/null || true

# 3. Language runtimes via mise ----------------------------------------------
# mise normally comes from the Brewfile; fall back to the installer if missing.
if ! command -v mise &>/dev/null; then
  echo "-> Installing mise (fallback)..."
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
echo "-> Installing language runtimes from .tool-versions (Ruby, Node)..."
cp "$REPO_ROOT/shell/.tool-versions" "$HOME/.tool-versions"   # also managed by install-dotfiles.sh
mise trust "$HOME/.tool-versions" 2>/dev/null || true
mise install || echo "   mise install had issues — review output above"

echo ""
echo "=== Software done. Next: scripts/install-dotfiles.sh (or use scripts/install.sh). ==="
