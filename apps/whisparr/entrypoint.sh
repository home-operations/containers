#!/usr/bin/env bash

exec \
    /app/bin/Whisparr \
        --nobrowser \
        --data=/config \
        "$@"
