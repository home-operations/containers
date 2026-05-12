#!/usr/bin/env bash

CONFIG_FILE="/config/qBittorrent/qBittorrent.conf"
LOG_FILE="/config/qBittorrent/logs/qbittorrent.log"
LOCK_FILE="/config/qBittorrent/lockfile"

# Ensure the config file exists, copy default if missing
if [[ ! -f "${CONFIG_FILE}" ]]; then
    mkdir -p "${CONFIG_FILE%/*}"
    cp /defaults/qBittorrent.conf "${CONFIG_FILE}"
fi

# Set up log file to redirect to stdout
if [[ ! -f "${LOG_FILE}" ]]; then
    mkdir -p "${LOG_FILE%/*}"
    ln -sf /proc/self/fd/1 "${LOG_FILE}"
fi

# Clean up stale lockfile
if [[ -f "${LOCK_FILE}" ]]; then
    echo "Removing stale lockfile..."
    rm -rf "${LOCK_FILE}"
fi

# Execute qBittorrent
exec /app/qbittorrent-nox "$@"
