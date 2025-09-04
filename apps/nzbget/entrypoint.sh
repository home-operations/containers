#!/usr/bin/env bash

CONFIG_FILE="/config/nzbget.conf"

if [[ ! -f "${CONFIG_FILE}" ]]; then
    mkdir -p "${CONFIG_FILE%/*}"
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

OPTIONS=""
if [ ! -z "${NZBGET_USER}" ]; then
    OPTIONS="${OPTIONS}-o ControlUsername=${NZBGET_USER} "
fi
if [ ! -z "${NZBGET_PASS}" ]; then
    OPTIONS="${OPTIONS}-o ControlPassword=${NZBGET_PASS} "
fi
if [ ! -z "${NZBGET_RESTRICTED_USER}" ]; then
    OPTIONS="${OPTIONS}-o RestrictedUsername=${NZBGET_RESTRICTED_USER} "
fi
if [ ! -z "${NZBGET_RESTRICTED_PASS}" ]; then
    OPTIONS="${OPTIONS}-o RestrictedPassword=${NZBGET_RESTRICTED_PASS} "
fi

exec \
    /app/nzbget \
        --server \
        --option "OutputMode=log" \
        --configfile "${CONFIG_FILE}" \
        ${OPTIONS} \
        "$@"
