# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV QBT_CONFIRM_LEGAL_NOTICE=1 \
    HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    XDG_DATA_HOME="/config"

USER root

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        icu-libs \
        jq \
        nano \
        p7zip \
        qt6-qtbase-sqlite \
        tzdata \
    && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
        qbittorrent-nox=="${VERSION}" \
    && rm -rf /tmp/*

COPY . /

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
