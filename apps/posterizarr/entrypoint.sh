#!/bin/sh
set -e

## Check if config.json exists
if [ -f "/config/config.json" ]; then
    chmod 644 /config/config.json
fi

# Remove running file if it exists
rm /config/temp/Posterizarr.Running || true

exec pwsh -File /config/Posterizarr.ps1 "$@"
