ARG IMAGE_TAG=2026.3.8
FROM ghcr.io/openclaw/openclaw:${IMAGE_TAG}

USER root

RUN cd /app && \
  pnpm add @vector-im/matrix-bot-sdk

USER node
