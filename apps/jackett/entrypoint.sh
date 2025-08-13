#!/usr/bin/env bash

exec \
    /app/bin/jackett \
        --NoUpdates \
        --ListenPublic \
        "$@"
