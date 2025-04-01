FROM docker.io/library/debian:bookworm-slim

ARG VERSION

ENV \
    DEBIAN_FRONTEND=noninteractive \
    TZ="Etc/UTC" \
    UMASK="002" \

WORKDIR /tmp

#hadolint ignore=DL3018,DL3013
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        ffmpeg \
        libsqlite3-0 \
        libssl3 \
        libicu72 \
        fontconfig \
        libfreetype6 \
        libass9 \
    && \
    rm -rf /var/lib/apt/lists/*

RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') ARCH='amd64' ;; \
        'linux/arm64') ARCH='arm64' ;; \
        *) ARCH='amd64' ;; \
    esac && \
    curl -fSL "https://github.com/MediaBrowser/Emby.Releases/releases/download/${VERSION}/emby-server-deb_${VERSION}_${ARCH}.deb" -o emby-server.deb && \
    dpkg --unpack emby-server.deb && \
    rm -rf /usr/lib/systemd /var/lib/dpkg/info/emby-server.postinst && \
    dpkg --configure -a && \
    apt-get install -fy && \
    rm emby-server.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY entrypoint.sh /entrypoint.sh

RUN \
    mkdir /config && \
    echo "EMBY_DATA=/config" > /etc/emby-server.conf && \
    chmod +x /entrypoint.sh && \
    chown -R nobody:nogroup /config

VOLUME ["/config"]
USER nobody:nogroup

ENTRYPOINT ["/entrypoint.sh"]
