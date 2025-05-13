#!/usr/bin/env bash

mkdir -p /config/logs

if [[ ! -f /config/nzbhydra.yml ]]; then
    cp /defaults/nzbhydra.yml /config/nzbhydra.yml
fi

exec \
    java \
        -DfromWrapper \
        -noverify \
        -XX:TieredStopAtLevel=1 \
        -XX:+HeapDumpOnOutOfMemoryError \
        -XX:HeapDumpPath=/config/logs \
        -Xlog:gc:/config/logs/gclog-"$(date +"%F_%H-%M-%S")".log::filecount=5,filesize=5000 \
        -Dspring.output.ansi.enabled=ALWAYS \
        -Dsun.security.pkcs11.enable-solaris=false \
        -Dfile.encoding=UTF8 \
        -DinternalApiKey="${NZBHYDRA2__API_KEY:-}" \
        -jar /app/bin/nzbhydra2.jar \
        --datafolder /config \
        "$@"
