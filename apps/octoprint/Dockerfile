# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.14-alpine3.24
ARG VENDOR
ARG VERSION

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    UV_FIND_LINKS="https://wheel-index.linuxserver.io/alpine-3.24/"

USER root

RUN \
    apk add --no-cache --upgrade \
        ca-certificates \
        catatonit \
        ffmpeg \
    && pip install uv \
    && uv pip install "octoprint==${VERSION}" \
    && pip uninstall --yes uv \
    && rm -rf /root/.cache /root/.cargo /tmp/*

USER nobody:nogroup
WORKDIR /config

# Plugins need to use 'pip install --user'
ENV PYTHONUSERBASE=/config/plugins \
    PIP_USER=true

ENTRYPOINT ["/usr/bin/catatonit", "--", "octoprint", "serve", "--basedir", "/config"]
