#!/usr/bin/env bash
set -euo pipefail

APP="${1:?}"
IMAGE="${2:?}"

if yq --exit-status '.schemaVersion' "./apps/${APP}/tests.yaml" &>/dev/null; then
    container-structure-test test --image "${IMAGE}" --config "./apps/${APP}/tests.yaml"
else
    export GOSS_FILE="./apps/${APP}/tests.yaml"
    export GOSS_OPTS="--retry-timeout 60s --sleep 1s"
    ./.bin/dgoss run "${IMAGE}"
fi
