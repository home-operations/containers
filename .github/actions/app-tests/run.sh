#!/usr/bin/env bash
set -Eeuo pipefail

APP="${1:?}"
IMAGE="${2:?}"

if [[ -x "$(command -v container-structure-test)" ]]; then
    container-structure-test test --image "${IMAGE}" --config "./apps/${APP}/tests.yaml"
elif [[ -x "$(command -v goss)" && -x "$(command -v dgoss)" ]]; then
    export GOSS_FILE="./apps/${APP}/tests.yaml"
    export GOSS_OPTS="--retry-timeout 60s --sleep 1s"
    dgoss run "${IMAGE}"
else
    echo "No testing tool found. Exiting."
    exit 1
fi
