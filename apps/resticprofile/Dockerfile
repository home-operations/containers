# syntax=docker/dockerfile:1
FROM alpine:latest

ARG TARGETARCH
ARG VERSION

COPY --from=ghcr.io/creativeprojects/resticprofile:latest /usr/bin/restic /usr/bin/restic
COPY --from=ghcr.io/creativeprojects/resticprofile:latest /usr/bin/rclone /usr/bin/rclone

RUN apk add --no-cache ca-certificates curl logrotate openssh-client-default tzdata supercronic && \
    curl -fsSL -o /resticprofile.tar.gz https://github.com/creativeprojects/resticprofile/releases/download/v${VERSION}/resticprofile_${VERSION}_linux_${TARGETARCH}.tar.gz && \
    tar xvzf /resticprofile.tar.gz -C /usr/bin resticprofile && \
    rm /resticprofile.tar.gz && \
    chmod +x /usr/bin/restic /usr/bin/rclone /usr/bin/resticprofile && \
    adduser -D -h /resticprofile resticprofile && \
    mkdir -p /resticprofile && \
    touch /resticprofile/crontab && \
    chown -R resticprofile:resticprofile /resticprofile

USER resticprofile
VOLUME /resticprofile
WORKDIR /resticprofile

ENTRYPOINT ["resticprofile"]
CMD ["--help"]