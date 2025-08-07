# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22 as bw-cli
ARG VERSION
RUN \
  apk add --no-cache \
    jq \
    curl \
    zip && \
  mkdir -p /tmp /out && \
  curl -o \
    /tmp/bw.zip -L \
      "https://github.com/bitwarden/clients/releases/download/cli-v${VERSION}/bw-linux-${VERSION}.zip" && \
  unzip -q /tmp/bw.zip -d /out

FROM docker.io/library/alpine:3.22
COPY --from=bw-cli /out /usr/sbin/

USER nobody:nogroup
COPY ./entrypoint.sh /entrypoint.sh
COPY ./healthcheck.sh /healthcheck.sh

CMD ["/entrypoint.sh"]
