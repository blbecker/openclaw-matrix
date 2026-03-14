ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/openclaw/openclaw:${BASE_IMAGE_TAG}

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh

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

