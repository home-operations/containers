#!/bin/bash
set -e

echo "Setting up ImageMagick for Posterizarr"

# Check for ImageMagick in /usr/local/bin (installed from source in Dockerfile)
if [ -f "/usr/local/bin/magick" ]; then
    echo "Found ImageMagick in /usr/local/bin:"
    /usr/local/bin/magick -version

    # Create a fallback script in /config for the PowerShell script to find
    echo '#!/bin/bash' > /config/magick
    echo '/usr/local/bin/magick "$@"' >> /config/magick
    chmod +x /config/magick
    echo "Created fallback magick script at /config/magick"

    # Also ensure convert command is available for backward compatibility
    if [ ! -f "/usr/local/bin/convert" ]; then
        echo "Creating convert compatibility link"
        ln -sf /usr/local/bin/magick /usr/local/bin/convert
    fi

    # Ensure identify command is available
    if [ ! -f "/usr/local/bin/identify" ]; then
        echo "Creating identify compatibility link"
        ln -sf /usr/local/bin/magick /usr/local/bin/identify
    fi

    # Create identify fallback script in /config
    echo '#!/bin/bash' > /config/identify
    echo '/usr/local/bin/magick identify "$@"' >> /config/identify
    chmod +x /config/identify
    echo "Created fallback identify script at /config/identify"
else
    echo "ERROR: ImageMagick not found in /usr/local/bin!"
    echo "Checking PATH for any ImageMagick binaries:"
    which magick || echo "magick command not found in PATH"
    which convert || echo "convert command not found in PATH"
    which identify || echo "identify command not found in PATH"

    echo "Creating empty magick script in /config as fallback"
    echo '#!/bin/bash' > /config/magick
    echo 'echo "ERROR: ImageMagick not properly installed"' >> /config/magick
    echo 'exit 1' >> /config/magick
    chmod +x /config/magick

    echo "Creating empty identify script in /config as fallback"
    echo '#!/bin/bash' > /config/identify
    echo 'echo "ERROR: ImageMagick not properly installed"' >> /config/identify
    echo 'exit 1' >> /config/identify
    chmod +x /config/identify
fi

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

# Remove weird is running check
if [ -f "/config/temp/Posterizarr.Running" ]; then
    echo "Found Posterizarr.Running"
    rm /config/temp/Posterizarr.Running
fi

# Execute the PowerShell script with any parameters passed to this script
echo "Starting Posterizarr with parameters: $@"
exec pwsh -File /config/Posterizarr.ps1 "$@"
