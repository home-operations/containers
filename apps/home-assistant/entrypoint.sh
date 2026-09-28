#!/usr/bin/env bash

# Requirements of custom integrations are installed into the venv at runtime, and uv
# installs their full dependency closure there, including copies of packages the image
# already ships. Rebuild the venv whenever the image changes so those copies never go stale.
image="$(python3 -c 'from importlib.metadata import version; print(version("homeassistant"))')-$(uname -m)"
if [[ "$(cat "${VENV_FOLDER}/.image" 2>/dev/null)" != "${image}" ]]; then
    rm -rf "${VENV_FOLDER}"
    uv venv --system-site-packages "${VENV_FOLDER}"
    echo "${image}" > "${VENV_FOLDER}/.image"
fi
source "${VENV_FOLDER}/bin/activate"

exec \
    python3 -P -m homeassistant \
        --config /config \
        "$@"
