FROM docker.io/lukemathwalker/cargo-chef:latest-rust-1.83.0-alpine3.21 AS builder

ARG TARGETPLATFORM
ARG VENDOR
ARG VERSION

WORKDIR /tmp

ADD https://github.com/conradludgate/atuin-server-sqlite.git#${VERSION} .

RUN apk add --no-cache build-base \
    && cargo chef prepare --recipe-path recipe.json \
    && cargo chef cook --release --recipe-path recipe.json \
    && cargo build --release --bin atuin-server-sqlite-unofficial

FROM docker.io/library/alpine:3.21

ENV ATUIN_HOST=0.0.0.0 \
    ATUIN_PORT=8888 \
    ATUIN_CONFIG_DIR=/config \
    ATUIN_DB_URI=sqlite:///config/atuin.db \
    RUST_LOG=atuin::api=info \
    TZ=Etc/UTC

RUN apk add --no-cache ca-certificates catatonit sqlite-libs tzdata

USER nobody:nogroup

WORKDIR /config
VOLUME ["/config"]

COPY --from=builder /tmp/target/release/atuin-server-sqlite-unofficial /usr/local/bin

ENTRYPOINT ["/usr/bin/catatonit", "--", "/usr/local/bin/atuin-server-sqlite-unofficial"]
CMD ["server", "start"]
