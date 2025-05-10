# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine
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
    UV_SYSTEM_PYTHON=true

ENV \
    HOME="/config" \
    PLATFORMIO_CORE_DIR=/cache/pio \
    ESPHOME_BUILD_PATH=/cache/build \
    ESPHOME_DATA_DIR=/cache/data

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        build-base \
        catatonit \
        gcompat \
        git \
    && pip install uv \
    && uv pip install \
        --find-links "https://wheels.home-assistant.io/musllinux/" \
        setuptools \
        "esphome[displays]==${VERSION}" \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup

WORKDIR /config

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
CMD ["dashboard", "/config"]
