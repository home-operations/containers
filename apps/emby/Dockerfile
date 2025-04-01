FROM docker.io/library/ubuntu:24.04

ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="DontWarn"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3013
RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        bash \
        ca-certificates \
        catatonit \
        curl \
        ffmpeg \
        fontconfig \
        jo \
        jq \
        libicu72 \
        libfreetype6 \
        libsqlite3-0 \
        libssl3 \
        libass9 \
        nano \
        tzdata \
    && \
    curl -fsSL -o /tmp/emby-server.deb \
        "https://github.com/MediaBrowser/Emby.Releases/releases/download/${VERSION}/emby-server-deb_${VERSION}_${TARGETARCH}.deb" \
    && \
    dpkg -i /tmp/emby-server.deb \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && echo "EMBY_DATA=/config" > /etc/emby-server.conf \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /usr/lib/systemd /var/lib/dpkg/info/emby-server.postinst /var/lib/apt/lists/* /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
