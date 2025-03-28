FROM docker.io/library/python:3.13-alpine

ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC" \
    DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    POWERSHELL_DISTRIBUTION_CHANNEL="PSDocker"

RUN \
    apk add --no-cache \
        catatonit \
        curl \
        imagemagick  \
        imagemagick-heic \
        imagemagick-jpeg \
        libjpeg-turbo \
        powershell \
        tzdata \
    && \
    pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; \
        Install-Module -Name FanartTvAPI -Scope AllUsers -Force" \
    && chmod -R 755 /usr/local/share/powershell \
    && pip install apprise \
    && mkdir -p /app && chmod 755 /app \
    && \
    curl -fsSL https://github.com/fscorrupt/Posterizarr/archive/refs/tags/${VERSION}.tar.gz \
        | tar xzf - -C /app --strip-components=1 \
    && rm -rf /app/images \
    && find /app -type f \( -name "*.md" -o -name "*.zip" -o -name "*.yml" -o -name ".*" \) -delete


COPY entrypoint.sh /entrypoint.sh

USER nobody:nogroup

WORKDIR /app

VOLUME ["/app"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
