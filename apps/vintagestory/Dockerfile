# Modified from: https://github.com/Commandcracker/vintagestory-docker/blob/main/Dockerfile
FROM alpine:3.21 AS base
FROM base AS build

ARG VERSION
ARG CHANNEL=stable
ARG TARGETARCH

WORKDIR /app

RUN set -eux; \
    apk add --no-cache \
        # Required to fix sqlite
        sqlite-libs \
        # Update zstd
        zstd-dev \
        #fontconfig-dev freetype-dev \
        # Required for download of vintagestory
        curl tar \
        jq && \
    case "${TARGETARCH}" in \
        "linux/amd64") export TARGETARCH_URL="linux-x64" ;; \
        "linux/arm64") export TARGETARCH_URL="linux-arm64" ;; \
        *) export TARGETARCH_URL="${TARGETARCH}" ;; \
    esac && \
    curl -sL https://cdn.vintagestory.at/gamefiles/${CHANNEL}/vs_server_${TARGETARCH_URL}_${VERSION}.tar.gz | tar -xvzf - && \
    # Remove unnecessary files to reduce image size [-2,2 MB]
    rm VintagestoryAPI.xml credits.txt server.sh VintagestoryServer.deps.json VintagestoryServer && \
    # Minify json files [-37.5 MB]
    # TODO: see https://wiki.vintagestory.at/Modding:JSON_Patching
    find . -type f -name "*.json" -exec sh -c 'jq -c . "$1" > "$1.min" && mv "$1.min" "$1"' _ {} \;

WORKDIR /opt/dlls

RUN set -eux; \
    curl -Lo system.formats.asn1.nupkg https://www.nuget.org/api/v2/package/System.Formats.Asn1/8.0.1 && \
    unzip -j system.formats.asn1.nupkg lib/net7.0/System.Formats.Asn1.dll -d . & \
    curl -Lo system.drawing.common.nupkg https://www.nuget.org/api/v2/package/System.Drawing.Common/4.7.2 && \
    unzip -j system.drawing.common.nupkg lib/netstandard2.0/System.Drawing.Common.dll -d . & \
    curl -Lo system.text.json.nupkg https://www.nuget.org/api/v2/package/System.Text.Json/8.0.5 && \
    unzip -j system.text.json.nupkg lib/net7.0/System.Text.Json.dll -d . & \
    wait

FROM base

RUN set -eux && \
    echo "app:x:1654:app" >> /etc/group && \
    echo "app:!:20175:0:99999:7:::" >> /etc/passwd && \
    mkdir /app/vintagestory && chown 1654:1654 /app/vintagestory && \
    apk add --no-cache gcompat && \
    #apk add --no-cache fontconfig-static openal-soft-libs && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.19/community dotnet7-runtime

WORKDIR /opt/vintagestory

COPY --from=build /opt/vintagestory .
# Required to fix sqlite
COPY --from=build /usr/lib/libsqlite3.so.0 ./Lib/libe_sqlite3.so
# Update zstd [increases the image size a bit]
COPY --from=build /usr/lib/libzstd.so ./Lib/libzstd.so

# libfontconfig.so.1
#COPY --from=build /usr/lib/libfontconfig.so /usr/lib/libfontconfig.so.1
#COPY --from=build /usr/lib/libfreetype.so.6 /usr/lib/libfreetype.so.6
#RUN mv /usr/lib/libfontconfig.a /usr/lib/libfontconfig.so.1
# https://nuget.info/packages/SkiaSharp.NativeAssets.Linux/2.88.9
#COPY libSkiaSharp.so ./Lib/libSkiaSharp.so

# openal-soft-libs
RUN rm ./Lib/libopenal.so.1

# CVE-2021-24112
COPY --from=build /opt/dlls/System.Drawing.Common.dll /opt/vintagestory/Lib/System.Drawing.Common.dll
# CVE-2024-38095
COPY --from=build /opt/dlls/System.Formats.Asn1.dll /usr/lib/dotnet/shared/Microsoft.NETCore.App/7.0.20/System.Formats.Asn1.dll
# CVE-2024-30105
COPY --from=build /opt/dlls/System.Text.Json.dll /usr/lib/dotnet/shared/Microsoft.NETCore.App/7.0.20/System.Text.Json.dll

EXPOSE 42420/tcp 42420/udp

ENV \
    APP_UID=1654 \
    DOTNET_VERSION=7.0.20 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

USER nobody:nogroup

ENTRYPOINT ["dotnet", "VintagestoryServer.dll", "--dataPath", "/data"]

# https://mods.vintagestory.at/vsmodcli
