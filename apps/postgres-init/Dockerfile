# syntax=docker/dockerfile:1

ARG VERSION
FROM docker.io/library/postgres:${VERSION}
USER root
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
    && rm -rf /tmp/*
COPY . /
USER nobody:nogroup
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
