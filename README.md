# Openclaw Matrix

![Build](https://github.com/github/docs/actions/workflows/build-and-push.yml/badge.svg?branch=main)

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
