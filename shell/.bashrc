# =============================================================================
# .bashrc for Omarchy (Linux/Arch)
# Translated from macOS .zshrc — append to existing ~/.bashrc
# =============================================================================

# Mise (already installed on Omarchy)
eval "$(mise activate bash)"

# Locale
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Personal aliases and functions
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Personal aliases (parity with .zshrc Tools section)
alias ov='overmind start -f Procfile.dev'

# --- Secrets (NOT committed) ---
# API keys/tokens live in ~/.secrets.env (machine-local, gitignored).
# Template: shell/secrets.env.example
[ -f "$HOME/.secrets.env" ] && source "$HOME/.secrets.env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# GO
export PATH="$HOME/go/bin:$PATH"

# postgresql@16 is keg-only — expose psql/createdb/pg_ctl
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# zoxide (smart cd)
eval "$(zoxide init bash --cmd cd)"
