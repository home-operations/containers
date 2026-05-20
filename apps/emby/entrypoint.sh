#!/usr/bin/env bash

APP_DIR="/app"

export AMDGPU_IDS="${APP_DIR}/extra/share/libdrm/amdgpu.ids"
export FONTCONFIG_PATH="${APP_DIR}/etc/fonts"
export LD_LIBRARY_PATH="${APP_DIR}/lib:${APP_DIR}/extra/lib"
export OCL_ICD_VENDORS="${APP_DIR}/extra/etc/OpenCL/vendors"
export PCI_IDS_PATH="${APP_DIR}/share/hwdata/pci.ids"
export SSL_CERT_FILE="${APP_DIR}/etc/ssl/certs/ca-certificates.crt"
if [ -d "/lib/x86_64-linux-gnu" ]; then
    export LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri:${APP_DIR}/extra/lib/dri"
fi

exec \
    "${APP_DIR}/system/EmbyServer" \
        -programdata /config \
        -ffdetect "${APP_DIR}/bin/ffdetect" \
        -ffmpeg "${APP_DIR}/bin/ffmpeg" \
        -ffprobe "${APP_DIR}/bin/ffprobe" \
        -restartexitcode 3 \
        "$@"
