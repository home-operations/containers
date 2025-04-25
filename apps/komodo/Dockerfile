# syntax=docker/dockerfile:1

ARG VERSION
FROM docker.io/library/alpine:3.21 AS builder
ARG TARGETARCH
RUN apk add --no-cache curl \
    && OP_VERSION="v$(curl https://app-updates.agilebits.com/check/1/0/CLI2/en/2.0.0/N -s | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')"; \
    curl -sSfo op.zip \
    https://cache.agilebits.com/dist/1P/op2/pkg/"$OP_VERSION"/op_linux_"$TARGETARCH"_"$OP_VERSION".zip \
    && unzip -o op.zip \
    && rm op.zip op.sig \
    && chmod +x op

FROM ghcr.io/moghtech/komodo-core:${VERSION}
USER root
RUN addgroup --system --gid 2000 komodo && adduser --system --uid 2000 --home /app --ingroup komodo komodo && chown -R 2000:2000 /app
COPY --from=builder --chown=2000:2000 --chmod=755 /op /usr/local/bin/op
USER 2000:2000
