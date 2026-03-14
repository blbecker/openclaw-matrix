ARG BASE_IMAGE_TAG=latest@sha256:c871ddf7ad1b4125218e5f010b59724f0d2bb299714c5bd6ba7c1e99462450a7
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
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh

# Install ntfy
RUN curl -L -o /etc/apt/keyrings/ntfy.gpg https://archive.ntfy.sh/apt/keyring.gpg && \
    apt install apt-transport-https && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ntfy.gpg] https://archive.ntfy.sh/apt stable main" \
        > /etc/apt/sources.list.d/ntfy.list && \
    apt update && \
    apt install ntfy

# Install Go (required for gog and summarize)
ENV GO_VERSION=1.23.2
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

# Install remaining Node dependencies (original step)
USER root
RUN cd /app && \
    pnpm add @vector-im/matrix-bot-sdk @matrix-org/matrix-sdk-crypto-nodejs

USER node

