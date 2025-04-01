#!/usr/bin/env bash
#shellcheck disable=SC2086

exec \
    /opt/emby-server/bin/emby-server \
        --programdata "/config" \
        "$@"
