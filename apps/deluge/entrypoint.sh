#!/usr/bin/env bash
#shellcheck disable=SC2086,SC2090

if [[ ! -f /config/core.conf ]]; then
    cp /defaults/core.conf /config/core.conf
    sed -i -e "s/58846/${DELUGE_DAEMON_PORT:-58846}/" /config/core.conf
fi

mkdir -p /config/plugins/.python-eggs

OPTS=(
    "--do-not-daemonize"
    "--config" "/config"
    "--loglevel" "${DELUGE_LOGLEVEL:-info}"
    "--interface" "0.0.0.0"
)

if [[ ${DELUGE_BIN:-deluged} == "deluged" ]]; then
    OPTS+=("--ui-interface" "0.0.0.0")
    OPTS+=("--port" "${DELUGE_DAEMON_PORT:-58846}")
elif [[ ${DELUGE_BIN:-deluged} == "deluge-web" ]]; then
    OPTS+=("--port" "${DELUGE_WEB_PORT:-8112}")
fi

exec ${DELUGE_BIN:-deluged} "${OPTS[@]}" "$@"
