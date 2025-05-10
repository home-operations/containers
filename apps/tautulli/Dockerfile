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

ENV TAUTULLI_DOCKER="True" \
    TAUTULLI__PORT=8181

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        nano \
        tzdata \
    && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        cargo \
        libffi-dev \
        musl-dev \
        openssl-dev \
    && pip install uv \
    && uv pip install \
        --find-links "https://wheel-index.linuxserver.io/alpine-3.21/" \
        --requirement "https://raw.githubusercontent.com/Tautulli/tautulli-baseimage/python3/requirements.txt" \
    && mkdir -p /app \
    && curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components 1 \
    && echo "v${VERSION}" > /app/version.txt \
    && echo "master" > /app/branch.txt \
    && chown -R root:root /app && chmod -R 755 /app \
    && pip uninstall --yes uv && apk del --purge .build-deps \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
