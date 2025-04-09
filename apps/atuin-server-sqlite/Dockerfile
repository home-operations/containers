FROM docker.io/lukemathwalker/cargo-chef:latest-rust-1.86.0-alpine3.21 AS chef
ARG VERSION
WORKDIR /tmp

FROM chef AS planner
ADD https://github.com/conradludgate/atuin-server-sqlite.git#${VERSION} .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
RUN apk add --no-cache build-base
COPY --from=planner /tmp/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
ADD https://github.com/conradludgate/atuin-server-sqlite.git#${VERSION} .
RUN cargo build --release --bin atuin-server-sqlite-unofficial

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
