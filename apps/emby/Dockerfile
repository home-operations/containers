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
        jo \
        jq \
        nano \
        tzdata \
    && \
    mkdir -p /app/emby /tmp/emby \
    && \
    curl -fsSL -o /tmp/emby.deb \
        "https://github.com/MediaBrowser/Emby.Releases/releases/download/${VERSION}/emby-server-deb_${VERSION}_${TARGETARCH}.deb" \
    && \
    dpkg-deb -xv /tmp/emby.deb /tmp/emby/ \
    && mv -t /app/emby/ /tmp/emby/opt/emby-server/* \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
