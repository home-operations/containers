#!/usr/bin/env bash
#shellcheck disable=SC2086,SC2090

CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"
LOG_FILE="/config/qBittorrent/logs/qbittorrent.log"

# Ensure the config file exists, copy default if missing
if [[ ! -f "${CONFIG_FILE}" ]]; then
    mkdir -p "${CONFIG_FILE%/*}"
    cp /qBittorrent.conf "${CONFIG_FILE}"
fi

# Set up log file to redirect to stdout
if [[ ! -f "${LOG_FILE}" ]]; then
    mkdir -p "${LOG_FILE%/*}"
    ln -sf /proc/self/fd/1 "${LOG_FILE}"
fi

# Execute qBittorrent
exec /usr/bin/qbittorrent-nox "$@"
