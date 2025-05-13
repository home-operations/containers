#!/usr/bin/env bash

exec \
    /usr/local/bin/python \
        /app/Tautulli.py \
        --nolaunch \
        --port ${TAUTULLI__PORT} \
        --config /config/config.ini \
        --datadir /config \
        "$@"
