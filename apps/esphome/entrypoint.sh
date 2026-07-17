#!/usr/bin/env bash

PLATFORMIO_CORE_DIR=${PLATFORMIO_CORE_DIR:-/cache/pio}
ESPHOME_BUILD_PATH=${ESPHOME_BUILD_PATH:-/cache/build}
ESPHOME_DATA_DIR=${ESPHOME_DATA_DIR:-/cache/data}

# Make sure cache folders exist
mkdir -p "${PLATFORMIO_CORE_DIR}"
mkdir -p "${ESPHOME_BUILD_PATH}"
mkdir -p "${ESPHOME_DATA_DIR}"

# Prune PIO files
pio system prune --force

# Set ESPHOME_CLI=true to run the esphome CLI (compile, run, logs, ...)
# instead of the Device Builder dashboard
if [[ "${ESPHOME_CLI:-false}" == "true" ]]; then
    exec /usr/local/bin/esphome "$@"
fi

# The dashboard was removed from esphome core in 2026.7.0 in favor of Device Builder.
# An empty --host binds IPv4 and IPv6 separately, like the old dashboard did;
# Device Builder defaults to 0.0.0.0 and an explicit "::" is IPv6-only
exec /usr/local/bin/esphome-device-builder --host "" "$@"
