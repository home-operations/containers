#!/usr/bin/env bash
#shellcheck disable=SC2086,SC2090

if [[ ! -f /config/core.conf ]]; then
    cp /defaults/core.conf /config/core.conf
fi

exec \
    ${DELUGE_BIN:-deluged} \
    --do-not-daemonize \
    --config /config \
    --loglevel=${DELUGE_LOGLEVEL:-info} \
    "$@"
