# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.22
ARG TARGETARCH
ARG QBARCH=${TARGETARCH/arm64/aarch64}
ARG QBARCH=${QBARCH/amd64/x86_64}
ARG VERSION

# renovate: datasource=github-releases depName=ludviglundgren/qbittorrent-cli
ARG QBITORRENT_CLI_VERSION=v2.2.0

ENV QBT_CONFIRM_LEGAL_NOTICE=1 \
    HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config"

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        7zip \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        nano \
        tzdata \
    && \
    mkdir -p /app \
    && LIBTORRENT=$(curl -sL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '.libtorrent_2_0') \
    && curl -fsSL -o /app/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-${VERSION}_v${LIBTORRENT}/${QBARCH}-qbittorrent-nox" \
    && chown -R root:root /app/qbittorrent-nox \
    && chmod -R 755 /app/qbittorrent-nox \
    && \
    curl -fsSL https://github.com/ludviglundgren/qbittorrent-cli/releases/download/${QBITORRENT_CLI_VERSION}/qbittorrent-cli_${QBITORRENT_CLI_VERSION#*v}_linux_${TARGETARCH}.tar.gz \
        | tar xzf - -C /usr/local/bin \
    && rm -rf /tmp/*

COPY . /

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
