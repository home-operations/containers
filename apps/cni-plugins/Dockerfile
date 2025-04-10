# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21
ARG TARGETARCH
ARG VERSION

ENV CNI_BIN_DIR=/host/opt/cni/bin

USER root

RUN \
    apk add --no-cache \
        rsync \
    && \
    apk add --no-cache --virtual=.build-deps \
        curl \
        tar \
    && mkdir -p /plugins \
    && curl -fsSL "https://github.com/containernetworking/plugins/releases/download/${VERSION}/cni-plugins-linux-${TARGETARCH}-${VERSION}.tgz" \
        | tar xzf - -C /plugins --strip-components=1 \
    && apk del --purge .build-deps \
    && rm -rf  /tmp/*

CMD rsync -av /plugins/* $CNI_BIN_DIR
