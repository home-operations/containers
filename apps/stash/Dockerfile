# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.22
ARG TARGETARCH
ARG STASHARCH=${TARGETARCH/arm64/-arm64v8}
ARG STASHARCH=${STASHARCH/amd64/}
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
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.23/"

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        ffmpeg \
        jq \
        nano \
        tzdata

RUN \
    curl -fsSL -o /app/stash https://github.com/stashapp/stash/releases/download/${VERSION}/stash-linux${STASHARCH} \
    && pip install uv \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
