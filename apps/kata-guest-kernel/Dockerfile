# syntax=docker/dockerfile:1

ARG VERSION

FROM docker.io/library/debian:trixie-slim AS build
ARG VERSION
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bc bison build-essential ca-certificates curl flex libelf-dev \
        libssl-dev python3 xz-utils zstd \
    && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /build

# Kata's guest kernel .config and the upstream default QEMU runtime config
RUN \
    curl -fsSL "https://github.com/kata-containers/kata-containers/releases/download/${VERSION}/kata-static-${VERSION}-amd64.tar.zst" \
        | zstd -d \
        | tar -x ./opt/kata/share/kata-containers ./opt/kata/share/defaults/kata-containers

# Kata ships several kernel configs (-debug, -nvidia-gpu, -dragonball-experimental);
# the regex selects only the plain one, which is what the extension's
# vmlinux.container is built from. The kernel version comes from that file name,
# so it cannot drift from what the guest image and agent expect.
RUN \
    cfg="$(find opt/kata/share/kata-containers -maxdepth 1 -regextype posix-extended -regex '.*/config-[0-9.]+-[0-9]+' -print -quit)" \
    && [[ -n "${cfg}" ]] \
    && kver="${cfg##*/}" \
    && kver="${kver#config-}" \
    && kver="${kver%-*}" \
    && [[ "${kver}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] \
    && echo "kata ${VERSION} guest kernel ${kver} from ${cfg}" \
    && cp "${cfg}" /config-kata \
    && mkdir -p /build/linux \
    && curl -fsSL "https://cdn.kernel.org/pub/linux/kernel/v${kver%%.*}.x/linux-${kver}.tar.xz" \
        | tar -xJ --strip-components=1 -C /build/linux

WORKDIR /build/linux

# Kata's own config plus KVM host support, and the traffic-control pieces the
# Talos QEMU provisioner's tc-redirect-tap CNI plugin needs: Kata enables
# CONFIG_NET_SCHED but not the ingress qdisc, so `tc qdisc add ingress` fails
# with ENOENT. The asserts fail the build rather than shipping a kernel that
# silently cannot nest or cannot wire up a VM's network.
RUN \
    cp /config-kata .config \
    && ./scripts/config --enable CONFIG_VIRTUALIZATION \
                        --enable CONFIG_KVM \
                        --enable CONFIG_KVM_INTEL \
                        --enable CONFIG_KVM_AMD \
                        --enable CONFIG_NET_CLS_ACT \
                        --enable CONFIG_NET_SCH_INGRESS \
                        --enable CONFIG_NET_CLS_U32 \
                        --enable CONFIG_NET_ACT_MIRRED \
    && make olddefconfig \
    && grep -q '^CONFIG_KVM=y' .config \
    && grep -q '^CONFIG_KVM_INTEL=y' .config \
    && grep -q '^CONFIG_NET_SCH_INGRESS=y' .config \
    && grep -q '^CONFIG_NET_CLS_U32=y' .config \
    && grep -q '^CONFIG_NET_ACT_MIRRED=y' .config \
    && make -j"$(nproc)" vmlinux \
    && cp vmlinux /vmlinux-nested

WORKDIR /build

# The two rewrites the siderolabs/kata-containers extension applies to the
# upstream default, plus the kernel path. The result is byte-identical to the
# extension's configuration-qemu.toml except for that one line.
RUN \
    sed -e 's|/opt/kata|/usr/local|g' \
        -e 's|^firmware_volume = .*|firmware_volume = ""|' \
        -e 's|^kernel = .*|kernel = "/var/lib/kata-nested/vmlinux-nested"|' \
        opt/kata/share/defaults/kata-containers/configuration-qemu.toml \
        > /configuration-qemu.toml \
    && grep -q '^kernel = "/var/lib/kata-nested/vmlinux-nested"$' /configuration-qemu.toml \
    && grep -q '^path = "/usr/local/bin/qemu-system-x86_64"$' /configuration-qemu.toml \
    && ! grep -q '/opt/kata' /configuration-qemu.toml

FROM docker.io/library/alpine:3.24

ENV KATA_GUEST_KERNEL_DIR=/host/var/lib/kata-nested

RUN \
    apk add --no-cache \
        rsync \
    && rm -rf /tmp/*

COPY --from=build /vmlinux-nested /artifacts/vmlinux-nested
COPY --from=build /configuration-qemu.toml /artifacts/configuration-qemu.toml

# rsync writes to a temporary file and renames, so a booted VM keeps its open
# inode, and unchanged artifacts are not recopied on every pod start
# hadolint ignore=DL3025
CMD rsync -a /artifacts/ $KATA_GUEST_KERNEL_DIR/
