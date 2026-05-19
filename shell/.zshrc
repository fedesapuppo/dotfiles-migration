# Path
export PATH="/opt/homebrew/bin:$PATH"

# postgresql@16 is keg-only — expose psql/createdb/pg_ctl
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Mise
eval "$($HOME/.local/bin/mise activate zsh)"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# Plugins
plugins=(
  git
  rails
  ruby
  yarn
  branch
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export EDITOR="code --wait"

# #zstd
# export LDFLAGS="-L/opt/homebrew/opt/zstd/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/zstd/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/zstd/lib/pkgconfig"

# #openss1
# export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
# export OPENSSL_DIR=$(brew --prefix openssl@1.1)
# export LD_LIBRARY_PATH=/usr/local/opt/openssl@1.1/lib:$LD_LIBRARY_PATH

# # Ensure Ruby is compiled with openssl@1.1
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# #mysql client
# export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"

# #excecute ruby gems
# export PATH="/usr/local/lib/ruby/gems/3.3.0/bin:$PATH"

# Remove duplicate entries if present
export PATH=$HOME/development/flutter/bin:$PATH
PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: '!a[$0]++' | sed 's/:$//' )
export PATH=$PATH:/Users/fedesapuppo/Library/Android/sdk/platform-tools


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fedesapuppo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/fedesapuppo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/fedesapuppo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/fedesapuppo/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="$PATH:$HOME/google-cloud-sdk/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(~/.local/bin/mise activate zsh)"

# Worktree helpers
# Usage:
#   worktree <branch>         — create worktree, install deps, migrate
#   worktree list             — list all active worktrees
#   worktree delete <branch>  — remove worktree and delete local branch
worktree() {
  # Find the main repo root (not a worktree)
  local current_dir=$(pwd)
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -z "$repo_root" ]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # If we're in a worktree, find the main repo
  if [[ "$repo_root" == *"/.worktrees/"* ]]; then
    repo_root=$(dirname "$repo_root")
    while [[ ! -d "$repo_root/.worktrees" ]] && [ "$repo_root" != "/" ]; do
      repo_root=$(dirname "$repo_root")
    done
  fi

  case $1 in
    list)
      git worktree list
      ;;
    delete|-d)
      if [ -n "$WORKTREE_DB_PREFIX" ]; then
        echo "Dropping databases..."
        psql -U postgres -c "DROP DATABASE IF EXISTS \"${WORKTREE_DB_PREFIX}_development_$2\";"
        psql -U postgres -c "DROP DATABASE IF EXISTS \"${WORKTREE_DB_PREFIX}_test_$2\";"
      fi
      git -C "$repo_root" worktree remove --force .worktrees/$2
      (cd "$repo_root" && git branch -D $2)
      # Go back to main repo if currently in the deleted worktree
      if [[ "$current_dir" =~ "\.worktrees/$2" ]]; then
        cd "$repo_root"
      fi
      echo "✅ Deleted worktree, branch, and databases for $2"
      ;;
    *)
      cd "$repo_root"
      git worktree add ".worktrees/$1" -b "$1" "origin/${WORKTREE_BASE_BRANCH:-main}"
      [ -f "bin/setup-worktree" ] && (cd ".worktrees/$1" && bash "../../bin/setup-worktree" "$1")
      cd "$repo_root/.worktrees/$1"
      ;;
  esac
}

# Aliases — synced from Omarchy default/bash/aliases

# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias c='claude'
cx() { printf "\033[2J\033[3J\033[H"; claude --allow-dangerously-skip-permissions "$@"; }
alias d='docker'
alias r='rails'
alias t='tmux attach || tmux new -s Work'
n() { if [ "$#" -eq 0 ]; then command nvim . ; else command nvim "$@"; fi; }

# Tmux dev layouts (from Omarchy)
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }
  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1" ai2="$2"
  editor_pane="$TMUX_PANE"
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi
  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"
}

tdlm() {
  [[ -z $1 ]] && { echo "Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }
  local ai="$1" ai2="$2" base_dir="$PWD" first=true
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"
  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"
    if $first; then
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
      first=false
    else
      local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

tsl() {
  [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }
  local count="$1" cmd="$2" current_dir="${PWD}"
  local -a panes
  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
  panes+=("$TMUX_PANE")
  while (( ${#panes[@]} < count )); do
    local new_pane split_target="${panes[-1]}"
    new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[0]}" tiled
  done
  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" "$cmd" C-m
  done
  tmux select-pane -t "${panes[0]}"
}

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# Prompt
PROMPT='%~ $(git_prompt_info) '

# Locale
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# --- Secrets (NOT committed) ---
# API keys/tokens live in ~/.secrets.env (machine-local, gitignored).
# Template: shell/secrets.env.example. Provides:
#   ATLASSIAN_*, ANTHROPIC_API_KEY, FMP_KEY, BONSAI_API_KEY, NPM_TOKEN
[ -f "$HOME/.secrets.env" ] && source "$HOME/.secrets.env"

# Added by Antigravity
export PATH="/Users/fedesapuppo/.antigravity/antigravity/bin:$PATH"
