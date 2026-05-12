#!/usr/bin/env bash

if [[ ${KOPIA_WEB_ENABLED} == "true" ]]; then
    exec \
        /usr/local/bin/kopia \
            server \
            start \
            --insecure \
            --address "0.0.0.0:${KOPIA_WEB_PORT}" \
	        --allow-extremely-dangerous-unauthenticated-server-on-the-network \
            "$@"
else
    exec \
        /usr/local/bin/kopia \
            "$@"
fi
