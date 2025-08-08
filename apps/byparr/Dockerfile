# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.22
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
    GITHUB_BUILD="false" \
    VERSION=${VERSION} \
    DISPLAY=:0

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
        xauth \
        xvfb \
        scrot \
        chromium \
        chromium-chromedriver \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
        git \
    && \
    git clone --single-branch --branch "${VERSION}" https://github.com/ThePhaseless/Byparr.git . \
    && pip install uv \
    && uv sync \
    && cd .venv/lib/*/site-packages/seleniumbase/drivers && rm -f uc_driver && ln -s /usr/bin/chromedriver uc_driver \
    && chown -R root:root /app && chmod -R 755 /app \
    && apk del --purge .build-deps \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY . /

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
