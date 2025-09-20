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

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.bashrc \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.zshrc

# Set PATH for homebrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# Install Node.js via nvm
USER vscode
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

# Install Go
USER root
RUN wget https://golang.org/dl/go1.21.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
    && rm go1.21.0.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && mv squashfs-root /opt/nvim \
    && ln -s /opt/nvim/AppRun /usr/bin/nvim \
    && rm nvim.appimage

# Install git-delta
RUN wget https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb \
    && dpkg -i git-delta_0.16.5_amd64.deb \
    && rm git-delta_0.16.5_amd64.deb

# Install oh-my-zsh for vscode user
USER vscode
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z

# Install opencode CLI
RUN curl -fsSL https://api.opencode.dev/install.sh | sh

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