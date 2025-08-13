#!/usr/bin/env bash

if [[ ! -f /config/core.conf ]]; then
    cp /defaults/core.conf /config/core.conf
fi

mkdir -p /config/plugins/.python-eggs

DELUGE_OPTS=(
    "--do-not-daemonize"
    "--config" "/config"
)

if [[ ${DELUGE_BIN} == "deluged" ]]; then
    DELUGE_OPTS+=("--loglevel" "info")
elif [[ ${DELUGE_BIN} == "deluge-web" ]]; then
    DELUGE_OPTS+=("--loglevel" "warning")
fi

exec ${DELUGE_BIN} "${DELUGE_OPTS[@]}" "$@"
