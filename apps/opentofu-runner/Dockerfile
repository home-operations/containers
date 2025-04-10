# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21 AS builder
ARG TARGETARCH
ARG VERSION
RUN \
    apk add --no-cache \
        bash \
        curl \
    && curl -fsSL -o /tmp/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz "https://github.com/opentofu/opentofu/releases/download/v${VERSION}/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz" \
    && tar -xzvf /tmp/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz -C /tmp \
    && chmod +x /tmp/tofu

FROM ghcr.io/flux-iac/tf-runner:v0.16.0-rc.5
USER root
COPY --from=builder --chown=65532:65532 /tmp/tofu /usr/local/bin/terraform
USER 65532:65532
