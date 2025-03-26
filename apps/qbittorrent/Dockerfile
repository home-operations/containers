FROM docker.io/library/python:3.13-alpine

ARG TARGETPLATFORM
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV QBT_CONFIRM_LEGAL_NOTICE=1 \
    QBT_WEBUI_PORT=8080 \
    QBT_TORRENTING_PORT=50413 \
    HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config"

USER root

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        icu-libs \
        jo \
        jq \
        nano \
        p7zip \
        qt6-qtbase-sqlite \
        trurl \
        tzdata \
    && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
        qbittorrent-nox="${VERSION}" \
    && rm -rf /tmp/*

COPY ./qBittorrent.conf /qBittorrent.conf
COPY ./entrypoint.sh /entrypoint.sh

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent"
