#!/usr/bin/env bash

export USER="stash"

dirs=(
    /config/plugins
    /config/scrapers
)

for dir in "${dirs[@]}"; do
    find "${dir}" -type f -name "requirements.txt" | while read -r reqfile; do
        target_dir="$(dirname "$reqfile")"
        echo "Installing Python requirements from: ${reqfile}"
        uv pip install --requirement "${reqfile}" --target "${target_dir}"
    done
done

exec /app/stash "$@"
