# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETPLATFORM

RUN apk add --no-cache smartmontools \
    && wget "https://github.com/prometheus-community/smartctl_exporter/releases/download/v$VERSION/smartctl_exporter-$VERSION.$TARGETOS-$TARGETARCH.tar.gz" \
    && tar xvzf smartctl_exporter-$VERSION.$TARGETOS-$TARGETARCH.tar.gz \
    && ls -l smartctl_exporter-$VERSION.$TARGETOS-$TARGETARCH.tar.gz \
    && mv smartctl_exporter-$VERSION.$TARGETOS-$TARGETARCH/smartctl_exporter /bin/smartctl_exporter \
    && chmod +x /bin/smartctl_exporter \
    && rm -rf smartctl_exporter*

USER nobody
ENTRYPOINT ["/bin/smartctl_exporter"]
