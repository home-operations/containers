#!/bin/bash
set -e

exec /opt/emby-server/bin/emby-server \
    --programdata "/config" \
    "$@"