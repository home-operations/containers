# syntax=docker/dockerfile:1

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
FROM ghcr.io/home-assistant/${ARCH}-base-python:3.14-alpine3.24

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_EXTRA_INDEX_URL="https://wheels.home-assistant.io/musllinux-index/"

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        binutils \
        bluez \
        bluez-deprecated \
        bluez-libs \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        eudev-libs \
        ffmpeg \
        git \
        grep \
        hwdata-usb \
        imlib2 \
        iperf3 \
        iputils \
        jq \
        libcap \
        libftdi1 \
        libgpiod \
        libturbojpeg \
        libpulse \
        libstdc++ \
        libxslt \
        libzbar \
        mailcap \
        mariadb-connector-c \
        nano \
        net-tools \
        nmap \
        openssh-client \
        openssl \
        pianobar \
        postgresql-libs \
        pulseaudio-alsa \
        socat \
        tiff \
        tzdata \
        unzip \
        xz

COPY --from=ghcr.io/alexxit/go2rtc:1.9.14@sha256:675c318b23c06fd862a61d262240c9a63436b4050d177ffc68a32710d9e05bae /usr/local/bin/go2rtc /bin/go2rtc

ARG VERSION
RUN \
    go2rtc --version \
    && curl -fsSL --create-dirs -o /tmp/core/requirements.txt \
        "https://raw.githubusercontent.com/home-assistant/core/refs/tags/${VERSION}/requirements.txt" \
    && curl -fsSL --create-dirs -o /tmp/core/requirements_all.txt \
        "https://raw.githubusercontent.com/home-assistant/core/refs/tags/${VERSION}/requirements_all.txt" \
    && curl -fsSL --create-dirs -o /tmp/core/homeassistant/package_constraints.txt \
        "https://raw.githubusercontent.com/home-assistant/core/refs/tags/${VERSION}/homeassistant/package_constraints.txt" \
    && pip install "uv==$(awk -F'==' '/^uv==/{print $2}' /tmp/core/requirements.txt)" \
    && HA_BASE=$(curl -fsSL "https://raw.githubusercontent.com/home-assistant/core/refs/tags/${VERSION}/.github/workflows/builder.yml" | grep "BASE_IMAGE_VERSION: " | cut -d '"' -f2) \
    && uv pip install --system --only-binary=:all: \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HA_BASE}/requirements.txt" \
    && uv pip install --system --only-binary=:all: --requirement /tmp/core/requirements_all.txt \
    && uv pip install --system --only-binary=:all: homeassistant=="${VERSION}" \
    && python3 -m compileall -q /usr/local/lib/python3*/site-packages/homeassistant \
    && mkdir -p /config && chown nobody:nogroup -R /config \
    && rm -rf /root/.cache /root/.local /tmp/*

COPY . /

ENV HOME="/config" \
    PYTHONUSERBASE="/usr/local" \
    VENV_FOLDER="/config/.venv"

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
