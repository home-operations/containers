#!/usr/bin/env bash

THELOUNGE_HOME="${THELOUNGE_HOME:-/config/thelounge}"

mkdir -p "${THELOUNGE_HOME}/users"

if [[ -n "${THELOUNGE_USER}" && -n "${THELOUNGE_PASSWORD}" && ! -f "${THELOUNGE_HOME}/users/${THELOUNGE_USER}.json" ]]; then
    node /app/node_modules/thelounge/index.js add "${THELOUNGE_USER}" --password "${THELOUNGE_PASSWORD}"
fi

# The Lounge keeps the first occurrence of a --config key, so "$@" goes
# first to let container args override these env-provided defaults
exec \
    node /app/node_modules/thelounge/index.js \
        start \
        "$@" \
        --config port="${THELOUNGE_PORT:-9000}" \
        --config messageStorage="${THELOUNGE_MESSAGE_STORAGE:-[sqlite]}" \
        --config storagePolicy.enabled="${THELOUNGE_STORAGE_POLICY_ENABLED:-true}" \
        --config storagePolicy.maxAgeDays="${THELOUNGE_STORAGE_POLICY_MAX_AGE_DAYS:-30}" \
        --config storagePolicy.deletionPolicy="${THELOUNGE_STORAGE_POLICY_DELETION_POLICY:-everything}"
