# Claude Code Isolated Environment

🔒 A minimal, secure devcontainer template for running Claude Code AI agent in an isolated environment.

## 🎯 Purpose

This template provides a sandboxed container environment where AI agents like Claude Code can safely execute commands without access to your host filesystem. Perfect for:
- Running AI-assisted coding tools in isolation
- Preventing accidental host system modifications
- Secure development environments for untrusted code execution
- Testing and experimentation with AI code generation

## 🛠️ Included Tools

### Core Requirements
- **Node.js** (via nvm) - Required for Claude Code CLI
- **Claude Code CLI** - Anthropic's AI coding assistant
- **Git** - Version control
- **Docker** (Docker-in-Docker) - Container management

### Shell Environment
- **zsh** with **oh-my-zsh** - Enhanced shell experience
- **ripgrep**, **fd-find** - Fast search tools (used by Claude Code)

### Optional Tools
- **pnpm** - Fast Node.js package manager
- **jq** - JSON processor
- **unzip** - Archive extraction

## 📁 Project Structure

```
devcontainer/
├── .devcontainer/
│   ├── devcontainer.json    # Container configuration with security settings
│   ├── Dockerfile          # Minimal container image definition
│   ├── dotfiles/
│   │   └── .zshrc          # Minimal zsh configuration
│   └── scripts/
│       └── setup.sh        # Automated setup script
└── README.md              # This file
```

## 🚀 Quick Start

### Option 1: Use as a Template

1. **Copy `.devcontainer` to your project**
```bash
cp -r /path/to/this/repo/.devcontainer /path/to/your/project/
```

2. **Open your project in VS Code**
```bash
cd /path/to/your/project
code .
```

3. **Reopen in Container**
- Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
- Type "Remote-Containers: Reopen in Container"
- Wait for the container to build and start

### Option 2: Use This Repository Directly

1. **Clone this repository**
```bash
git clone <your-repo-url>
cd devcontainer
```

2. **Open in VS Code**
```bash
code .
```

3. **Reopen in Container**
- Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
- Type "Remote-Containers: Reopen in Container"
- Wait for the container to build and start

### Option 3: CLI Only (Without VS Code)

```bash
# Install devcontainer CLI
npm install -g @devcontainers/cli

# Start the container
devcontainer up --workspace-folder /path/to/your/project

# Enter the container
devcontainer exec --workspace-folder /path/to/your/project zsh
```

## 🚀 Claude Dev Command (Recommended)

For the easiest experience, add this function to your `~/.zshrc`:

```bash
# Claude Code devcontainer launcher
claude-dev() {
  local TARGET_DIR="${1:-.}"
  TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

  if [ ! -d "$TARGET_DIR/.devcontainer" ]; then
    echo "Error: No .devcontainer found in $TARGET_DIR"
    return 1
  fi

  local CONTAINER_INFO=$(devcontainer up --workspace-folder "$TARGET_DIR" 2>&1)
  local CONTAINER_ID=$(echo "$CONTAINER_INFO" | grep -o '"containerId":"[^"]*"' | head -1 | cut -d'"' -f4)

  devcontainer exec --workspace-folder "$TARGET_DIR" zsh -i -c "cd /workspaces/$(basename "$TARGET_DIR") && claude"
}
```

After adding the function, reload your shell:
```bash
source ~/.zshrc
```

### Usage

```bash
# Navigate to any project with .devcontainer
cd /path/to/your/project
claude-dev

# Or specify a directory
claude-dev /path/to/another/project
```

### What it does
1. ✅ Checks if `.devcontainer` exists in the target directory
2. ✅ Starts the devcontainer (or connects to existing one)
3. ✅ Automatically launches Claude Code CLI inside the container
4. ✅ Works with any project that has a `.devcontainer` directory

## ⚙️ Configuration Details

### Zsh Configuration
- **Theme**: robbyrussell (oh-my-zsh default)
- **Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting, docker
- **Aliases**: Basic git, docker, and navigation aliases (see setup.sh)
- **History**: Enhanced history management with deduplication

### Claude Code CLI
- Installed globally via npm: `@anthropic-ai/claude-code`
- Accessible via `claude` command
- Configuration stored in `/home/vscode/.claude/` (persisted in volume)

## 🔧 Customization

### Adding More Tools
1. Update the Dockerfile to install additional packages
2. Modify setup.sh to configure new tools
3. Rebuild the container

### Custom Dotfiles
Replace `.devcontainer/dotfiles/.zshrc` with your own zsh configuration.

### VS Code Extensions
Modify the `extensions` array in `.devcontainer/devcontainer.json`.

## 📦 Available Aliases

Aliases are automatically created by setup.sh:

### File Operations
- `ll` → `ls -lah` (detailed list)
- `grep` → `rg` (ripgrep)
- `find` → `fd` (fd-find)

### Git
- `g` → `git`
- `gs` → `git status`
- `ga` → `git add`
- `gc` → `git commit`
- `gp` → `git push`
- `gl` → `git pull`
- `glog` → `git log --oneline --graph`

### Docker
- `d` → `docker`
- `dc` → `docker-compose`
- `dps` → `docker ps`
- `di` → `docker images`
- `dex` → `docker exec -it`

## 🛡️ Security Features

### Sandboxing
- **Read-only root filesystem**: System files cannot be modified
- **No privilege escalation**: `--security-opt=no-new-privileges` prevents sudo
- **Dropped capabilities**: All Linux capabilities removed with `--cap-drop=ALL`
- **Isolated workspace**: Only project directory is mounted, host filesystem is inaccessible

### Access Control
- **SSH keys**: Mounted as read-only from host
- **Git config**: Copied from host (modifiable in container)
- **Environment variables**: Host `.env` file is isolated; container uses empty `.env.template`
- **No host access**: Container cannot access files outside project directory
- **Separate user**: Runs as `vscode` user, not root

### Data Persistence
- **Volume mount**: `/home/vscode` persisted in named volume
- **Claude Code settings**: Saved in volume (survives container restarts)
- **No secrets in image**: SSH keys and configs mounted at runtime only

## 🎯 Use Cases

This template is perfect for:
- **AI-Assisted Development** - Run Claude Code safely in isolation
- **Untrusted Code Execution** - Test or run code without host access
- **Secure Development** - Prevent accidental system modifications
- **Learning & Experimentation** - Safe environment for trying new tools
- **Multi-Project Setup** - Copy `.devcontainer/` to any project for instant isolation

## 🔄 Port Forwarding

The following ports are automatically forwarded:
- `3000` - Common development server port
- `8000` - Python/Django development server
- `8080` - Alternative web server port
- `5173` - Vite development server

## 📝 Tips & Tricks

### Using Claude Code
```bash
# Start Claude Code CLI
claude

# Claude Code will have access to:
# - Project files in the workspace
# - Git commands
# - Docker commands
# - Installed Node.js tools
```

### Security Verification
```bash
# Verify read-only root filesystem
touch /test.txt  # Should fail with "Read-only file system"

# Verify workspace access
touch ~/test.txt  # Should succeed (volume is writable)
cd /workspaces && touch test.txt  # Should succeed (workspace is writable)

# Verify no host access
ls /Users  # Should fail or show empty (not host /Users)

# Verify .env isolation
cat .env  # Should show empty template (not host .env with secrets)
```

### Development Workflow
1. Copy `.devcontainer/` to your project
2. Run `devcontainer up --workspace-folder .`
3. Enter container and start Claude Code
4. Work safely in isolated environment

## 🤝 Contributing

Contributions welcome! Areas for improvement:
- Additional security hardening
- Performance optimizations
- Documentation improvements
- Bug fixes

## 📄 License

This template is open source. Feel free to use and modify as needed.

## ⚠️ Limitations

- Container has no access to host filesystem outside project directory
- Cannot install system packages at runtime (read-only root)
- Limited to tools installed in Dockerfile
- Volume data persists between restarts but can be lost if volume is deleted

## 🔍 Troubleshooting

### Claude Code not found
```bash
# Verify installation
which claude
npm list -g @anthropic-ai/claude-code

# Reinstall if needed
npm install -g @anthropic-ai/claude-code
```

### Permission denied errors
- Check if trying to write to read-only filesystem
- Use `/home/vscode` or `/workspaces` for writable areas

### Container won't start
- Check Docker is running
- Verify devcontainer CLI is installed: `npm install -g @devcontainers/cli`
- Review build logs for errors

---

**Safe AI-Assisted Coding!** 🤖🔒