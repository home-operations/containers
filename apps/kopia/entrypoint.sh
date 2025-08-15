#!/usr/bin/env bash

if [[ ${KOPIA_WEB_ENABLED} == "true" ]]; then
    exec \
        /usr/local/bin/kopia \
            server \
            start \
            --insecure \
            --address "0.0.0.0:${KOPIA_WEB_PORT}" \
            "$@"
else
    exec \
        /usr/local/bin/kopia \
            "$@"
fi
