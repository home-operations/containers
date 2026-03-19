# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.23
ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV MESA_SHADER_CACHE_DIR="/tmp" \
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
        libdrm \
        libva \
        mesa-dri-gallium \
        mesa-va-gallium \
        tzdata \
        xmlstarlet \
    && \
    if [ "${TARGETARCH}" = "amd64" ]; then \
        apk add --no-cache \
            libva-intel-driver \
            intel-media-driver; \
    fi && \
    apk add --no-cache --virtual=.build-deps \
        dpkg \
    && \
    curl -fsSL -o /tmp/plex.deb \
        "https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_${TARGETARCH}.deb" \
    && \
    dpkg-deb -R /tmp/plex.deb /tmp \
    && cp -R /tmp/usr/* /usr \
    && mv "${PLEX_MEDIA_SERVER_HOME}/Plex Transcoder" "${PLEX_MEDIA_SERVER_HOME}/Plex Transcoder.orig" \
    && ln -s /scripts/Plex\ Transcoder "${PLEX_MEDIA_SERVER_HOME}/Plex Transcoder" \
    && mv "${PLEX_MEDIA_SERVER_HOME}/Plex Commercial Skipper" "${PLEX_MEDIA_SERVER_HOME}/Plex Commercial Skipper.orig" \
    && ln -s /scripts/Plex\ Commercial\ Skipper "${PLEX_MEDIA_SERVER_HOME}/Plex Commercial Skipper" \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
