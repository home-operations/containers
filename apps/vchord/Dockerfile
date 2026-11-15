# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24 AS build
ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG ARCH=${ARCH/amd64/x86_64}
ARG VERSION
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

WORKDIR /tmp

RUN \
    apk add --no-cache \
        github-cli \
        unzip; \
    gh release download "${VERSION}" --repo pgsty/vchord \
        --pattern "postgresql-*-vchord_${VERSION}_${ARCH}-linux-gnu.zip*"; \
    sha256sum -c ./*.sha256; \
    for zip in postgresql-*.zip; do \
        pg="${zip#postgresql-}"; \
        pg="${pg%%-*}"; \
        unzip -q "${zip}" -d "${pg}"; \
        install -D -m 0755 "${pg}/pkglibdir/vchord.so" "/rootfs/usr/lib/postgresql/${pg}/lib/vchord.so"; \
        install -D -m 0644 -t "/rootfs/usr/share/postgresql/${pg}/extension" "${pg}"/sharedir/extension/*; \
        install -D -m 0644 "${pg}/LICENSE" /rootfs/usr/share/doc/vchord/LICENSE; \
    done

FROM scratch
COPY --from=build /rootfs/ /
