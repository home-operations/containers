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
        7zip \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        nano \
        py3-future \
        py3-requests \
        tzdata \
    && \
    apk add --no-cache --repository="https://dl-cdn.alpinelinux.org/alpine/edge/community" \
        deluge=="${VERSION}" \
    && \
    apk add --no-cache --repository="https://dl-cdn.alpinelinux.org/alpine/edge/testing" \
        py3-geoip \
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
