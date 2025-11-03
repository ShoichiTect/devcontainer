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

# Install Claude Code CLI
RUN bash -c "source ~/.nvm/nvm.sh && npm install -g @anthropic-ai/claude-code"

# Install groq-code-cli (from source, using npm pack)
RUN bash -c "source ~/.nvm/nvm.sh && \
    git clone https://github.com/build-with-groq/groq-code-cli.git /tmp/groq-code-cli && \
    cd /tmp/groq-code-cli && \
    npm install && \
    npm run build && \
    npm pack && \
    npm install -g groq-code-cli-*.tgz && \
    cd / && \
    rm -rf /tmp/groq-code-cli"

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