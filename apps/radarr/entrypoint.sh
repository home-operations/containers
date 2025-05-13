#!/usr/bin/env bash

exec \
    /app/bin/Radarr \
        --nobrowser \
        --data=/config \
        "$@"
