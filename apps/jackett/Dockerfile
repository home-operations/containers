# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21
ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/arm64/ARM64}
ARG TARGETARCH=${TARGETARCH/amd64/AMDx64}
ARG VERSION

ENV XDG_CONFIG_HOME=/config

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        icu-data-full \
        icu-libs \
        jq \
        libintl \
        nano \
        tzdata \
    && mkdir -p /app/bin \
    && curl -fsSL "https://github.com/Jackett/Jackett/releases/download/${VERSION}/Jackett.Binaries.LinuxMusl${TARGETARCH}.tar.gz" \
        | tar xzf - -C /app/bin --strip-components 1 \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/* /app/bin/JackettUpdater*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
