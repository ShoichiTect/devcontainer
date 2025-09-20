#!/bin/bash

set -e

echo "🚀 Starting personal development environment setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're running as the vscode user
if [ "$(whoami)" != "vscode" ]; then
    print_error "This script should be run as the vscode user"
    exit 1
fi

# Copy dotfiles
print_status "Setting up dotfiles..."
cp /workspaces/devcontainer/dotfiles/.zshrc ~/.zshrc
cp /workspaces/devcontainer/dotfiles/.tmux.conf ~/.tmux.conf

# Create nvim config directory
mkdir -p ~/.config/nvim/lua/config
cp -r /workspaces/devcontainer/dotfiles/nvim/* ~/.config/nvim/

print_success "Dotfiles copied successfully"

# Install Tmux Plugin Manager
print_status "Installing Tmux Plugin Manager..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_success "TPM installed successfully"
else
    print_warning "TPM already installed"
fi

# Source the new zsh configuration
print_status "Sourcing zsh configuration..."
if [ -f ~/.zshrc ]; then
    source ~/.zshrc || true
    print_success "Zsh configuration sourced"
fi

# Install Node.js packages globally
print_status "Installing global Node.js packages..."
source ~/.nvm/nvm.sh
npm install -g \
    typescript \
    ts-node \
    @types/node \
    eslint \
    prettier \
    nodemon \
    npm-check-updates \
    create-react-app \
    @vue/cli \
    @angular/cli \
    vite

print_success "Global Node.js packages installed"

# Install Python packages
print_status "Installing Python packages..."
python3 -m pip install --user \
    black \
    flake8 \
    mypy \
    pytest \
    jupyter \
    requests \
    fastapi \
    uvicorn \
    django \
    flask

print_success "Python packages installed"

# Install Rust tools
print_status "Installing Rust tools..."
source ~/.cargo/env
cargo install \
    cargo-watch \
    cargo-edit \
    cargo-tree \
    ripgrep \
    fd-find \
    bat \
    exa

print_success "Rust tools installed"

# Install Go tools
print_status "Installing Go tools..."
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest

print_success "Go tools installed"

# Setup git configuration (if not already configured)
print_status "Checking git configuration..."
if ! git config --global user.name >/dev/null 2>&1; then
    print_warning "Git user.name not configured. Please run:"
    echo "git config --global user.name 'Your Name'"
fi

if ! git config --global user.email >/dev/null 2>&1; then
    print_warning "Git user.email not configured. Please run:"
    echo "git config --global user.email 'your.email@example.com'"
fi

# Configure git aliases and settings
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
git config --global core.editor nvim
git config --global init.defaultBranch main
git config --global pull.rebase false

print_success "Git aliases and settings configured"

# Install additional zsh completions
print_status "Installing additional zsh completions..."
mkdir -p ~/.oh-my-zsh/custom/completions

# Docker completion
if command -v docker >/dev/null 2>&1; then
    curl -fLo ~/.oh-my-zsh/custom/completions/_docker \
        https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
fi

# Docker-compose completion
if command -v docker-compose >/dev/null 2>&1; then
    curl -fLo ~/.oh-my-zsh/custom/completions/_docker-compose \
        https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose
fi

print_success "Additional completions installed"

# Create useful aliases file
print_status "Creating useful aliases..."
cat > ~/.zsh_aliases << 'EOF'
# Development aliases
alias ll='exa -la --git'
alias ls='exa'
alias cat='bat'
alias find='fd'
alias grep='rg'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --graph'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'

# Development servers
alias serve='python3 -m http.server'
alias pyserver='python3 -m http.server'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System
alias reload='source ~/.zshrc'
alias zshconfig='nvim ~/.zshrc'
alias tmuxconfig='nvim ~/.tmux.conf'
alias nvimconfig='nvim ~/.config/nvim/init.lua'

# Tmux
alias t='tmux'
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session'
EOF

# Add source line to .zshrc if not already present
if ! grep -q "source ~/.zsh_aliases" ~/.zshrc; then
    echo "source ~/.zsh_aliases" >> ~/.zshrc
fi

print_success "Aliases created and configured"

# Set up workspace directory structure
print_status "Setting up workspace directory structure..."
mkdir -p ~/workspace/{projects,sandbox,dotfiles,scripts}

print_success "Workspace structure created"

# Final message
print_success "✅ Personal development environment setup complete!"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Install tmux plugins: tmux new-session, then press Ctrl-a + I"
echo "3. Configure git: git config --global user.name 'Your Name'"
echo "4. Configure git: git config --global user.email 'your.email@example.com'"
echo "5. Start coding! 🎉"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "- tmux: Start terminal multiplexer"
echo "- nvim: Open Neovim editor"
echo "- opencode: Use Claude AI assistance"
echo "- t: Quick tmux alias"
echo "- ll: Enhanced ls with git status"
echo ""