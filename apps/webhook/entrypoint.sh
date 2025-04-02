#!/usr/bin/env bash

HOOKS_FILE="/config/hooks.yaml"
if [[ -f /config/hooks.json ]]; then
    HOOKS_FILE="/config/hooks.json"
fi

exec \
    /app/bin/webhook \
    -port "${WEBHOOK__PORT}" \
    -urlprefix "${WEBHOOK__URLPREFIX}" \
    -hooks "${HOOKS_FILE}" \
    -template \
    -verbose \
    "$@"
