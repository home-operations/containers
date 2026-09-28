#!/usr/bin/env bash

exec \
    /usr/local/bin/python \
        /app/bin/bazarr.py \
            --no-update True \
            --config /config \
            --port ${BAZARR__PORT} \
            "$@"
