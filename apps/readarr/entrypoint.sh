#!/usr/bin/env bash

exec \
    /app/bin/Readarr \
        --nobrowser \
        --data=/config \
        "$@"
