# syntax=docker/dockerfile:1

FROM docker.io/library/node:22-alpine AS builder
ARG VERSION

WORKDIR /tmp

RUN \
  apk add --no-cache \
      curl \
      git \
  && \
  git clone -b ${VERSION} --single-branch https://github.com/CorentinTh/it-tools.git . \
  && npm install -g corepack@latest \
  && corepack enable  \
  && corepack prepare pnpm@latest --activate \
  && pnpm install --prefer-offline \
  && pnpm build

FROM ghcr.io/nginxinc/nginx-unprivileged:1.27-alpine
ENV NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE=1
COPY --from=builder --chown=nginx:nginx /tmp/dist/ /usr/share/nginx/html
USER nginx
WORKDIR /usr/share/nginx/html
