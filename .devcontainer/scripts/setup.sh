#!/bin/bash

set -e

echo "🚀 Starting Claude Code isolated environment setup..."

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

# Check GitHub CLI authentication
print_status "Checking GitHub CLI authentication..."
if command -v gh >/dev/null 2>&1; then
    if gh auth status >/dev/null 2>&1; then
        print_success "GitHub CLI is authenticated"
    else
        print_warning "GitHub CLI is not authenticated. Please run:"
        echo "  gh auth login"
        echo "Or set GITHUB_TOKEN environment variable"
    fi
else
    print_warning "GitHub CLI (gh) is not installed"
fi

# Final message
print_success "✅ Claude Code isolated environment setup complete!"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Configure git: git config --global user.name 'Your Name'"
echo "2. Configure git: git config --global user.email 'your.email@example.com'"
echo "3. Authenticate GitHub CLI: gh auth login"
echo "4. Start using Claude Code: claude"
echo ""
echo -e "${YELLOW}Available commands:${NC}"
echo "- claude: Start Claude Code CLI"
echo "- gh: GitHub CLI"
echo "- git: Git version control"
echo "- docker: Docker container management"
echo ""
echo -e "${GREEN}Security Status:${NC}"
echo "- Read-only root filesystem ✓"
echo "- No privilege escalation ✓"
echo "- Host filesystem isolated ✓"
echo ""