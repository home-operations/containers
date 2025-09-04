#!/usr/bin/env bash
set -euo pipefail

exec \
    /app/bin/jackett \
        --NoUpdates \
        --ListenPublic \
        "$@"
