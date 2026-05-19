# CLAUDE.md

Guidance for Claude Code when working in this repo.

## What this repo is

Personal dotfiles + migration tooling for bootstrapping a new dev machine.
Supports two targets:

- **macOS** — zsh + Oh My Zsh, Homebrew for packages.
- **Omarchy (Arch Linux)** — bash (do NOT change login shell; it breaks
  Omarchy boot), pacman for packages, Hyprland desktop.

## Repo layout

| Path          | Purpose                                                   |
|---------------|-----------------------------------------------------------|
| `scripts/`    | `install.sh` dispatcher + `install-software.sh` / `install-dotfiles.sh` (mac) + `install-omarchy.sh` |
| `software/`   | `Brewfile` — macOS software manifest (formulae, casks, mas) |
| `shell/`      | `.zshrc` (mac), `.bashrc` (linux), `.tool-versions`, etc. |
| `git/`        | `.gitconfig` with aliases                                 |
| `claude/`     | Global CLAUDE.md + rules for Claude Code                  |
| `bundler/`    | Bundler config                                            |
| `npm/`        | `.npmrc`                                                  |
| `gh/`         | GitHub CLI config                                         |
| `alacritty/`  | macOS Alacritty config (Tokyo Night, JetBrains Mono Nerd) |
| `tmux/`       | tmux.conf synced from Omarchy                             |
| `hammerspoon/`| Hammerspoon global hotkeys (macOS Hyprland-style bindings) |
| `macos/`      | macOS LaunchAgents (e.g. Caps Lock → Control via hidutil) |
| `omarchy/`    | Hyprland, terminals, waybar, walker, systemd, core patches|

## Install flow

`scripts/install.sh` detects the OS and dispatches:

- `Darwin` → `scripts/install-software.sh`, then `scripts/install-dotfiles.sh`
  (software is always installed before config). Run one phase with
  `./scripts/install.sh mac software` or `./scripts/install.sh mac dotfiles`.
- Arch (`/etc/arch-release` or `arch` in `/etc/os-release`) → `scripts/install-omarchy.sh`

You can force a target: `./scripts/install.sh mac` or `./scripts/install.sh omarchy`.

**macOS keeps software separate from dotfiles** (two scripts). Omarchy
stays a single script because Omarchy pre-ships most of the toolchain.

### Package install rules

**Omarchy already ships a lot.** Before adding a package to
`PACMAN_PACKAGES` in `scripts/install-omarchy.sh`, check:

- `~/.local/share/omarchy/install/omarchy-base.packages`
- `~/.local/share/omarchy/install/omarchy-other.packages`

If Omarchy ships it, do NOT add it to the list. The list should contain
only the delta. Today that delta is just `tree`, `go`, `postgresql`
(Omarchy ships `postgresql-libs` only). `claude-code` is shipped by
Omarchy via pacman — the npm install step is a fallback only.

**macOS** has no preinstalled dev toolchain. `install-software.sh`
bootstraps Homebrew and applies `software/Brewfile` (formulae, casks,
Mac App Store apps). Add/remove software by editing the Brewfile — never
hardcode package lists in the script.

## Conventions when editing

- **Idempotency**: every install step must be re-runnable. Use
  `pacman -S --needed`, `brew install` (already idempotent),
  `[ -d ... ] || clone`, and grep-guards before appending to rc files.
- **Never change the Omarchy login shell.** Bash is required; shell config
  gets appended to `~/.bashrc` behind a `# === dotfiles-migration ===`
  sentinel block.
- **No secrets in this repo — it is public.** All keys/tokens and
  identifying config live only in machine-local `~/.secrets.env`
  (gitignored), sourced by the shell rc files. If you add a new
  variable, add it to `shell/secrets.env.example` and the "Secrets"
  section in `README.md`. Never hardcode a credential here.
- **Don't duplicate work between mac and omarchy.** Shared steps (copying
  `git/.gitconfig`, `bundler/config`, `npm/.npmrc`, `gh/`, `claude/`)
  should stay structurally identical across both scripts — if you change
  one, mirror it in the other.
- **Shell config parity**: `.zshrc` (mac) and `.bashrc` (omarchy) are
  translations of each other. When adding env vars / aliases / functions,
  add to both.
- **Omarchy core patches**: custom tweaks to upstream Omarchy live in
  `omarchy/omarchy-core-changes.patch` and are applied via
  `git apply --3way` against `~/.local/share/omarchy`. Regenerate the
  patch if you change anything there.

## Testing changes

Before committing shell-script changes:

```bash
bash -n scripts/install.sh
bash -n scripts/install-software.sh
bash -n scripts/install-dotfiles.sh
bash -n scripts/install-omarchy.sh
```

Full runs should happen on a disposable VM / fresh user — don't
"test" by re-running on the active machine unless the change is
narrowly scoped and idempotent.

## Commit style

Match existing history: imperative subject, body explains *why*, not
*what*. Recent examples:

- `Add Omarchy desktop configs and sync all dotfiles after v3.5.0 update`
- `Fix Ruby 3.3.x build on Arch Linux with system Ruby 3.4+`
