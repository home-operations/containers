#!/usr/bin/env bash

exec \
    /usr/local/bin/python \
        /app/Tautulli.py \
        --nolaunch \
        --config /config/config.ini \
        --datadir /config \
        "$@"
