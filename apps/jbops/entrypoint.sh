#!/usr/bin/env bash
set -euo pipefail

exec \
    /usr/local/bin/python \
        "/app/${JBOPS__SCRIPT_PATH}" \
        "$@"
