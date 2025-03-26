FROM docker.io/library/alpine:3.21

ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    POWERSHELL_DISTRIBUTION_CHANNEL="PSDocker" \
    VIRTUAL_ENV="/lsiopy"

RUN \
    apk add --no-cache \
        curl \
        imagemagick  \
        imagemagick-heic \
        imagemagick-jpeg \
        libjpeg-turbo \
        powershell \
        tzdata \
    && \
    pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
                   Install-Module -Name FanartTvAPI -Scope AllUsers -Force" && \
    chmod -R 755 /usr/local/share/powershell && \
    mkdir -p /config && \
    chmod 755 /config && \
    curl -fsSL https://github.com/fscorrupt/Posterizarr/archive/refs/tags/${VERSION}.tar.gz \
        | tar xzf - -C /config --strip-components=1 && \
    rm -rf /config/images && \
    find /config -type f \( -name "*.md" -o -name "*.zip" -o -name "*.yml" -o -name ".*" \) -delete && \
    chown -R nobody:nogroup /config


COPY entrypoint.sh /entrypoint.sh

USER nobody:nogroup

WORKDIR /config

VOLUME ["/config", "/assets", "/assetsbackup", "/manualassets"]

ENTRYPOINT ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/fscorrupt/Posterizarr"
LABEL org.opencontainers.image.description="Posterizarr - Automated poster generation for Plex/Jellyfin/Emby media libraries"
LABEL org.opencontainers.image.licenses="GPL-3.0"
