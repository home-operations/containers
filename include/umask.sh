#!/usr/bin/env bash

if [[ -n "${UMASK}" ]]; then
    if [[ "${UMASK}" =~ ^[0-7]{4}$ ]]; then
        umask "${UMASK}"
    else
        echo "Error: Invalid umask value '${UMASK}'. It must be a four-digit octal number."
    fi
fi
