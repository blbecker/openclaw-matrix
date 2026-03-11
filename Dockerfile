# Get the image tag from a build arg instead of defining it statically. AI!
FROM ghcr.io/openclaw/openclaw:2026.3.8 

USER root

RUN npm install -g @vector-im/matrix-bot-sdk

USER node
