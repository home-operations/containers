# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21
ARG VERSION

ENV DELUGE_BIN="deluged" \
    XDG_CONFIG_HOME="/config" \
    PYTHON_EGG_CACHE="/config/plugins/.python-eggs" \
    TMPDIR="/tmp"

USER root

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
        tzdata \
    && \
    apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
        deluge=="${VERSION}" \
        py3-future \
        py3-geoip \
        py3-requests \
    && \
    mkdir -p /usr/share/GeoIP \
    && \
    curl -fsSL "https://mailfud.org/geoip-legacy/GeoIP.dat.gz" \
        | gunzip > /usr/share/GeoIP/GeoIP.dat \
    && rm -rf /tmp/*

COPY . /

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
