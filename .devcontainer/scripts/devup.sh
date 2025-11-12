#!/bin/bash
# devup - Universal devcontainer launcher with AI assistant selection
# Usage: devup [directory]

export DEVUP_AI_COMMANDS=("claude" "groq")

devup() {
  local TARGET_DIR="${1:-.}"
  TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

  if [ ! -d "$TARGET_DIR/.devcontainer" ]; then
    echo "Error: No .devcontainer found in $TARGET_DIR"
    return 1
  fi

  # fzf でコマンドを選択
  local SELECTED_CMD=$(printf '%s\n' "${DEVUP_AI_COMMANDS[@]}" | fzf \
    --prompt="🤖 Select AI assistant: " \
    --height=40% \
    --border=rounded \
    --preview="echo 'Launch {} in devcontainer'" \
    --preview-window=up:3:wrap)

  if [ -z "$SELECTED_CMD" ]; then
    echo "❌ No command selected. Exiting."
    return 1
  fi

  echo "🚀 Starting devcontainer with $SELECTED_CMD..."

  local CONTAINER_INFO=$(devcontainer up --workspace-folder "$TARGET_DIR" 2>&1)
  local CONTAINER_ID=$(echo "$CONTAINER_INFO" | grep -o '"containerId":"[^"]*"' | head -1 | cut -d'"' -f4)
  local REMOTE_WORKSPACE=$(echo "$CONTAINER_INFO" | grep -o '"remoteWorkspaceFolder":"[^"]*"' | head -1 | cut -d'"' -f4)

  if [ -z "$REMOTE_WORKSPACE" ]; then
    echo "⚠️  Warning: Could not determine remote workspace folder"
    REMOTE_WORKSPACE="/workspaces/$(basename "$TARGET_DIR")"
  fi

  devcontainer exec --workspace-folder "$TARGET_DIR" zsh -i -c "cd '$REMOTE_WORKSPACE' && $SELECTED_CMD"
}

# スクリプトとして直接実行された場合
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  devup "$@"
fi
