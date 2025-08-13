#!/usr/bin/env bash

if [[ ${KOPIA_WEB_ENABLED} == "true" ]]; then
    exec \
        /app/bin/kopia \
            server \
            start \
            --insecure \
            --address "0.0.0.0:${KOPIA_WEB_PORT}" \
            "$@"
else
    exec \
        /app/bin/kopia \
            "$@"
fi
