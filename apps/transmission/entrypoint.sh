#!/usr/bin/env bash
#shellcheck disable=SC2086

if [[ "${TRANSMISSION__USE_ENV}" == "true" ]]; then
    minijinja-cli --env /defaults/settings.json.j2 > /config/settings.json
fi

exec \
    /usr/bin/transmission-daemon \
        --foreground \
        --config-dir /config \
        --log-level "${TRANMISSIONS__LOG_LEVEL:-info}" \
        --port "${TRANSMISSION__RPC_PORT:-9091}" \
        "$@"
