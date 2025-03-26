#!/bin/sh
set -e

# Check for test mode
if [ "$1" = "--test" ] || [ "$POSTERIZARR_TEST_MODE" = "true" ]; then
    echo "Running in test mode - skipping PowerShell script execution"
    echo "Container is ready for testing"

    # Keep container running for tests
    if [ "$1" = "--test" ]; then
        echo "Container will stay alive for testing"
        # Sleep indefinitely to keep container running for tests
        exec tail -f /dev/null
    fi
    exit 0
fi

# Check if Posterizarr.ps1 exists
if [ -f "/config/Posterizarr.ps1" ]; then
    echo "Found Posterizarr.ps1 script"
else
    echo "ERROR: Posterizarr.ps1 not found in /config!"
    exit 1
fi

## Check if config.json exists
if [ -f "/config/config.json" ]; then
    echo "Found config.json"
    # Ensure proper permissions for config files
    echo "Setting proper permissions for config files"
    chmod 644 /config/config.json
else
    echo "WARNING: config.json not found in /config!"
    # Check if it exists in a nested location
    if [ -f "/config/config/config.json" ]; then
        echo "Found config.json in nested directory, moving to correct location"
        cp /config/config/config.json /config/
        chmod 644 /config/config.json
    fi
fi

# Remove running file if it exists
if [ -f "/config/temp/Posterizarr.Running" ]; then
    echo "Found Posterizarr.Running, removing it"
    rm /config/temp/Posterizarr.Running
fi


# Print debugging information
echo "Current user: $(whoami)"
echo "VIRTUAL_ENV: $VIRTUAL_ENV"
echo "POWERSHELL_DISTRIBUTION_CHANNEL: $POWERSHELL_DISTRIBUTION_CHANNEL"
echo "Working directory: $(pwd)"
echo "Contents of /config:"
ls -la /config

# Verify ImageMagick delegates
echo "Checking ImageMagick delegates:"
magick -list format | grep JPEG
echo "ImageMagick version:"
magick -version

# Execute the PowerShell script with any parameters passed to this script
echo "Starting Posterizarr with parameters: $@"
exec pwsh -File /config/Posterizarr.ps1 "$@"
