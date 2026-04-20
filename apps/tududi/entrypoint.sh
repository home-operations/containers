#!/usr/bin/env bash

mkdir -p "${TUDUDI_UPLOAD_PATH:-/config/uploads}"

exec /app/backend/cmd/start.sh "$@"
