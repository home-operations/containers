# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24 AS builder
ARG TARGETARCH
ARG VERSION
RUN apk add --no-cache --upgrade curl \
    && curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${VERSION}/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz" \
        | tar xzf - -C /tmp

FROM ghcr.io/flux-iac/tf-runner:v0.16.6
USER root
RUN apk add --no-cache --upgrade ca-certificates libc6-compat gcompat
COPY --from=builder --chown=65532:65532 --chmod=755 /tmp/tofu /usr/local/bin/terraform
USER 65532:65532
