# syntax=docker/dockerfile:1

FROM docker.io/library/golang:1.24-alpine AS builder
ARG VERSION

USER root
WORKDIR /app

RUN apk add --no-cache git \
    && git clone --single-branch --branch "${VERSION}" https://github.com/autobrr/tqm.git . \
    && go mod download \
    && \
    CGO_ENABLED=0 go build \
        -trimpath \
        -ldflags "-s -w -X github.com/autobrr/tqm/runtime.Version=${VERSION}" \
        -o tqm ./cmd/tqm

FROM scratch
COPY --from=builder /app/tqm /tqm
ENTRYPOINT ["/tqm"]
