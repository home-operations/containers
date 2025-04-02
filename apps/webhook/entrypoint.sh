#!/usr/bin/env bash

exec \
    /app/bin/webhook \
    -port "${WEBHOOK__PORT}" \
    -urlprefix "${WEBHOOK__URLPREFIX}" \
    -verbose \
    "$@"
