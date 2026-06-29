# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETPLATFORM

RUN apk add --no-cache smartmontools \
    && apk add --no-cache --virtual=.build-deps curl \
    && curl -fsSL "https://github.com/prometheus-community/smartctl_exporter/releases/download/v${VERSION}/smartctl_exporter-${VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz" \
        | tar xzf - -C /bin --strip-components=1 "smartctl_exporter-${VERSION}.${TARGETOS}-${TARGETARCH}/smartctl_exporter" \
    && chmod +x /bin/smartctl_exporter \
    && apk del --purge .build-deps

USER nobody
ENTRYPOINT ["/bin/smartctl_exporter"]
