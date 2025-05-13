#!/usr/bin/env bash

exec \
    /app/bin/Sonarr \
        --nobrowser \
        --data=/config \
        "$@"
