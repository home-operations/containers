ARG VERSION
FROM ghcr.io/kiwigrid/k8s-sidecar:${VERSION}

USER root

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        jq \
        tzdata \
    && rm -rf /tmp/*

USER nobody:nogroup
