ARG BASE_IMAGE_TAG=2026.4.2@sha256:0b2170d5ec3a487a6313ed0556d377c5c5c80a0f806043daa2e685a4bedd45e3
FROM ghcr.io/openclaw/openclaw:${BASE_IMAGE_TAG}

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common \
    git \
    jq \
    apt-transport-https \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh

# Install ntfy
RUN curl -L -o /etc/apt/keyrings/ntfy.gpg https://archive.ntfy.sh/apt/keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ntfy.gpg] https://archive.ntfy.sh/apt stable main" \
        > /etc/apt/sources.list.d/ntfy.list && \
    apt update && \
    apt install ntfy

# Install Go (required for gog and summarize)
ENV GO_VERSION=1.26.1
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install gog (Google Workspace CLI) and summarize
ENV GOPATH=/home/node/go
ENV PATH="${GOPATH}/bin:${PATH}"
RUN mkdir -p ${GOPATH} && chown -R node:node ${GOPATH}

# Install summarize
RUN npm i -g @steipete/summarize

USER node
RUN go install github.com/steipete/gogcli/cmd/gog@latest 

# Install remaining Node dependencies 
USER root
RUN cd /app && \
    pnpm add @vector-im/matrix-bot-sdk @matrix-org/matrix-sdk-crypto-nodejs

# Install pip and python packages
RUN apt install -y python3-pip python-is-python3 && \
    pip install agentmail python-dotenv requests --break-system-packages

USER node

