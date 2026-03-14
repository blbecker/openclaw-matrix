# Openclaw Matrix

[![Build and Push Docker Image](https://github.com/blbecker/openclaw-matrix/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/blbecker/openclaw-matrix/actions/workflows/build-and-push.yml)

This started as a container with the matrix dependencies pre-installed. It ended up being a convenient way to pre-install dependencies, so now it's my base openclaw image.

## Building locally

Build from latest

```bash
docker build .
```

Build from a specific version

```bash
docker build --build-arg BASE_IMAGE_TAG=2026.3.8 .
```
