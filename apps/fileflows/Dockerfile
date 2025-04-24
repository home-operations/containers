FROM docker.io/library/ubuntu:24.04

ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV DEBIAN_FRONTEND="noninteractive" \
    UMASK="0002" \
    TZ="Etc/UTC"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true

USER root
WORKDIR /app

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        # Install
        apt-transport-https \
        curl \
        gnupg \
        curl \
        # Needed to run
        aspnetcore-runtime-8.0 \
        ca-certificates \
        catatonit \
        pciutils \
        vainfo \
    # Install jellyfin-ffmpeg7
    && curl -m15 -fsSL https://repo.jellyfin.org/debian/jellyfin_team.gpg.key \
        | gpg --dearmor -o /etc/apt/trusted.gpg.d/jellyfin.gpg \
    && . /etc/os-release \
    && echo "deb [arch=$(dpkg --print-architecture)] https://repo.jellyfin.org/$ID $VERSION_CODENAME main" \
        > /etc/apt/sources.list.d/jellyfin.list \
    && apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        jellyfin-ffmpeg7 \
    # Install Fileflows
    && curl -fsSL "https://fileflows.com/downloads/Zip/${VERSION}" -o /tmp/fileflows.zip \
    && unzip -q /tmp/fileflows.zip -d /app \
    && chmod -R 755 "/app" \
    # Clean up unnecessary packages
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        apt-transport-https \
        curl \
        gnupg \
        unzip \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

USER nobody:nogroup
WORKDIR /config
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
