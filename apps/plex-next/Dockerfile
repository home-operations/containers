# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.23
ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV LD_LIBRARY_PATH="/lib" \
    LIBVA_DRIVERS_PATH="/usr/lib/dri" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/config/Library/Application Support" \
    PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver" \
    PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6" \
    PLEX_MEDIA_SERVER_INFO_VENDOR="Docker" \
    PLEX_MEDIA_SERVER_INFO_DEVICE="Docker Container (${VENDOR})"

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        tzdata \
        xmlstarlet \
    && \
    apk add --no-cache \
        mesa-dri-gallium \
        mesa-va-gallium \
        $( [ "${TARGETARCH}" = "amd64" ] && echo intel-media-driver libva-intel-driver ) \
    && \
    apk add --no-cache --virtual=.build-deps \
        dpkg \
    && \
    curl -fsSL -o /tmp/plex.deb \
        "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_${TARGETARCH}.deb" \
    && dpkg-deb -R /tmp/plex.deb /tmp \
    && cp -R /tmp/usr/* /usr \
    && \
    apk fetch --no-cache --output /tmp \
        libdrm \
        libva \
    && tar zxvf /tmp/libdrm-*.apk --strip-components=1 -C "${PLEX_MEDIA_SERVER_HOME}" \
    && tar zxvf /tmp/libva-*.apk --strip-components=1 -C "${PLEX_MEDIA_SERVER_HOME}" \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
