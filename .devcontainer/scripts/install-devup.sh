#!/bin/bash
# Installer for devup command
# This script adds devup to your shell configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEVUP_SCRIPT="${SCRIPT_DIR}/devup.sh"

# Detect shell configuration file
detect_shell_config() {
  if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    echo "$HOME/.zshrc"
  elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    echo "$HOME/.bashrc"
  elif [ -f "$HOME/.bash_profile" ]; then
    echo "$HOME/.bash_profile"
  else
    echo "$HOME/.zshrc"  # Default to zsh
  fi
}

SHELL_CONFIG="$(detect_shell_config)"
SOURCE_LINE="source '$DEVUP_SCRIPT'"

echo "🔍 Detected shell config: $SHELL_CONFIG"
echo "📄 devup script location: $DEVUP_SCRIPT"

# Check if already installed
if [ -f "$SHELL_CONFIG" ] && grep -qF "$SOURCE_LINE" "$SHELL_CONFIG" 2>/dev/null; then
  echo "✅ devup is already installed in $SHELL_CONFIG"
  echo ""
  echo "To use devup, make sure your shell is reloaded:"
  echo "  source $SHELL_CONFIG"
  exit 0
fi

# Backup existing config
if [ -f "$SHELL_CONFIG" ]; then
  BACKUP_FILE="${SHELL_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$SHELL_CONFIG" "$BACKUP_FILE"
  echo "📦 Backup created: $BACKUP_FILE"
fi

# Add devup to shell config
echo "" >> "$SHELL_CONFIG"
echo "# devup - Universal devcontainer launcher" >> "$SHELL_CONFIG"
echo "# Installed by: $DEVUP_SCRIPT" >> "$SHELL_CONFIG"
echo "$SOURCE_LINE" >> "$SHELL_CONFIG"

echo "✅ devup installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Reload your shell:"
echo "     source $SHELL_CONFIG"
echo "  2. Try devup:"
echo "     devup"
echo "     devup /path/to/project"
echo ""
echo "Requirements:"
echo "  - fzf: Install with 'brew install fzf' or 'apt install fzf'"
echo "  - @devcontainers/cli: Install with 'npm install -g @devcontainers/cli'"
