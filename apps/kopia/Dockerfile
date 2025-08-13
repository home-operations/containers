# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22
ARG VERSION

ENV \
    KOPIA_CHECK_FOR_UPDATES=false \
    KOPIA_CONFIG_PATH=/config/repository.config \
    KOPIA_CACHE_DIRECTORY=/cache \
    KOPIA_PERSIST_CREDENTIALS_ON_CONNECT=false

ENV \
    KOPIA_WEB_ENABLED=true \
    KOPIA_WEB_PORT=51515

USER root

RUN \
    apk add --no-cache \
        ca-certificates \
        catatonit \
        bash \
    && \
    apk add --no-cache --repository="https://dl-cdn.alpinelinux.org/alpine/edge/testing/" \
        kopia=="${VERSION}" \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
