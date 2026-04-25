# Openclaw Matrix

[![Build and Push Docker Image](https://github.com/blbecker/openclaw-matrix/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/blbecker/openclaw-matrix/actions/workflows/build-and-push.yml)

This started as a container with the matrix dependencies pre-installed. It ended up being a convenient way to pre-install dependencies, so now it's my base openclaw image.

## Building locally

Build and run from latest

```bash
export docker_tag="openclaw-matrix:local-$(git rev-parse --short HEAD)"
docker build . -t "${docker_tag}"
docker run -it -v "$(pwd):/build" "${docker_tag}" bash

```

Build from a specific version

```bash
docker build --build-arg BASE_IMAGE_TAG=2026.3.8 .
```
