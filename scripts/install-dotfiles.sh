#!/bin/bash
# =============================================================================
# macOS — DOTFILES installer (config only; NO package installation)
#
# Copies shell/git/claude/etc. config, seeds machine-local secrets, installs
# Oh My Zsh + plugins + LazyVim, and sets up the RailsPilot toolkit.
#
# Assumes scripts/install-software.sh has already run (brew, mise, neovim...).
# Safe to run standalone for a config-only refresh.
# =============================================================================
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." &>/dev/null && pwd)"
cd "$REPO_ROOT"

# Put brew on PATH for any tool the steps below may call
if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi

echo "=== macOS Dotfiles Setup ==="

# Git
echo "-> Copying .gitconfig..."
cp git/.gitconfig ~/.gitconfig

# Shell (zsh)
echo "-> Copying .zshrc, .zshenv, .zprofile, .tool-versions..."
cp shell/.zshrc ~/.zshrc
cp shell/.zshenv ~/.zshenv
cp shell/.zprofile ~/.zprofile
cp shell/.tool-versions ~/.tool-versions

# Secrets (machine-local, never committed) — seed template if missing
if [ ! -f "$HOME/.secrets.env" ]; then
  echo "-> Seeding ~/.secrets.env from template (FILL IN real keys!)..."
  cp shell/secrets.env.example ~/.secrets.env
  chmod 600 ~/.secrets.env
fi

# Oh My Zsh (--keep-zshrc preserves the .zshrc we just copied)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "-> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# Zsh plugins
echo "-> Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ] && \
  git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"

# Bundler
echo "-> Copying bundler config..."
mkdir -p ~/.bundle
cp bundler/config ~/.bundle/config

# npm
echo "-> Copying .npmrc..."
cp npm/.npmrc ~/.npmrc

# gh CLI
echo "-> Copying gh CLI config..."
mkdir -p ~/.config/gh
cp gh/config.yml ~/.config/gh/config.yml
cp gh/hosts.yml ~/.config/gh/hosts.yml

# Claude Code
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

# Alacritty config
echo "-> Copying Alacritty config..."
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml

# LazyVim
if [ ! -d "$HOME/.config/nvim/lua" ]; then
  echo "-> Installing LazyVim..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
else
  echo "-> LazyVim already installed — skipping"
fi

# Tmux
echo "-> Copying tmux config..."
mkdir -p ~/.config/tmux
cp tmux/tmux.conf ~/.config/tmux/tmux.conf

# Hammerspoon
echo "-> Copying Hammerspoon config..."
mkdir -p ~/.hammerspoon
cp hammerspoon/init.lua ~/.hammerspoon/init.lua

# Keyboard remap: Caps Lock -> left Control (hidutil LaunchAgent, RunAtLoad)
echo "-> Installing Caps Lock -> Control LaunchAgent..."
mkdir -p ~/Library/LaunchAgents
cp macos/com.user.capslock-to-control.plist ~/Library/LaunchAgents/com.user.capslock-to-control.plist
launchctl bootout gui/"$(id -u)" ~/Library/LaunchAgents/com.user.capslock-to-control.plist 2>/dev/null || true
launchctl bootstrap gui/"$(id -u)" ~/Library/LaunchAgents/com.user.capslock-to-control.plist 2>/dev/null || true

echo ""
echo "=== Dotfiles done! Restart your terminal or run: source ~/.zshrc ==="
