#!/usr/bin/env bash

# Only template the config file if our custom env variables are present
if env | grep -q "^TRANSMISSION__"; then
    minijinja-cli --env /defaults/settings.json.j2 > /config/settings.json
fi

exec \
    /usr/bin/transmission-daemon \
        --foreground \
        --config-dir /config \
        --log-level "${TRANSMISSION_LOG_LEVEL:-info}" \
        "$@"
