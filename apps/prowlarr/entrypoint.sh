#!/usr/bin/env bash

exec \
    /app/bin/Prowlarr \
        --nobrowser \
        --data=/config \
        "$@"
