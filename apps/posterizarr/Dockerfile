# Single-stage Dockerfile for Posterizarr with ImageMagick
FROM docker.io/library/ubuntu:24.04

# Build arguments
ARG TARGETARCH
ARG VENDOR
ARG VERSION
ARG POWERSHELL_VERSION=7.5.0

# Set environment variables
ENV UMASK="0002" \
    TZ="Etc/UTC" \
    DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install all dependencies
RUN apt-get update && apt-get install -y \
    # Build tools
    build-essential \
    pkg-config \
    # Common utilities
    curl \
    jq \
    unzip \
    locales \
    software-properties-common \
    tzdata \
    apt-transport-https \
    ghostscript \
    gsfonts \
    # Development libraries for ImageMagick
    libltdl-dev \
    libperl-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libwebp-dev \
    libheif-dev \
    libde265-dev \
    libx265-dev \
    libopenjp2-7-dev \
    libgomp1 \
    libxml2-dev \
    libmagickcore-dev \
    # Set up locale
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Download and install the latest release of ImageMagick
RUN set -e && \
    echo "Fetching latest ImageMagick release..." && \
    LATEST_TAG=$(curl -s https://api.github.com/repos/ImageMagick/ImageMagick/releases/latest | jq -r .tag_name) && \
    echo "Latest ImageMagick version: ${LATEST_TAG}" && \
    DOWNLOAD_URL="https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${LATEST_TAG}.tar.gz" && \
    mkdir -p /tmp/imagemagick && \
    cd /tmp/imagemagick && \
    echo "Downloading from: ${DOWNLOAD_URL}" && \
    curl -L -o imagemagick.tar.gz "$DOWNLOAD_URL" && \
    tar xzf imagemagick.tar.gz && \
    EXTRACTED_DIR=$(ls -d ImageMagick-* | head -n 1) && \
    echo "Building from directory: ${EXTRACTED_DIR}" && \
    cd "$EXTRACTED_DIR" && \
    echo "Configuring ImageMagick..." && \
    ./configure --with-modules --enable-shared --with-perl --with-xml && \
    echo "Compiling ImageMagick (using $(nproc) cores)..." && \
    make -j$(nproc) && \
    echo "Installing ImageMagick..." && \
    make install && \
    ldconfig /usr/local/lib && \
    # Clean up build files to reduce image size
    cd /tmp && \
    rm -rf /tmp/imagemagick

# Install PowerShell - using repository for amd64 and binary archives for arm64
RUN set -e && \
    # Install common dependencies
    apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl && \
    # Architecture-specific installation
    case "${TARGETARCH}" in \
        "amd64") \
            echo "Installing PowerShell for AMD64 using repository..." && \
            apt-get install -y gnupg && \
            mkdir -p /etc/apt/keyrings && \
            curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/24.04/prod noble main" > /etc/apt/sources.list.d/microsoft.list && \
            apt-get update && \
            apt-get install -y powershell \
            ;; \
        "arm64") \
            echo "Installing PowerShell for ARM64 using binary archives..." && \
            POWERSHELL_PACKAGE="powershell-${POWERSHELL_VERSION}-linux-arm64.tar.gz" && \
            POWERSHELL_DOWNLOAD_URL="https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/${POWERSHELL_PACKAGE}" && \
            curl -L -o "/tmp/${POWERSHELL_PACKAGE}" "${POWERSHELL_DOWNLOAD_URL}" && \
            mkdir -p /opt/microsoft/powershell/7 && \
            tar zxf "/tmp/${POWERSHELL_PACKAGE}" -C /opt/microsoft/powershell/7 && \
            chmod +x /opt/microsoft/powershell/7/pwsh && \
            ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
            rm -f "/tmp/${POWERSHELL_PACKAGE}" \
            ;; \
        *) \
            echo "Unsupported architecture: ${TARGETARCH}" && exit 1 \
            ;; \
    esac && \
    # Verify installation
    pwsh --version && \
    # Clean up
    rm -rf /var/lib/apt/lists/*

# Set up PowerShell modules with error handling
RUN set -e && \
    echo "Setting up PowerShell modules..." && \
    # Verify PowerShell installation
    pwsh --version && \
    # Set PSGallery to trusted
    pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted" && \
    # Install FanartTV PowerShell Module with better error handling
    pwsh -Command "Install-Module -Name FanartTvAPI -Scope AllUsers -Force -Verbose" && \
    pwsh -Command "if (-not (Get-Module -ListAvailable -Name FanartTvAPI)) { Write-Error 'FanartTvAPI module installation failed!'; exit 1 }" && \
    pwsh -Command "Import-Module FanartTvAPI -Force" && \
    pwsh -Command "if (-not (Get-Command -Name Add-FanartTvAPIKey -ErrorAction SilentlyContinue)) { Write-Error 'Add-FanartTvAPIKey function not found!'; exit 1 }" && \
    # Find the module path and ensure it's accessible to nobody user
    pwsh -Command "\$modulePath = (Get-Module -ListAvailable -Name FanartTvAPI).Path; \$moduleDir = Split-Path -Parent \$modulePath; Write-Host \"Module directory: \$moduleDir\"" && \
    # Make PowerShell modules accessible to nobody user
    chmod -R 755 /usr/local/share/powershell && \
    chmod -R 755 /opt/microsoft/powershell && \
    echo "PowerShell modules setup completed successfully"

# Create config directory with correct permissions
RUN mkdir -p /config && chmod 755 /config

# Download the repository at the specific tag using the VERSION variable
ADD https://github.com/fscorrupt/Posterizarr/archive/refs/tags/${VERSION}.tar.gz /tmp/posterizarr.tar.gz

# Extract the tar.gz file
RUN tar -xzf /tmp/posterizarr.tar.gz -C /tmp && \
    EXTRACTED_DIR=$(ls -d /tmp/Posterizarr-* | head -n 1) && \
    cp -r ${EXTRACTED_DIR}/* /config/ && \
    rm -rf /tmp/posterizarr.tar.gz ${EXTRACTED_DIR}

# Copy local entrypoint.sh file
COPY entrypoint.sh /entrypoint.sh

# Set permissions and ownership
RUN chmod +x /entrypoint.sh && chown -R nobody:nogroup /config /entrypoint.sh

# Switch to non-root user
USER nobody:nogroup

# Set working directory
WORKDIR /config

# Set up volumes
VOLUME ["/config", "/assets", "/assetsbackup", "/manualassets"]

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/fscorrupt/Posterizarr"
LABEL org.opencontainers.image.description="Posterizarr - Automated poster generation for Plex/Jellyfin/Emby media libraries"
LABEL org.opencontainers.image.licenses="GPL-3.0"
