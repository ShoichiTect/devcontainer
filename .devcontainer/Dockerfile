FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal system packages for Claude Code
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    zsh \
    build-essential \
    ca-certificates \
    gnupg \
    jq \
    unzip \
    fd-find \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js via nvm (required for Claude Code)
USER vscode
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && bash -c "source ~/.nvm/nvm.sh && nvm install --lts && nvm use --lts && nvm alias default lts/*"

# Install pnpm (optional, for Node.js projects)
RUN bash -c "source ~/.nvm/nvm.sh && npm install -g pnpm"

# Install oh-my-zsh for vscode user (skip if already exists)
RUN if [ ! -d "$HOME/.oh-my-zsh" ]; then \
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
    fi

# Install minimal zsh plugins
RUN ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom} && \
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then \
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions; \
    fi && \
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting; \
    fi

# Install Claude Code CLI
RUN bash -c "source ~/.nvm/nvm.sh && npm install -g @anthropic-ai/claude-code"

# Install groq-code-cli
RUN bash -c "source ~/.nvm/nvm.sh && npm install -g groq-code-cli@latest"

# Set zsh as default shell
USER root
RUN chsh -s $(which zsh) vscode

# Create workspace directory
RUN mkdir -p /workspaces && chown vscode:vscode /workspaces

USER vscode
WORKDIR /workspaces

# Set environment variables
ENV SHELL=/usr/bin/zsh
ENV TERM=xterm-256color