FROM docker.io/library/amazoncorretto:17-alpine3.21

ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV JAVA_TOOL_OPTIONS="-Xmx256M"

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        freetype \
        jq \
        nano \
        tzdata \
        unzip \
    && mkdir -p /app/bin \
    && curl -fsSL -o /tmp/nzbhydra2.zip \
        "https://github.com/theotherp/nzbhydra2/releases/download/${VERSION}/nzbhydra2-${VERSION#*v}-generic.zip" \
    && unzip -q /tmp/nzbhydra2.zip -d /tmp \
    && cp /tmp/lib/core-${VERSION#*v}-exec.jar /app/bin/nzbhydra2.jar \
    && mkdir -p /defaults \
    && curl -fsSL -o /defaults/nzbhydra.yml \
      "https://raw.githubusercontent.com/theotherp/nzbhydra2/${VERSION}/core/src/main/resources/config/baseConfig.yml" \
    && sed -i 's/mapIpToHost: true/mapIpToHost: false/' /defaults/nzbhydra.yml \
    && sed -i 's/checkOpenPort: true/checkOpenPort: false/' /defaults/nzbhydra.yml \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
