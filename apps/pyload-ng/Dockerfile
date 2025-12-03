# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.14-alpine3.22
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
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/"

ENV HOME="/config"

USER root
WORKDIR /app

RUN \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        curl-dev \
    && apk add --no-cache \
        catatonit \
        ffmpeg \
        libatomic \
        libcurl \
        libjpeg-turbo \
        7zip \
        sqlite \
        tesseract-ocr \
    && pip install --no-cache-dir uv \
    && uv pip install --pre pyload-ng[all]=="${VERSION}" \
    && mkdir -p /config && chown nobody:nogroup -R /config \
    && mkdir -p /downloads && chown nobody:nogroup -R /downloads \
    && apk del --purge build-dependencies \
    && rm -rf /root/.cache /tmp/*

COPY . /

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config

VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
