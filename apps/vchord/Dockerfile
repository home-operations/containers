# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24 AS build
ARG TARGETARCH
ARG VERSION
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

WORKDIR /tmp

RUN \
    apk add --no-cache \
        curl \
        unzip; \
    case "${TARGETARCH}" in \
        amd64) arch=x86_64 ;; \
        arm64) arch=aarch64 ;; \
    esac; \
    for pg in 14 15 16 17 18; do \
        zip="postgresql-${pg}-vchord_${VERSION}_${arch}-linux-gnu.zip"; \
        curl -fsSL \
            -O "https://github.com/pgsty/vchord/releases/download/${VERSION}/${zip}" \
            -O "https://github.com/pgsty/vchord/releases/download/${VERSION}/${zip}.sha256"; \
        sha256sum -c "${zip}.sha256"; \
        unzip -q "${zip}" -d "${pg}"; \
        install -D -m 0755 "${pg}/pkglibdir/vchord.so" "/rootfs/usr/lib/postgresql/${pg}/lib/vchord.so"; \
        install -D -m 0644 -t "/rootfs/usr/share/postgresql/${pg}/extension" "${pg}"/sharedir/extension/*; \
    done; \
    install -D -m 0644 18/LICENSE /rootfs/usr/share/doc/vchord/LICENSE

FROM scratch
COPY --from=build /rootfs/ /
