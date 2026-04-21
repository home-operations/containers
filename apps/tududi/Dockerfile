# syntax=docker/dockerfile:1

FROM docker.io/library/node:24-alpine AS builder
ARG VERSION

RUN apk add --no-cache \
        bash \
        g++ \
        make \
        python3 \
        sqlite-dev

WORKDIR /build
RUN wget -qO- "https://github.com/chrisvel/tududi/archive/refs/tags/${VERSION}.tar.gz" \
    | tar xzf - --strip-components=1

# Install all dependencies (devDeps needed for webpack/tsc frontend build)
RUN npm install

# Build frontend → dist/
RUN NODE_ENV=production npm run frontend:build

# Prune devDependencies before copying to runtime image
RUN npm prune --omit=dev

FROM docker.io/library/node:24-alpine
ARG VERSION

RUN apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        nano \
        sqlite-libs \
        tzdata

COPY --from=builder /build/backend /app/backend
COPY --from=builder /build/node_modules /app/node_modules
COPY --from=builder /build/dist /app/backend/dist
COPY --from=builder /build/package.json /app/package.json

RUN chown -R root:root /app && chmod -R 755 /app \
    && mkdir -p /config && chown nobody:nogroup /config

COPY . /

ENV \
    DB_FILE=/config/tududi.sqlite3 \
    NODE_ENV=production \
    PORT=3002 \
    TUDUDI_UPLOAD_PATH=/config/uploads

USER nobody:nogroup
WORKDIR /app/backend
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
