# Personal Development Environment Template

🚀 A comprehensive devcontainer template for personal development projects with modern tools and configurations.

## 🛠️ Included Tools & Technologies

### Shell & Terminal
- **zsh** with **oh-my-zsh**
- **tmux** with custom configuration
- **exa**, **bat**, **ripgrep**, **fd** (modern CLI tools)

### Editors & IDEs
- **Neovim** with comprehensive LSP setup
- **VS Code** extensions and settings

### Package Managers
- **npm/pnpm** (Node.js)
- **pip/pipx** (Python)
- **brew** (Homebrew for Linux)
- **cargo** (Rust)
- **apt** (System packages)

### Programming Languages
- **Node.js** (via nvm)
- **Python** (with poetry support)
- **Rust** (via rustup)
- **Go**

### Development Tools
- **Git** with useful aliases
- **Docker** (Docker-in-Docker)
- **opencode** (Claude AI CLI)
- **Various LSP servers** for code intelligence

## 📁 Project Structure

```
devcontainer/
├── .devcontainer/
│   ├── devcontainer.json    # VS Code devcontainer configuration
│   ├── Dockerfile          # Custom development environment
│   ├── dotfiles/           # Dotfiles for development environment
│   │   ├── .zshrc          # Zsh configuration
│   │   ├── .tmux.conf      # Tmux configuration
│   │   └── nvim/           # Neovim configuration
│   └── scripts/
│       └── setup.sh        # Automated setup script
├── templates/              # Project templates (add your own)
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

## ⚙️ Configuration Details

### Zsh Configuration
- **Theme**: robbyrussell (default oh-my-zsh theme)
- **Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting, zsh-z, docker, and more
- **Aliases**: Modern CLI tools (exa, bat, ripgrep, fd)
- **History**: Enhanced history management

### Tmux Configuration
- **Prefix**: `Ctrl-a` (instead of default `Ctrl-b`)
- **Mouse support**: Enabled
- **Vim-like navigation**: `h`, `j`, `k`, `l` for pane switching
- **Plugins**: TPM, tmux-resurrect, tmux-continuum, vim-tmux-navigator

### Neovim Configuration
- **Plugin Manager**: lazy.nvim
- **Theme**: Catppuccin Mocha
- **LSP**: Configured for multiple languages
- **Features**: File explorer, fuzzy finder, autocompletion, git integration

## 🔧 Customization

### Adding New Languages
1. Update the Dockerfile to install language runtime
2. Add LSP server to `dotfiles/nvim/lua/config/lsp.lua`
3. Update setup script with language-specific tools

### Custom Dotfiles
Replace files in the `dotfiles/` directory with your own configurations.

### VS Code Extensions
Modify the `extensions` array in `.devcontainer/devcontainer.json`.

## 📦 Available Aliases

### File Operations
- `ll` → `exa -la --git`
- `ls` → `exa`
- `cat` → `bat`
- `find` → `fd`
- `grep` → `rg`

### Git
- `g` → `git`
- `gs` → `git status`
- `ga` → `git add`
- `gc` → `git commit`
- `gp` → `git push`
- `gl` → `git pull`

### Docker
- `d` → `docker`
- `dc` → `docker-compose`
- `dps` → `docker ps`

### Tmux
- `t` → `tmux`
- `ta` → `tmux attach`
- `tl` → `tmux list-sessions`

## 🛡️ Security Features

### Sandboxing
- **Read-only root filesystem**: System files cannot be modified
- **No privilege escalation**: `--security-opt=no-new-privileges` prevents sudo
- **Dropped capabilities**: All Linux capabilities removed with `--cap-drop=ALL`
- **Isolated workspace**: Only project directory is mounted, host filesystem is inaccessible

### Access Control
- **SSH keys**: Mounted as read-only from host
- **Git config**: Copied from host (modifiable in container)
- **No host access**: Container cannot access files outside project directory
- **Separate user**: Runs as `vscode` user, not root

### Data Persistence
- **Volume mount**: `/home/vscode` persisted in named volume
- **Claude Code settings**: Saved in volume (survives container restarts)
- **No secrets in image**: SSH keys and configs mounted at runtime only

## 🎯 Use Cases

This template is perfect for:
- **Web Development** (React, Vue, Angular, Node.js)
- **Python Development** (Django, FastAPI, Data Science)
- **Rust Development** (CLI tools, web services)
- **Go Development** (Microservices, APIs)
- **DevOps & Scripting**
- **Personal Projects**

## 🔄 Port Forwarding

The following ports are automatically forwarded:
- `3000` - Common development server port
- `8000` - Python/Django development server
- `8080` - Alternative web server port
- `5173` - Vite development server

## 📝 Tips & Tricks

### Tmux
- `Ctrl-a + I` to install tmux plugins
- `Ctrl-a + |` to split vertically
- `Ctrl-a + -` to split horizontally

### Neovim
- `<leader>` key is set to `Space`
- `<leader>e` to toggle file explorer
- `<leader>ff` to find files
- `<leader>fg` to grep in files

### Development Workflow
1. Start tmux: `tmux`
2. Create development session with multiple panes
3. Use nvim for editing
4. Use integrated terminal for running commands

## 🤝 Contributing

Feel free to:
- Add new language configurations
- Improve existing setups
- Add useful aliases or tools
- Create project templates

## 📄 License

This template is open source. Feel free to use and modify as needed.

---

**Happy Coding!** 🎉