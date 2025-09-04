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
[[ -n "${NZBGET__PORT:-}" ]] && OPTIONS+=(-o "ControlPort=${NZBGET__PORT}")
[[ -n "${NZBGET__USER:-}" ]] && OPTIONS+=(-o "ControlUsername=${NZBGET__USER}")
[[ -n "${NZBGET__PASS:-}" ]] && OPTIONS+=(-o "ControlPassword=${NZBGET__PASS}")
[[ -n "${NZBGET__RESTRICTED_USER:-}" ]] && OPTIONS+=(-o "RestrictedUsername=${NZBGET__RESTRICTED_USER}")
[[ -n "${NZBGET__RESTRICTED_PASS:-}" ]] && OPTIONS+=(-o "RestrictedPassword=${NZBGET__RESTRICTED_PASS}")

exec /app/nzbget \
    --server \
    --configfile "${CONFIG_FILE}" \
    "${OPTIONS[@]}" \
    "$@"
