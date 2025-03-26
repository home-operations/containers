#!/bin/sh

# Needed as the default config expects these
# files to be in the "config directory"
cp /app/*.png /app/config
cp /app/*.ttf /app/config

# Execute the main application
exec pwsh -File /app/Posterizarr.ps1 "$@"
