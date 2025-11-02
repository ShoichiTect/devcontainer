# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Minimal plugins for Claude Code environment
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set language environment
export LANG=en_US.UTF-8

# Preferred editor (nano as fallback, can be changed)
export EDITOR='nano'

# Node.js (nvm) - Required for Claude Code
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

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
