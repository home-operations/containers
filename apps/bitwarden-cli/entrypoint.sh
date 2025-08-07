#!/bin/bash

set -e

export BW_PORT=${BW_PORT:=8087}
export BITWARDENCLI_APPDATA_DIR=$(mktemp -d)

bw config server "${BW_HOST}"

export BW_SESSION=$(bw login ${BW_USER} --passwordenv BW_PASSWORD --raw)

bw unlock --check

echo "Running 'bw server' on port ${BW_PORT}"
bw serve --port ${BW_PORT} --hostname 0.0.0.0 
#--disable-origin-protection (DONT USE THIS IN PRODUCTION, IT IS INSECURE, CSRF PROTECTION IS DISABLED)
