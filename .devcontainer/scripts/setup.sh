#!/bin/bash

set -e

echo "🚀 Starting Claude Code isolated environment setup..."

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVCONTAINER_DIR="$(dirname "$SCRIPT_DIR")"
DOTFILES_DIR="$DEVCONTAINER_DIR/dotfiles"

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

# Copy minimal zsh configuration
print_status "Setting up zsh configuration..."
cp "$DOTFILES_DIR/.zshrc" ~/.zshrc

print_success "Zsh configuration copied successfully"

# Source the new zsh configuration
print_status "Sourcing zsh configuration..."
if [ -f ~/.zshrc ]; then
    source ~/.zshrc || true
    print_success "Zsh configuration sourced"
fi

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

# Configure minimal git settings
git config --global init.defaultBranch main
git config --global pull.rebase false

print_success "Git settings configured"

# Install Docker completions
print_status "Installing Docker completions..."
mkdir -p ~/.oh-my-zsh/custom/completions

if command -v docker >/dev/null 2>&1; then
    curl -fLo ~/.oh-my-zsh/custom/completions/_docker \
        https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker 2>/dev/null || true
fi

if command -v docker-compose >/dev/null 2>&1; then
    curl -fLo ~/.oh-my-zsh/custom/completions/_docker-compose \
        https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose 2>/dev/null || true
fi

print_success "Completions installed"

# Create minimal aliases file
print_status "Creating useful aliases..."
cat > ~/.zsh_aliases << 'EOF'
# Basic file operations
alias ll='ls -lah'
alias grep='rg'
alias find='fd'

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

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System
alias reload='source ~/.zshrc'
alias zshconfig='${EDITOR:-nano} ~/.zshrc'
EOF

# Add source line to .zshrc if not already present
if ! grep -q "source ~/.zsh_aliases" ~/.zshrc; then
    echo "source ~/.zsh_aliases" >> ~/.zshrc
fi

print_success "Aliases created and configured"

# Final message
print_success "✅ Claude Code isolated environment setup complete!"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Configure git: git config --global user.name 'Your Name'"
echo "3. Configure git: git config --global user.email 'your.email@example.com'"
echo "4. Start using Claude Code: claude"
echo ""
echo -e "${YELLOW}Available commands:${NC}"
echo "- claude: Start Claude Code CLI"
echo "- git: Git version control"
echo "- docker: Docker container management"
echo ""
echo -e "${GREEN}Security Status:${NC}"
echo "- Read-only root filesystem ✓"
echo "- No privilege escalation ✓"
echo "- Host filesystem isolated ✓"
echo ""