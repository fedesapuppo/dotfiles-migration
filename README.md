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
| `omarchy/` | Hyprland (`hypr-lua/` for Omarchy 4, `hypr/` for older), waybar, walker, systemd, core patches |

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

## Omarchy 4

Omarchy 4 configures Hyprland in Lua and replaced waybar and walker with
the Omarchy shell. The script detects which generation it is on:

- `~/.config/hypr/hyprland.lua` present: the deltas in
  `omarchy/hypr-lua/` are appended to the matching user file, inside a
  `dotfiles-migration` marker block. Omarchy's defaults load first, so
  only the delta is carried here. Re-runs skip a file that already has
  the block.
- Older `.conf` layout: the full files in `omarchy/hypr/` are copied, as
  before.

`monitors.lua` is never touched, because display scale is per-machine.
waybar and walker configs are copied only when those binaries exist, and
a systemd unit is installed only when the system has no unit of that
name. The core patch applies only to a git checkout in
`~/.local/share/omarchy`; Omarchy 4 installs to `/usr/share/omarchy`,
which is package-owned and must not be edited.

What the Lua deltas change: Caps Lock to Control with compose on Right
Alt, faster key repeat, mouse sensitivity, zero gaps with a 1px border,
SUPER+SHIFT+S for screenshots (Omarchy 4 gives that key to Google Maps),
and the X11 clipboard bridge on autostart. Every other binding in the
old `bindings.conf` is an Omarchy 4 default already.

## Shell

`cd` is zoxide. Type part of a directory name from anywhere and it jumps
to the best match (`cd dotfiles`, `cd medu`); real paths, `cd ..`, and
`cd -` still behave normally. zoxide ranks by frecency and learns the
directories you visit, so the database starts empty on a fresh install:
`cd <keyword>` jumps only kick in once you have been somewhere at least
once. `cdi` opens an interactive picker.

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

The dotfiles phase also fetches the toolkit into
`~/Code/railspilot/toolkit` and links its skills, agents and commands
into `~/.claude`, one entry at a time. Local skills stay visible, and a
name that both sides own stays with the local copy. `CLAUDE.md`,
`settings.json` and `statusline.sh` are left alone: the personal copies
in `claude/` own those. It is optional and skipped cleanly if you do not
have access. The toolkit's own `bin/install` replaces all of it and
hard-fails without `~/.cursor`, so it is not used here.

## If you also just wiped your drive

Been there. Clone this, run `./scripts/install.sh`, refill
`~/.secrets.env`, grab a coffee. Your environment comes back in one
command. Next time, take the backup first.
