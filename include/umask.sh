#!/usr/bin/env bash

if [[ -n "${UMASK}" && "${UMASK}" =~ ^[0-7]{3,4}$ ]]; then
    umask "${UMASK}"
fi
