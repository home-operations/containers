# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine
ARG TARGETARCH
ARG HOME_ASSISTANT_ARCH=${TARGETARCH/arm64/aarch64}
ARG VERSION

ENV UMASK="0002" \
    TZ="Etc/UTC"

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    UV_SYSTEM_PYTHON=true \
    UV_NO_CACHE=true \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    HOMEASSISTANT_WHEELS="https://wheels.home-assistant.io/musllinux/" \
    HOME="/config" \
    PYTHONUSERBASE="/usr/local" \
    VENV_FOLDER="/config/.venv"

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
        cups-libs \
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
        xz \
    && \
    apk add --no-cache --virtual=.build-deps \
        autoconf \
        build-base \
        libffi-dev \
    && \
    pip install uv \
    && \
    curl -fsSL "https://github.com/home-assistant/core/archive/${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components=1 \
    && \
    HOME_ASSISTANT_BASE=$(curl -fsSL "https://raw.githubusercontent.com/home-assistant/core/${VERSION}/build.yaml" | grep "${HOME_ASSISTANT_ARCH}: " | cut -d ":" -f3) \
    && \
    uv pip install --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HOME_ASSISTANT_BASE}/requirements.txt" \
    && \
    uv pip install --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        --requirement /tmp/requirements_all.txt \
    && \
    uv pip install --only-binary=:all: --find-links "${HOMEASSISTANT_WHEELS}" \
        homeassistant=="${VERSION}" \
    && curl -fsSL -o /bin/go2rtc \
        "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_${TARGETARCH}" \
    && chmod +x /bin/go2rtc \
    && mkdir -p /config && chown nobody:nogroup -R /config \
    && apk del --purge .build-deps \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
