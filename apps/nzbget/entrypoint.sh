#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="/config/nzbget.conf"

if [[ ! -f "${CONFIG_FILE}" ]]; then
    cp /app/nzbget.conf "${CONFIG_FILE}"
    sed -i \
        -e "s|^MainDir=.*|MainDir=/config|g" \
        -e "s|^ScriptDir=.*|ScriptDir=$\{MainDir\}/scripts|g" \
        -e "s|^WebDir=.*|WebDir=$\{AppDir\}/webui|g" \
        -e "s|^ConfigTemplate=.*|ConfigTemplate=$\{AppDir\}/webui/nzbget.conf.template|g" \
        -e "s|^UnrarCmd=.*|UnrarCmd=unrar|g" \
        -e "s|^SevenZipCmd=.*|SevenZipCmd=7z|g" \
        -e "s|^DestDir=.*|DestDir=$\{MainDir\}/completed|g" \
        -e "s|^InterDir=.*|InterDir=$\{MainDir\}/intermediate|g" \
        -e "s|^LogFile=.*|LogFile=$\{MainDir\}/nzbget.log|g" \
        -e "s|^AuthorizedIP=.*|AuthorizedIP=127.0.0.1|g" \
        -e "s|^ShellOverride=.*|ShellOverride=.py=/usr/bin/python3;.sh=/bin/bash|g" \
        "${CONFIG_FILE}"
fi

if [[ -f /config/nzbget.lock ]]; then
    rm /config/nzbget.lock
fi

OPTIONS=(-o OutputMode=log)
[[ -n "${NZBGET_PORT:-}" ]] && OPTIONS+=(-o "ControlPort=${NZBGET_PORT}")
[[ -n "${NZBGET_USER:-}" ]] && OPTIONS+=(-o "ControlUsername=${NZBGET_USER}")
[[ -n "${NZBGET_PASS:-}" ]] && OPTIONS+=(-o "ControlPassword=${NZBGET_PASS}")
[[ -n "${NZBGET_RESTRICTED_USER:-}" ]] && OPTIONS+=(-o "RestrictedUsername=${NZBGET_RESTRICTED_USER}")
[[ -n "${NZBGET_RESTRICTED_PASS:-}" ]] && OPTIONS+=(-o "RestrictedPassword=${NZBGET_RESTRICTED_PASS}")

exec /app/nzbget \
    --server \
    --configfile "${CONFIG_FILE}" \
    "${OPTIONS[@]}" \
    "$@"
