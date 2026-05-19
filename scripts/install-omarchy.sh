#!/bin/bash
# =============================================================================
# Omarchy (Arch Linux) setup script
# Run from the dotfiles-migration repo root
# IMPORTANT: Do NOT change the login shell from bash — it breaks Omarchy boot.
# =============================================================================
set -e

echo "=== Omarchy Migration Setup ==="

# -----------------------------------------------------------------------------
# System packages (pacman)
# -----------------------------------------------------------------------------
# Omarchy already ships base-devel, git, mise, ruby, rust, docker, github-cli,
# hyprland, waybar, alacritty, starship, fzf, ripgrep, bat, eza, fd, jq, tmux,
# zoxide, lazygit, neovim, imagemagick, omarchy-walker, claude-code, unzip,
# libyaml, postgresql-libs, and more — see:
#   ~/.local/share/omarchy/install/omarchy-base.packages
#   ~/.local/share/omarchy/install/omarchy-other.packages
#
# Only list packages Omarchy does NOT ship by default.
PACMAN_PACKAGES=(
  tree             # not shipped
  go               # not shipped (Omarchy has rust but not go)
  postgresql       # Omarchy ships postgresql-libs only; we need the server
)

if command -v pacman &>/dev/null && (( ${#PACMAN_PACKAGES[@]} )); then
  echo "-> Installing extra pacman packages (sudo required): ${PACMAN_PACKAGES[*]}"
  sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
else
  echo "-> No extra pacman packages to install"
fi

# Git
echo "-> Copying .gitconfig..."
cp git/.gitconfig ~/.gitconfig

# Shell (bash — Omarchy native)
echo "-> Appending shell config to ~/.bashrc..."
if ! grep -q "# === dotfiles-migration ===" ~/.bashrc 2>/dev/null; then
  echo "" >> ~/.bashrc
  echo "# === dotfiles-migration ===" >> ~/.bashrc
  cat shell/.bashrc >> ~/.bashrc
  echo "# === end dotfiles-migration ===" >> ~/.bashrc
  echo "   Appended to ~/.bashrc"
else
  echo "   Already applied — skipping (remove the block manually to re-apply)"
fi

# Tool versions (mise)
echo "-> Copying .tool-versions..."
cp shell/.tool-versions ~/.tool-versions

# Install languages via mise
# Ruby 3.3.x build requires 'erb' gem on system Ruby 3.4+ (removed from default gems)
echo "-> Ensuring erb gem is available for Ruby build..."
gem install erb 2>/dev/null || true

echo "-> Installing languages from .tool-versions..."
mise install

# Bundler
echo "-> Copying bundler config..."
mkdir -p ~/.bundle
cp bundler/config ~/.bundle/config

# npm
echo "-> Copying .npmrc..."
cp npm/.npmrc ~/.npmrc

# gh CLI (already installed on Omarchy)
echo "-> Copying gh CLI config..."
mkdir -p ~/.config/gh
cp gh/config.yml ~/.config/gh/config.yml
cp gh/hosts.yml ~/.config/gh/hosts.yml
echo "   Run 'gh auth login' to re-authenticate if needed"

# Claude Code (Omarchy ships the `claude-code` pacman package — only install
# via npm if something is off and the binary is missing)
if ! command -v claude &>/dev/null; then
  echo "-> claude binary not found — installing via npm as fallback..."
  npm install -g @anthropic-ai/claude-code
fi

echo "-> Setting up Claude Code config..."
mkdir -p ~/.claude/rules
cp claude/CLAUDE.md ~/.claude/CLAUDE.md
cp claude/rules/*.md ~/.claude/rules/ 2>/dev/null || true

# RailsPilot toolkit (private repo — clone needs GitHub auth; non-fatal on failure)
TOOLKIT_DIR="$HOME/Code/railspilot/toolkit"
if [ ! -d "$TOOLKIT_DIR/.git" ]; then
  echo "-> Cloning RailsPilot toolkit..."
  mkdir -p "$HOME/Code/railspilot"
  git clone https://github.com/tute/railspilot-toolkit "$TOOLKIT_DIR" \
    || echo "   Toolkit clone failed (need repo access?) — skipping"
fi
if [ -d "$TOOLKIT_DIR/.claude" ]; then
  # The toolkit's own bin/install also wires up Cursor and hard-fails
  # (set -eu) on machines without ~/.cursor. Cursor is unused here, so
  # link just the Claude side, skipping the Cursor step entirely.
  echo "-> Linking RailsPilot toolkit into ~/.claude (Cursor step skipped)..."
  mkdir -p ~/.claude
  for item in CLAUDE.md agents settings.json skills statusline.sh; do
    if [ -e "$HOME/.claude/$item" ] && [ ! -L "$HOME/.claude/$item" ]; then
      cp -pR "$HOME/.claude/$item" "$HOME/.claude/$item.pre-toolkit.bak" 2>/dev/null || true
    fi
    ln -sfn "$TOOLKIT_DIR/.claude/$item" "$HOME/.claude/$item"
  done
fi

# Omarchy desktop configs
echo "-> Copying Omarchy desktop configs..."
mkdir -p ~/.config/hypr ~/.config/ghostty ~/.config/alacritty ~/.config/kitty ~/.config/waybar ~/.config/walker
cp omarchy/hypr/*.conf ~/.config/hypr/
cp omarchy/ghostty/config ~/.config/ghostty/
cp omarchy/alacritty/alacritty.toml ~/.config/alacritty/
cp omarchy/kitty/kitty.conf ~/.config/kitty/
cp omarchy/waybar/config.jsonc ~/.config/waybar/
cp omarchy/waybar/style.css ~/.config/waybar/
cp omarchy/walker/config.toml ~/.config/walker/

# Systemd user services
echo "-> Installing systemd user services..."
mkdir -p ~/.config/systemd/user
cp omarchy/systemd/*.service ~/.config/systemd/user/
systemctl --user daemon-reload

# Custom bin scripts
echo "-> Installing custom scripts..."
mkdir -p ~/.local/bin
cp omarchy/bin/x11-clipboard-sync ~/.local/bin/
chmod +x ~/.local/bin/x11-clipboard-sync

# Omarchy core patches (custom modifications to upstream)
echo "-> Applying Omarchy core patches..."
if [[ -d ~/.local/share/omarchy/.git ]]; then
  cd ~/.local/share/omarchy
  git apply --3way "$OLDPWD/omarchy/omarchy-core-changes.patch" 2>/dev/null && echo "   Patch applied" || echo "   Patch had conflicts — review manually"
  cd "$OLDPWD"
else
  echo "   Skipping (omarchy not installed or not a git repo)"
fi

# VS Code (install manually, extensions)
echo ""
echo "-> VS Code extensions to install:"
echo "   code --install-extension anthropic.claude-code"
echo "   code --install-extension ritwickdey.liveserver"

echo ""
echo "=== Done! ==="
echo "Restart your terminal or run: source ~/.bashrc"
