# syntax=docker/dockerfile:1

FROM docker.io/library/ubuntu:24.04
ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV DEBIAN_FRONTEND="noninteractive" \
    UMASK="0002" \
    TZ="Etc/UTC"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    NVIDIA_VISIBLE_DEVICES="all" \
    LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri" \
    LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    # Default run mode: server
    MODE="server"

USER root

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        # Install
        curl \
        unzip \
        # Needed to run
        aspnetcore-runtime-8.0 \
        ca-certificates \
        catatonit \
        pciutils \
        vainfo; \
    # Install Fileflows
    curl -fsSL "https://fileflows.com/downloads/Zip/${VERSION}" -o /tmp/fileflows.zip \
    && unzip -q /tmp/fileflows.zip -d /app \
    && chmod -R 755 "/app"; \
    # Clean up unnecessary packages
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        curl \
        unzip \
    && apt-get autoremove -y \
    && apt-get clean; \
    rm -rf /tmp/* /var/lib/apt/lists/*

COPY --from=ghcr.io/jellyfin/jellyfin:latest /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ghcr.io/jellyfin/jellyfin:latest /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe
COPY . /

USER nobody:nogroup
WORKDIR /app
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
