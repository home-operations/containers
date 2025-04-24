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
    LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:/usr/lib/jellyfin-ffmpeg" \
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    # Default run mode: server
    FFNODE="0" \
    # Default port: 5000
    PORT="5000"

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
    && unzip -q /tmp/fileflows.zip -d /app; \
    # Clean up unnecessary packages
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        curl \
        unzip \
    && apt-get autoremove -y \
    && apt-get clean; \
    # Clean up image
    rm -rf /tmp/* /var/lib/apt/lists/* /app/{FlowRunner,Node,Server}/runtimes \
    /app/{FlowRunner,Node,Server}/*.exe /app/Server/Nodes \
    /app/*-upgrade*

# Install ffmpeg from Jellyfin for hardware support
COPY --from=ghcr.io/jellyfin/jellyfin:latest \
    /usr/lib/jellyfin-ffmpeg /usr/lib/jellyfin-ffmpeg
RUN ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg  /usr/local/bin/ffmpeg \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe

COPY . /
RUN chmod +x /entrypoint.sh

RUN \
    # Init directories
    mkdir -p /app/Plugins /app/DockerMods /app/common \
        /app/Logs /app/ManuallyAdded /app/Templates app/Data/Config \
    # Set perms
    && chown -R nobody:nogroup /app \
    && chmod -R 755 "/app"

USER nobody:nogroup
WORKDIR /app
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
