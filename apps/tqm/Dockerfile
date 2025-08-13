# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22
ARG TARGETARCH
ARG VERSION

USER root

RUN \
    apk add --no-cache \
        ca-certificates \
        catatonit \
        curl \
        bash \
        jq \
        nano \
        tzdata \
    && \
    mkdir -p /app/bin \
    && curl -fsSL "https://github.com/autobrr/tqm/releases/download/${VERSION}/tqm_${VERSION#*v}_linux_${TARGETARCH}.tar.gz" \
        | tar xzf - -C /app/bin \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
