FROM docker.io/library/alpine:3.21 AS opentofu

ARG TARGETARCH
ARG VENDOR
ARG VERSION

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        bash \
        curl \
    && curl -fsSL -o /tmp/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz "https://github.com/opentofu/opentofu/releases/download/v${VERSION}/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz" \
    && tar -xzvf /tmp/tofu_${VERSION}_linux_${TARGETARCH}.tar.gz -C /tmp \
    && chmod +x /tmp/tofu

FROM ghcr.io/flux-iac/tf-runner:v0.16.0-rc.5 AS runner

ARG TARGETARCH
ARG VENDOR
ARG VERSION

USER root

COPY --from=opentofu --chown=65532:65532 /tmp/tofu /usr/local/bin/terraform

USER 65532:65532
