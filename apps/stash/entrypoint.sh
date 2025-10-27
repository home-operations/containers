#!/usr/bin/env bash

export USER="stash"

dirs=(
  /config/plugins
  /config/scrapers
)

for dir in "${dirs[@]}"; do
  find "$dir" -type f -name "requirements.txt" | while read -r reqfile; do
    target_dir="$(dirname "$reqfile")"
    echo "Installing Python requirements from: $reqfile"
    pip install --target "$target_dir" --no-cache-dir --break-system-packages -r "$reqfile"
  done
done

exec /app/stash "@"
