# dotfiles: a laptop rebuilder

A one-command rebuilder for my omakase development setup on **macOS** and
**Omarchy (Arch Linux)**. Opinionated, reproducible, boring on purpose.

**Why this exists:** I accidentally wiped my hard drive. Rebuilding a dev
machine from memory is miserable, so I turned the recovery into a
repeatable script and made it public. If you just did the same thing,
maybe this saves your afternoon.

## What it does

Takes a freshly-wiped Mac (or Omarchy box) back to a known-good state:
package manager, CLI toolchain, GUI apps, language runtimes, shell,
editor, and all my config. Everything installs in the right order, is
idempotent, and is safe to re-run.

It restores your environment, not your data. Keep a real backup for the
latter.

## What's included

| Folder | Contents |
|---|---|
| `software/` | Brewfile: the software manifest (CLI formulae, GUI casks, Mac App Store apps) |
| `scripts/` | `install.sh` dispatcher plus `install-software.sh`, `install-dotfiles.sh` (mac), `install-omarchy.sh` |
| `shell/` | `.zshrc` (mac), `.bashrc` (Omarchy), `.tool-versions`, `secrets.env.example` |
| `git/` | `.gitconfig` and aliases (`co`, `br`, `st`, `pf`, `lola`, and more) |
| `claude/` | Global `CLAUDE.md` and rules for Claude Code |
| `bundler/`, `npm/`, `gh/` | Tool configs (credentials come from env, see Secrets) |
| `alacritty/`, `tmux/`, `hammerspoon/` | Terminal, multiplexer, macOS hotkeys |
| `macos/` | macOS LaunchAgents (Caps Lock → Control remap via hidutil) |
| `omarchy/` | Hyprland, waybar, walker, systemd, core patches |

## Quick start

```bash
git clone git@github.com:fedesapuppo/dotfiles-migration.git
cd dotfiles-migration
./scripts/install.sh                 # auto-detects macOS vs Omarchy
```

macOS keeps software and dotfiles separate. Two phases, run in order:

```bash
./scripts/install.sh mac             # software, then dotfiles
./scripts/install.sh mac software    # packages only (Homebrew + Brewfile + mise)
./scripts/install.sh mac dotfiles    # config only
./scripts/install.sh omarchy         # Omarchy / Arch (single script)
```

- **Software**: installs Homebrew, everything in
  [`software/Brewfile`](software/Brewfile), then Ruby and Node via mise
  (pinned in `shell/.tool-versions`).
- **Dotfiles**: copies config, installs Oh My Zsh plus plugins and
  LazyVim, seeds machine-local secrets, sets up the RailsPilot toolkit.

Omarchy stays a single script because it already ships most of the
toolchain, so only the delta is installed.

## Secrets

Nothing secret is committed. Keys, tokens, and identifying values live
only in a gitignored, machine-local `~/.secrets.env`, seeded from
[`shell/secrets.env.example`](shell/secrets.env.example) on first
install. Fill in your own values afterward (`ANTHROPIC_API_KEY`,
`ATLASSIAN_*`, `FMP_KEY`, `BONSAI_API_KEY`, `NPM_TOKEN`, `BUNDLE_*`).

Mac App Store apps (for example Outlook) need you signed in to the App
Store. Anything with no cask or mas entry is documented at the bottom of
the Brewfile.

## macOS keyboard shortcuts (Hammerspoon)

Omarchy/Hyprland-style global hotkeys, defined in `hammerspoon/init.lua`:

| Shortcut | Opens |
|---|---|
| ⌘ ↩ | Alacritty |
| ⌘ ⌥ ↩ | Alacritty + tmux |
| ⌘ ⇧ ↩ | Chrome |
| ⌘ ⇧ N | VS Code |
| ⌘ ⇧ E | Outlook |
| ⌘ ⇧ O | Obsidian |
| ⌘ ⇧ ⌥ G | WhatsApp |
| ⌘ ⇧ D | Docker |

Hammerspoon needs Accessibility permission (System Settings, Privacy and
Security, Accessibility) to register these.

## RailsPilot toolkit

The dotfiles phase also fetches a private toolkit and links it into
`~/.claude` (Claude config, skills, agents, statusline). It is optional
and skipped cleanly if you do not have access. The Cursor wiring is
intentionally skipped (unused here).

## If you also just wiped your drive

Been there. Clone this, run `./scripts/install.sh`, refill
`~/.secrets.env`, grab a coffee. Your environment comes back in one
command. Next time, take the backup first.
