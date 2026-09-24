#!/bin/bash
# =============================================================================
# Omarchy 4 (Arch Linux) setup script
# Run from the dotfiles-migration repo root
# IMPORTANT: Do NOT change the login shell from bash — it breaks Omarchy boot.
# =============================================================================
set -e

echo "=== Omarchy Migration Setup ==="

# -----------------------------------------------------------------------------
# System packages (pacman)
# -----------------------------------------------------------------------------
# Omarchy already ships base-devel, git, mise, ruby, rust, docker, github-cli,
# hyprland, starship, fzf, ripgrep, bat, eza, fd, jq, tmux, zoxide, lazygit,
# neovim, imagemagick, claude-code, unzip, libyaml, postgresql-libs, and more —
# see the package lists under /usr/share/omarchy/install/.
#
# Only list packages Omarchy does NOT ship by default.
PACMAN_PACKAGES=(
  tree             # not shipped
  go               # not shipped (Omarchy has rust but not go)
  postgresql       # Omarchy ships postgresql-libs only; we need the server
  xclip            # required by omarchy/bin/x11-clipboard-sync
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
# Omarchy's own ~/.config/mise/config.toml outranks ~/.tool-versions, so a
# runtime pinned in both stays on Omarchy's version outside a project.
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

# Claude Code config. Anything already on the machine is backed up first: the
# copy here is a restore point, not necessarily the newest version.
echo "-> Setting up Claude Code config..."
mkdir -p ~/.claude/rules
for item in CLAUDE.md rules; do
  if [ -e "$HOME/.claude/$item" ] && [ ! -L "$HOME/.claude/$item" ]; then
    cp -pR "$HOME/.claude/$item" "$HOME/.claude/$item.bak.$(date +%s)"
  fi
done
cp claude/CLAUDE.md ~/.claude/CLAUDE.md
cp claude/rules/*.md ~/.claude/rules/ 2>/dev/null || true

# RailsPilot toolkit (clone needs GitHub auth; non-fatal on failure)
TOOLKIT_DIR="$HOME/Code/railspilot/toolkit"
if [ ! -d "$TOOLKIT_DIR/.git" ]; then
  echo "-> Cloning RailsPilot toolkit..."
  mkdir -p "$HOME/Code/railspilot"
  git clone https://github.com/tute/railspilot-toolkit "$TOOLKIT_DIR" \
    || echo "   Toolkit clone failed (need repo access?) — skipping"
fi
if [ -d "$TOOLKIT_DIR/.claude" ]; then
  # Link the toolkit's skills, agents and commands one by one instead of
  # symlinking the directories: local skills stay visible, and a name owned by
  # both stays with the local copy. CLAUDE.md, settings.json and statusline.sh
  # are left alone — the personal versions above own those.
  # (The toolkit's own bin/install replaces all of it and hard-fails without
  # ~/.cursor, which is unused here.)
  echo "-> Linking RailsPilot toolkit skills, agents and commands into ~/.claude..."
  mkdir -p ~/.claude/skills ~/.claude/agents ~/.claude/commands
  linked=0
  kept=""
  for src in "$TOOLKIT_DIR"/.claude/skills/*/; do
    [ -d "$src" ] || continue
    name="$(basename "$src")"
    if [ -e "$HOME/.claude/skills/$name" ] || [ -L "$HOME/.claude/skills/$name" ]; then
      kept="$kept $name"
    else
      ln -s "$src" "$HOME/.claude/skills/$name"
      linked=$((linked + 1))
    fi
  done
  for src in "$TOOLKIT_DIR"/.claude/agents/*.md "$TOOLKIT_DIR"/.claude/commands/*.md; do
    [ -f "$src" ] || continue
    case "$src" in
      */agents/*) dest="$HOME/.claude/agents/$(basename "$src")" ;;
      *)          dest="$HOME/.claude/commands/$(basename "$src")" ;;
    esac
    { [ -e "$dest" ] || [ -L "$dest" ]; } || ln -s "$src" "$dest"
  done
  echo "   Linked $linked skills${kept:+, kept local:$kept}"
fi

# -----------------------------------------------------------------------------
# Omarchy desktop configs
# -----------------------------------------------------------------------------
# Omarchy's defaults load first and the user files override them, so only the
# delta is appended, inside a marker block that makes re-runs safe.
append_delta() {
  local source="$1" target="$2" comment="$3"
  local marker="$comment === dotfiles-migration ==="
  [ -f "$target" ] || return 0
  if grep -qF -- "$marker" "$target"; then
    echo "   $target — already applied, skipping"
    return 0
  fi
  {
    echo ""
    echo "$marker"
    cat "$source"
    echo "$comment === end dotfiles-migration ==="
  } >> "$target"
  echo "   $target — appended"
}

echo "-> Appending Hyprland overrides..."
for file in input looknfeel bindings autostart; do
  append_delta "omarchy/hypr/$file.lua" "$HOME/.config/hypr/$file.lua" "--"
done
# monitors.lua stays untouched: scale is per-machine.
hyprctl reload >/dev/null 2>&1 || true
if command -v hyprctl &>/dev/null; then
  errors="$(hyprctl configerrors 2>/dev/null)"
  [ -z "$errors" ] || printf "   Hyprland reported config errors:\n%s\n" "$errors"
fi

echo "-> Appending terminal overrides..."
append_delta omarchy/ghostty/config ~/.config/ghostty/config "#"
append_delta omarchy/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml "#"
append_delta omarchy/kitty/kitty.conf ~/.config/kitty/kitty.conf "#"
append_delta omarchy/foot/foot.ini ~/.config/foot/foot.ini "#"

# Systemd user services — only the ones this machine has no unit for already.
echo "-> Installing systemd user services..."
mkdir -p ~/.config/systemd/user
installed_units=""
for unit in omarchy/systemd/*.service; do
  name="$(basename "$unit")"
  if systemctl --user list-unit-files "$name" 2>/dev/null | grep -q "^$name"; then
    echo "   $name — system already provides it, skipping"
    continue
  fi
  cp "$unit" ~/.config/systemd/user/
  installed_units="$installed_units $name"
done
systemctl --user daemon-reload
echo "   Installed:${installed_units:- none}"

# Custom bin scripts
echo "-> Installing custom scripts..."
mkdir -p ~/.local/bin
install -m 755 omarchy/bin/* ~/.local/bin/

# VS Code (install manually, extensions)
echo ""
echo "-> VS Code extensions to install:"
echo "   code --install-extension anthropic.claude-code"
echo "   code --install-extension ritwickdey.liveserver"

echo ""
echo "=== Done! ==="
echo "Restart your terminal or run: source ~/.bashrc"
