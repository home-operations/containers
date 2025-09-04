#!/usr/bin/env bash
set -euo pipefail

exec \
    /usr/local/bin/python \
        /app/bin/bazarr.py \
            --no-update True \
            --config /config \
            --port ${BAZARR__PORT} \
            "$@"
