# syntax=docker/dockerfile:1

# NOTE: Alpine version is tied to the version in the Renovate annotation in docker-bake.hcl
FROM docker.io/library/python:3.13-alpine3.21
ARG TARGETARCH
ARG MINIJINJA_ARCH=${TARGETARCH/arm64/aarch64}
ARG MINIJINJA_ARCH=${MINIJINJA_ARCH/amd64/x86_64}
ARG VERSION

ENV HOME=/config \
    XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/config \
    TRANSMISSION__RPC_PORT=9091 \
    TRANSMISSION_WEB_HOME=/usr/share/transmission/public_html

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        nano \
        p7zip \
        transmission-daemon=="${VERSION}" \
        transmission-cli=="${VERSION}" \
        transmission-extra=="${VERSION}" \
        transmission-remote=="${VERSION}" \
        tzdata \
    && \
    curl -fsSL https://github.com/mitsuhiko/minijinja/releases/download/2.8.0/minijinja-cli-${MINIJINJA_ARCH}-unknown-linux-musl.tar.xz \
        | tar xJf - -C /usr/local/bin/ --strip-components=1 \
    && \
    rm -rf /tmp/*

COPY . /

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
