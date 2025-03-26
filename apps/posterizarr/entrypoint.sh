#!/bin/sh
set -e

## Check if config.json exists
if [ -f "/config/config.json" ]; then
    echo "Found config.json"
    # Ensure proper permissions for config files
    echo "Setting proper permissions for config files"
    chmod 644 /config/config.json
else
    echo "WARNING: Check env vars for VIRTUAL_ENV its required"
    # Check if it exists in a nested location
    if [ -f "/config/config/config.json" ]; then
        echo "Found config.json in nested directory, moving to correct location"
        cp /config/config/config.json /config/
        chmod 644 /config/config.json
    fi
fi

# Remove running file if it exists
if [ -f "/config/temp/Posterizarr.Running" ]; then
    rm /config/temp/Posterizarr.Running
fi

exec pwsh -File /config/Posterizarr.ps1 "$@"
