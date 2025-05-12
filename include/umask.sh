#!/usr/bin/env bash

# Set default umask value if UMASK is not set or invalid
UMASK="${UMASK:-0002}"
if [[ ! "${UMASK}" =~ ^[0-7]{4}$ ]]; then
    echo "Error: Invalid umask value. Using default value 0002."
    UMASK="0002"
fi

# Apply the umask
umask "${UMASK}"
