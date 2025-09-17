#!/usr/bin/env sh

if [ ! -f /config/settings/pyload.cfg ]; then
    mkdir /config/settings
    cp /defaults/pyload.cfg /config/settings/pyload.cfg
fi

exec \
    python3 -m pyload \
        --userdir /config \
        --storagedir /downloads \
        --tempdir /tmp/pyload \
        "$@"
