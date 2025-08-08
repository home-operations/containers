# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-slim
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

ADD https://github.com/ThePhaseless/Byparr.git#${VERSION} .

RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        catatonit \
        chromium \
        chromium-driver \
        curl \
        scrot \
        xauth \
        xvfb \
    && \
    pip install uv \
    && uv sync \
    && cd .venv/lib/*/site-packages/seleniumbase/drivers && rm -f uc_driver && ln -s /usr/bin/chromedriver uc_driver \
    && chown -R root:root /app && chmod -R 755 /app \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/{cache,log}/* /var/lib/apt/lists/* /usr/src/*

COPY . /

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
