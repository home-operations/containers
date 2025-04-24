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
    FFNODE="0" \
    # Default port: 5000
    PORT="5000"

USER root

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        # Uninstall before build
        apt-transport-https \
        curl \
        gnupg \
        unzip \
        # Needed for FF to run
        aspnetcore-runtime-8.0 \
        ca-certificates \
        catatonit \
        libfontconfig1 \
        libfreetype6 \
        pciutils \
        vainfo
# Install ffmpeg
RUN \
    VERSION_CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) \
    && curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key \
        | gpg --dearmor -o /etc/apt/trusted.gpg.d/jellyfin_team.gpg \
    && echo "deb [arch=${TARGETARCH}] https://repo.jellyfin.org/ubuntu ${VERSION_CODENAME} main" \
        > /etc/apt/sources.list.d/jellyfin.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        jellyfin-ffmpeg7 \
    # ffmpeg link
    && ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg7 \
    && ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe \
    && curl -fsSL "https://fileflows.com/downloads/Zip/${VERSION}" -o /tmp/fileflows.zip \
    && unzip -q /tmp/fileflows.zip -d /app
# Clean up unnecessary packages
RUN \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
        apt-transport-https \
        curl \
        gnupg \
        unzip \
    && apt-get autoremove -y \
    && apt-get clean

RUN \
     # Clean up image
     rm -rf /tmp/* /var/lib/apt/lists/* /app/{FlowRunner,Node,Server}/runtimes \
     /app/{FlowRunner,Node,Server}/*.exe /app/Server/Nodes /app/*.* \
    # Init directories
    && mkdir -p /app/Plugins /app/DockerMods /app/common \
        /app/Logs /app/ManuallyAdded /app/Templates app/Data/Config \
    && chown -R nobody:nogroup /app \
    && chmod -R 755 "/app"

COPY . /
RUN chmod +x /entrypoint.sh

USER nobody:nogroup
WORKDIR /app
VOLUME ["/app/Data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
