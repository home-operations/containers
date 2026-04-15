#!/usr/bin/env sh

mkdir -p "${TUDUDI_UPLOAD_PATH:-/config/uploads}"

exec /app/backend/cmd/start.sh "$@"
