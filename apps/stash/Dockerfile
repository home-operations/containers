# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22
ARG TARGETARCH
ARG STASHARCH=${TARGETARCH/arm64/-arm64v8}
ARG STASHARCH=${STASHARCH/amd64/}
ARG VERSION

USER root
WORKDIR /app

RUN apk add --no-cache --no-progress \
    bash \
    catatonit \
    ca-certificates \
    curl \
    ffmpeg \
    python3 \
    py3-pip

RUN curl -fsSL -o /app/stash https://github.com/stashapp/stash/releases/download/${VERSION}/stash-linux${STASHARCH}

RUN mkdir -p /config && chown nobody:nogroup -R /config && chmod -R 755 /app \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
