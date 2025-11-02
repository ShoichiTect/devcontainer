FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    tmux \
    zsh \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    jq \
    unzip \
    tree \
    htop \
    fd-find \
    ripgrep \
    bat \
    exa \
    && rm -rf /var/lib/apt/lists/*

# Install Homebrew (switch to vscode user first)
USER vscode
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.bashrc \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.zshrc

# Set PATH for homebrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# Install Node.js via nvm (already vscode user)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && bash -c "source ~/.nvm/nvm.sh && nvm install --lts && nvm use --lts && nvm alias default lts/*"

# Install pnpm
RUN bash -c "source ~/.nvm/nvm.sh && npm install -g pnpm"

# Install Python tools
USER root
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv \
    && python3 -m pip install --upgrade pip pipx poetry \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
USER vscode
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && echo 'source ~/.cargo/env' >> ~/.bashrc \
    && echo 'source ~/.cargo/env' >> ~/.zshrc

# Install Go (ARM64 compatible)
USER root
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then GO_ARCH="arm64"; else GO_ARCH="amd64"; fi && \
    wget https://golang.org/dl/go1.21.0.linux-${GO_ARCH}.tar.gz \
    && tar -C /usr/local -xzf go1.21.0.linux-${GO_ARCH}.tar.gz \
    && rm go1.21.0.linux-${GO_ARCH}.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Neovim (via apt for ARM64 compatibility)
RUN add-apt-repository ppa:neovim-ppa/unstable -y \
    && apt-get update \
    && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*

# Install git-delta (ARM64 compatible)
RUN ARCH=$(dpkg --print-architecture) && \
    wget https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_${ARCH}.deb \
    && dpkg -i git-delta_0.16.5_${ARCH}.deb \
    && rm git-delta_0.16.5_${ARCH}.deb

# Install oh-my-zsh for vscode user (skip if already exists)
USER vscode
RUN if [ ! -d "$HOME/.oh-my-zsh" ]; then \
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
    fi

# Install zsh plugins (skip if already exists)
RUN ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom} && \
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then \
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions; \
    fi && \
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting; \
    fi && \
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-z" ]; then \
        git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z; \
    fi

# Install Claude Code CLI and opencode CLI
RUN bash -c "source ~/.nvm/nvm.sh && npm install -g @anthropic-ai/claude-code" && \
    curl -fsSL https://api.opencode.dev/install.sh | sh || echo "opencode install failed, continuing..."

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