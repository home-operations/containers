# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.24 AS build
ARG TARGETARCH
ARG VERSION
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

WORKDIR /tmp

# droast ignore=DF057
RUN \
    apk add --no-cache \
        curl \
        jq \
        unzip; \
    case "${TARGETARCH}" in \
        amd64) arch=x86_64 ;; \
        arm64) arch=aarch64 ;; \
    esac; \
    assets='.assets[] | select(.name | endswith("_\($arch)-linux-gnu.zip"))'; \
    curl -fsSL -o release.json "https://api.github.com/repos/pgsty/vchord/releases/tags/${VERSION}"; \
    jq --raw-output --arg arch "${arch}" "${assets}"' | .browser_download_url' release.json \
        | xargs curl -fsSL --remote-name-all; \
    jq --raw-output --arg arch "${arch}" "${assets}"' | "\(.digest | ltrimstr("sha256:"))  \(.name)"' release.json \
        | sha256sum -c -; \
    for zip in postgresql-*.zip; do \
        pg="${zip#postgresql-}"; \
        pg="${pg%%-*}"; \
        unzip -q "${zip}" -d "${pg}"; \
        install -D -m 0755 "${pg}/pkglibdir/vchord.so" "/rootfs/usr/lib/postgresql/${pg}/lib/vchord.so"; \
        install -D -m 0644 -t "/rootfs/usr/share/postgresql/${pg}/extension" "${pg}"/sharedir/extension/*; \
        install -D -m 0644 "${pg}/LICENSE" /rootfs/usr/share/doc/vchord/LICENSE; \
    done

FROM scratch
COPY --from=build /rootfs/ /
