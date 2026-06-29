# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24 AS openssl-builder
ARG OPENSSL_VERSION=3.6.1
ARG OPENSSL_PREFIX=/opt/openssl

RUN \
    apk add --no-cache \
        build-base \
        linux-headers \
        perl \
    && wget -qO- "https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz" \
        | tar xz --strip-components=1 \
    && ./config \
        --prefix="${OPENSSL_PREFIX}" \
        --openssldir="${OPENSSL_PREFIX}" \
        --libdir=lib \
        enable-comp \
        threads \
        -Wl,-rpath,${OPENSSL_PREFIX}/lib \
    && make -j"$(nproc)" \
    && make install_sw install_ssldirs

FROM docker.io/library/alpine:3.24
ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV LD_LIBRARY_PATH="/lib:/usr/lib" \
    LIBVA_DRIVERS_PATH="/usr/lib/dri" \
    MESA_SHADER_CACHE_DIR="/tmp" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/config/Library/Application Support" \
    PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver" \
    PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6" \
    PLEX_MEDIA_SERVER_INFO_VENDOR="Docker" \
    PLEX_MEDIA_SERVER_INFO_DEVICE="Docker Container (${VENDOR})"

USER root
WORKDIR /app

# hadolint ignore=SC2046
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        gcompat \
        jq \
        tzdata \
        xmlstarlet \
    && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
        libdrm \
        libva \
        mesa-dri-gallium \
        mesa-va-gallium \
        $( [ "${TARGETARCH}" = "amd64" ] && echo intel-media-driver ) \
    && \
    apk add --no-cache --virtual=.build-deps \
        dpkg \
    && \
    curl -fsSL -o /tmp/plex.deb \
        "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_${TARGETARCH}.deb" \
    && dpkg-deb -R /tmp/plex.deb /tmp \
    && cp -R /tmp/usr/* /usr \
    && find "${PLEX_MEDIA_SERVER_HOME}/lib" -type f -exec sh -c '[ -f "/usr/lib/$(basename "$1")" ] && rm -v "$1"' _ {} \; \
    && find "${PLEX_MEDIA_SERVER_HOME}/lib" -type f -exec sh -c '[ -f "/lib/$(basename "$1")" ] && rm -v "$1"' _ {} \; \
    && ln -sf "/lib/ld-musl-$(uname -m).so.1" "${PLEX_MEDIA_SERVER_HOME}/lib/ld-musl-$(uname -m).so.1" \
    && ln -sf "/lib/ld-musl-$(uname -m).so.1" "${PLEX_MEDIA_SERVER_HOME}/lib/libc.so" \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

COPY --from=openssl-builder /opt/openssl/lib/libcrypto.so* /usr/lib/
COPY --from=openssl-builder /opt/openssl/lib/libssl.so*    /usr/lib/
COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
