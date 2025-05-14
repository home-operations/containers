#!/usr/bin/env bash

# Validate that UMASK is a 3- or 4-digit octal number (0-7) used for file permission settings.
if [[ -n "${UMASK}" && "${UMASK}" =~ ^[0-7]{3,4}$ ]]; then
    umask "${UMASK}"
fi
