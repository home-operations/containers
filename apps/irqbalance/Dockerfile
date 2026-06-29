# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24
ARG VERSION
# hadolint ignore=DL3002
USER root
RUN \
    apk add --no-cache \
        bash \
        irqbalance=="${VERSION}" \
    && rm -rf /tmp/*
ENTRYPOINT ["/usr/sbin/irqbalance", "--foreground"]
