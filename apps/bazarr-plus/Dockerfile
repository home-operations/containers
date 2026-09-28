# syntax=docker/dockerfile:1

FROM docker.io/library/node:24-trixie-slim AS builder
ARG VERSION

WORKDIR /build
ADD https://github.com/LavX/bazarr/archive/refs/tags/${VERSION}.tar.gz /tmp/source.tar.gz

RUN tar xzf /tmp/source.tar.gz --strip-components=1 \
    && npm ci --prefix frontend \
    && npm run build --prefix frontend

FROM docker.io/library/rust:1.95-slim-trixie AS alass
# renovate: datasource=crate depName=alass-cli
ARG ALASS_CLI_VERSION=2.0.0

RUN cargo install alass-cli --version "${ALASS_CLI_VERSION}" --locked --root /alass

FROM docker.io/library/python:3.14-slim-trixie
ARG VERSION

ENV \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true

ENV \
    BAZARR__PORT=6767 \
    BAZARR_VERSION=${VERSION} \
    HOME=/config \
    MALLOC_ARENA_MAX=2

USER root
WORKDIR /app

COPY --from=builder /build/requirements.txt /build/postgres-requirements.txt /tmp/

RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        bash \
        ca-certificates \
        catatonit \
        ffmpeg \
        libpq5 \
        libxml2 \
        libxslt1.1 \
        mediainfo \
        tzdata \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        build-essential \
        libffi-dev \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
    && sed -i '/Pillow>/s/ --only-binary=Pillow//; /Pillow>/a --only-binary=Pillow' /tmp/requirements.txt \
    && pip install uv \
    && uv pip install \
        --requirement /tmp/requirements.txt \
        --requirement /tmp/postgres-requirements.txt \
    && uv pip install --no-deps signalrcore==1.0.2 \
    && pip uninstall --yes uv \
    && apt-get purge -y --auto-remove \
        build-essential \
        libffi-dev \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
    && apt-get clean \
    && rm -rf /root/.cache /tmp/* /var/cache/* /var/log/* /var/lib/apt/lists/*

COPY --from=builder /build/bazarr.py /build/package_info /app/bin/
COPY --from=builder /build/bazarr /app/bin/bazarr
COPY --from=builder /build/custom_libs /app/bin/custom_libs
COPY --from=builder /build/migrations /app/bin/migrations
COPY --from=builder /build/frontend/build /app/bin/frontend/build
COPY --from=alass /alass/bin/alass-cli /usr/local/bin/alass-cli
COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-ubuntu /usr/bin/unrar

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
