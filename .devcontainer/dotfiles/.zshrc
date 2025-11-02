# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Plugins to load
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-z
    docker
    docker-compose
    npm
    pip
    python
    rust
    golang
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set language environment
export LANG=en_US.UTF-8

# Preferred editor
export EDITOR='nvim'

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Node.js (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Go
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Python
export PATH="$HOME/.local/bin:$PATH"

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Aliases
alias ll='exa -la --git'
alias ls='exa'
alias cat='bat'
alias find='fd'
alias grep='rg'
alias vim='nvim'
alias vi='nvim'

# Git aliases
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gp='git push'
alias gl='git pull'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Development aliases
alias py='python3'
alias pip='python3 -m pip'
alias code='code-insiders'

# Tmux aliases
alias t='tmux'
alias ta='tmux attach'
alias tl='tmux list-sessions'

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Load opencode if available
if command -v opencode &> /dev/null; then
    eval "$(opencode completion zsh)"
fi

# Set terminal title
precmd() {
    print -Pn "\e]0;%n@%m: %~\a"
}

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
