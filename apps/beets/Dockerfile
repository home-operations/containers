# syntax=docker/dockerfile:1

FROM docker.io/library/node:16-alpine3.18 AS betanin
WORKDIR /src
ADD https://github.com/sentriz/betanin.git .
WORKDIR /src/betanin_client
ENV PRODUCTION=true
RUN npm install && npm run-script build

FROM docker.io/library/python:3.12-alpine
ARG VERSION

WORKDIR /src

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    UV_SYSTEM_PYTHON=true \
    UV_NO_CACHE=true \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV HOME=/config \
    BETANIN_HOST=0.0.0.0 \
    BETANIN_PORT=8080 \
    FPCALC=/usr/bin/fpcalc

RUN \
    apk add --no-cache \
        bash \
        catatonit \
        chromaprint \
        curl \
        expat \
        ffmpeg \
        ffmpeg-libs \
        fftw \
        flac \
        gdbm \
        gst-plugins-good \
        gstreamer \
        imagemagick \
        jpeg \
        jq \
        keyfinder-cli \
        lame \
        libev \
        libffi \
        libpng \
        mpg123 \
        openjpeg \
        sqlite-libs \
        tzdata \
    && \
    apk add --no-cache --virtual=.build-deps \
        git \
    && \
    apk add --no-cache --repository="https://dl-cdn.alpinelinux.org/alpine/edge/testing/" \
        mp3gain \
        mp3val \
    && \
    pip install uv \
    && \
    uv pip install \
        https://github.com/beetbox/beets/releases/download/${VERSION}/beets-${VERSION#*v}-py3-none-any.whl \
        git+https://github.com/sentriz/betanin.git \
    && pip uninstall --yes uv \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

COPY --from=betanin /src/betanin_client/dist/ /usr/local/lib/python3.12/site-packages/betanin_client/dist/
COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
