# syntax=docker/dockerfile:1

FROM docker.io/library/node:24-alpine AS builder
ARG VERSION

RUN apk add --no-cache git

WORKDIR /app
RUN npm install --omit=dev "thelounge@${VERSION#*v}"

FROM docker.io/library/node:24-alpine
ARG VERSION

RUN apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        nano \
        tzdata

COPY --from=builder /app /app

RUN chown -R root:root /app && chmod -R 755 /app \
    && mkdir -p /config && chown nobody:nogroup /config

COPY . /

ENV \
    THELOUNGE_HOME=/config/thelounge \
    THELOUNGE_MESSAGE_STORAGE="[sqlite]" \
    THELOUNGE_PORT=9000 \
    THELOUNGE_STORAGE_POLICY_DELETION_POLICY=everything \
    THELOUNGE_STORAGE_POLICY_ENABLED=true \
    THELOUNGE_STORAGE_POLICY_MAX_AGE_DAYS=30

USER nobody:nogroup
WORKDIR /app
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
