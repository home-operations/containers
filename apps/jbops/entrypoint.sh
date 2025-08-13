#!/usr/bin/env bash

exec \
    /usr/local/bin/python \
        "/app/${JBOPS__SCRIPT_PATH}" \
        "$@"
