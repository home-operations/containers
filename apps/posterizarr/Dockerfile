FROM docker.io/library/alpine:3.21

# Build arguments
ARG TARGETARCH
ARG VENDOR
ARG VERSION

# Set environment variables
ENV UMASK="0002" \
    TZ="Etc/UTC" \
    DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    POWERSHELL_DISTRIBUTION_CHANNEL="PSDocker" \
    VIRTUAL_ENV="/lsiopy"

# Install dependencies and set up the application
RUN apk add --no-cache curl imagemagick  imagemagick-heic imagemagick-jpeg libjpeg-turbo powershell tzdata && \
    # Set up PowerShell modules
    echo "Setting up PowerShell modules..." && \
    # Verify PowerShell installation
    pwsh --version && \
    # Set PSGallery to trusted and install module
    pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
                   Install-Module -Name FanartTvAPI -Scope AllUsers -Force; \
                   if (-not (Get-Module -ListAvailable -Name FanartTvAPI)) { Write-Error 'FanartTvAPI module installation failed!'; exit 1 }; \
                   Import-Module FanartTvAPI -Force; \
                   if (-not (Get-Command -Name Add-FanartTvAPIKey -ErrorAction SilentlyContinue)) { Write-Error 'Add-FanartTvAPIKey function not found!'; exit 1 }; \
                   \$modulePath = (Get-Module -ListAvailable -Name FanartTvAPI).Path; \
                   \$moduleDir = Split-Path -Parent \$modulePath; \
                   Write-Host \"Module directory: \$moduleDir\"" && \
    # Make PowerShell modules accessible to nobody user
    chmod -R 755 /usr/local/share/powershell && \
    # Create config directory with correct permissions
    mkdir -p /config && chmod 755 /config && \
    echo "PowerShell modules setup completed successfully" && \
    # Download the repository
    curl -L -o /tmp/posterizarr.tar.gz https://github.com/fscorrupt/Posterizarr/archive/refs/tags/${VERSION}.tar.gz && \
    tar -xzf /tmp/posterizarr.tar.gz -C /tmp && \
    EXTRACTED_DIR=$(ls -d /tmp/Posterizarr-* | head -n 1) && \
    cp -r ${EXTRACTED_DIR}/* /config/ && \
    rm -rf /tmp/posterizarr.tar.gz ${EXTRACTED_DIR} && \
    # Update necessary directories with proper permissions
    chown -R nobody:nogroup /config

# Copy entrypoint script and set permissions
COPY entrypoint.sh /entrypoint.sh
RUN chown -R nobody:nogroup /config /entrypoint.sh

# Switch to non-root user
USER nobody:nogroup

# Set working directory
WORKDIR /config

# Set up volumes
VOLUME ["/config", "/assets", "/assetsbackup", "/manualassets"]

# Set entrypoint to our script
ENTRYPOINT ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/fscorrupt/Posterizarr"
LABEL org.opencontainers.image.description="Posterizarr - Automated poster generation for Plex/Jellyfin/Emby media libraries"
LABEL org.opencontainers.image.licenses="GPL-3.0"
