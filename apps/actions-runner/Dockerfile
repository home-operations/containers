ARG VERSION
FROM ghcr.io/actions/actions-runner:${VERSION}
ARG TARGETARCH

ENV HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_ENV_HINTS=1 \
    HOMEBREW_NO_INSTALL_CLEANUP=1 \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

USER root

RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        curl \
        jo \
        moreutils \
        wget \
        zstd \
    && \
    case "${TARGETARCH}" in \
        'amd64') apt-get -qq install -y --no-install-recommends --no-install-suggests gcc ;; \
    esac \
    && \
    curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${TARGETARCH}" -o /usr/local/bin/yq \
        && chmod +x /usr/local/bin/yq \
    && \
    mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && apt update \
        && apt install gh -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER runner

RUN \
    case "${TARGETARCH}" in \
        'amd64') /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" ;; \
    esac
